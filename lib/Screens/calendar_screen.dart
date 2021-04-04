import 'package:app1/models/post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Meeting> meetings;
  String userID = '';
  String userType = '';
  final dbRef = FirebaseDatabase.instance.reference();
  List<Post> posts = new List<Post>();

  @override
  void initState() {
    super.initState();
    getId();
  }

  getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = prefs.getString('id');
    String str2 = prefs.getString('userType');
    setState(() {
      userID = str;
      userType = str2;
    });
    return str;
  }

  bool alreadyExists(Post newPost, List<Post> postsList) {
    for (Post post in postsList) {
      if (newPost.postID == post.postID) {
        return true;
      }
    }
    return false;
  }

  Future getPostsUser() async {
    List<Post> postsList = new List<Post>();
    await dbRef.child('Topics').once().then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> topics = dataSnapshot.value;
      if (topics != null) {
        topics.forEach((name, topicDetails) {
          if (topicDetails.containsKey('Subscribers')) {
            topicDetails['Subscribers'].forEach((id, sub) {
              if (topicDetails.containsKey('Posts')) {
                topicDetails['Posts'].forEach((idPost, postDetails) {
                  List<String> tags = new List<String>();
                  Post post = new Post();
                  post.postID = idPost;
                  post.description = postDetails['Description'];
                  post.title = postDetails['Title'];
                  post.userID = postDetails['UserID'];
                  post.location = postDetails['Location'];
                  post.date = postDetails['Date'];
                  post.userName = postDetails['UserName'];
                  if (postDetails.containsKey('Personal')) {
                    post.personal = true;
                  }
                  postDetails['Tags'].forEach((tag, ok) {
                    tags.add(tag);
                  });
                  post.topic = postDetails['Topic'];
                  post.tags = tags;
                  if (post.personal) {
                    if (userID == post.userID &&
                        !alreadyExists(post, postsList)) {
                      postsList.add(post);
                    }
                  } else if (id == userID && !alreadyExists(post, postsList)) {
                    postsList.add(post);
                  }
                });
              }
            });
          }
        });
      }
    });
    postsList.sort((a, b) {
      return a.date.compareTo(b.date);
    });
    posts = postsList;
  }

  Future getPostsAdmin() async {
    List<Post> postsList = new List<Post>();
    await dbRef.child('Topics').once().then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> topics = dataSnapshot.value;
      if (topics != null) {
        topics.forEach((name, topicDetails) {
          if (topicDetails.containsKey('Posts')) {
            topicDetails['Posts'].forEach((id, postDetails) {
              if (postDetails['UserID'] == userID) {
                List<String> tags = new List<String>();
                Post post = new Post();
                post.postID = id;
                post.description = postDetails['Description'];
                post.title = postDetails['Title'];
                post.userID = postDetails['UserID'];
                post.location = postDetails['Location'];
                post.date = postDetails['Date'];
                postDetails['Tags'].forEach((tag, ok) {
                  tags.add(tag);
                });
                post.topic = postDetails['Topic'];
                post.tags = tags;
                post.userName = postDetails['UserName'];
                if (post.personal) {
                  if (userID == post.userID) {
                    postsList.add(post);
                  }
                } else {
                  postsList.add(post);
                }
              }
            });
          }
        });
      }
    });
    postsList.sort((a, b) {
      return a.date.compareTo(b.date);
    });
    posts = postsList;
  }

  List<Meeting> _getDataSource() {
    final formatter = DateFormat('yyyy-MM-dd');
    //userType == 'admin' ? getPostsAdmin() : getPostsUser();
    List<Meeting> meetings = new List<Meeting>();
    DateTime date, startTime, endTime;
    for (Post post in posts) {
      date = formatter.parse(post.date);
      startTime = DateTime(date.year, date.month, date.day, 9, 0, 0);
      endTime = startTime.add(const Duration(hours: 2));
      meetings.add(Meeting(
          post.title, startTime, endTime, const Color(0xFF0F8644), true));
    }

    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: userType == 'admin' ? getPostsAdmin() : getPostsUser(),
        builder: (context, snapshot) {
          return Scaffold(
            body: Container(
              padding: EdgeInsets.all(25.0),
              child: SfCalendar(
                view: CalendarView.month,
                monthViewSettings: MonthViewSettings(showAgenda: true),
                dataSource: MeetingDataSource(_getDataSource()),
                //monthViewSettings: MonthViewSettings(
                // appointmentDisplayMode:
                //  MonthAppointmentDisplayMode.appointment),
              ),
            ),
          );
        });
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
