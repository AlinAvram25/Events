import 'package:app1/Screens/calendar_screen.dart';
import 'package:app1/Screens/new_event_screen.dart';
import 'package:app1/Screens/post_screen.dart';
import 'package:app1/models/post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'manage_subs_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String userID = '';
  String userType = '';
  List<Post> posts = new List<Post>();
  final dbRef = FirebaseDatabase.instance.reference();
  IconData iconData;

  Future addPostToSP(Post post) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('postID', post.postID);
    preferences.setString('postTitle', post.title);
    preferences.setString('postDesc', post.description);
    preferences.setString('postLoc', post.location);
    preferences.setStringList('tags', post.tags);
    preferences.setString('postTopic', post.topic);
    preferences.setString('postDate', post.date);
    preferences.setString('UserName', post.userName);
    preferences.setBool('personal', post.personal);
  }

  _getIcon(Post post) {
    if (post.topic == 'Sport') {
      iconData = Icons.sports_soccer;
    } else if (post.topic == 'Culture') {
      iconData = Icons.account_balance;
    } else if (post.topic == 'Art') {
      iconData = Icons.music_note;
    }
  }

  @override
  void initState() {
    super.initState();
    getId();
  }

  Future updateListView() async {
    setState(() {
      userType == 'admin' ? getPostsAdmin() : getPostsUser();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      userType == 'admin' ? getPostsAdmin() : getPostsUser();
    });
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
                  DateFormat formatter = DateFormat('yyyy-MM-dd');
                  DateTime tomorrow = new DateTime(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day);
                  String tmr = formatter.format(tomorrow);

                  if (post.date.compareTo(tmr) < 0) {
                    dbRef
                        .child('Topics')
                        .child(post.topic)
                        .child('Posts')
                        .child(post.postID)
                        .remove();
                  } else {
                    if (post.personal) {
                      if (userID == post.userID &&
                          !alreadyExists(post, postsList)) {
                        postsList.add(post);
                      }
                    } else if (id == userID &&
                        !alreadyExists(post, postsList)) {
                      postsList.add(post);
                    }
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
                DateFormat formatter = DateFormat('yyyy-MM-dd');
                DateTime tomorrow = new DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day);
                String tmr = formatter.format(tomorrow);

                if (post.date.compareTo(tmr) < 0) {
                  dbRef
                      .child('Topics')
                      .child(post.topic)
                      .child('Posts')
                      .child(post.postID)
                      .remove();
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

  Widget _buildCalendarButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10.0, right: 10.0),
      width: 145,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CalendarScreen())),
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'View calendar',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF07558a),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalPostButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        top: 10.0,
      ),
      width: 145,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewEvent())),
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Add personal event',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF07558a),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildMainButton() {
    return userType == 'admin'
        ? Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 25.0),
            width: double.infinity,
            child: RaisedButton(
              elevation: 5.0,
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewEvent())),
              },
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              child: Text(
                'Add new event',
                style: TextStyle(
                  color: Color(0xFF07558a),
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          )
        : Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 25.0),
            width: double.infinity,
            child: RaisedButton(
              elevation: 5.0,
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageSubsScreen())),
              },
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              child: Text(
                'Manage subscriptions',
                style: TextStyle(
                  color: Color(0xFF07558a),
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          );
  }

  Widget _buildList() {
    return posts.length != 0
        ? RefreshIndicator(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                _getIcon(posts[index]);
                return Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 25.0,
                    ),
                    onTap: () {
                      addPostToSP(posts[index]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostScreen()));
                    },
                    title: Text(posts[index].title),
                    subtitle: !posts[index].personal
                        ? Text(posts[index].location +
                            ' ' +
                            posts[index].date +
                            '\nHost: ' +
                            posts[index].userName)
                        : Text(posts[index].location +
                            ' ' +
                            posts[index].date +
                            '\n-personal event-'),
                    trailing: Icon(iconData),
                  ),
                );
              },
            ),
            onRefresh: updateListView,
          )
        : Container(
            alignment: Alignment.topCenter,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Text(
                  'No posts loaded!',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  elevation: 5.0,
                  onPressed: () => {
                    setState(() {
                      userType == 'admin' ? getPostsAdmin() : getPostsUser();
                    }),
                  },
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.white,
                  child: Text(
                    'Refresh!',
                    style: TextStyle(
                      color: Color(0xFF07558a),
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ],
            ));
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: userType == 'admin' ? getPostsAdmin() : getPostsUser(),
        builder: (context, snapshot) {
          return Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF1a9af0),
                        Color(0xFF12E7DD),
                      ],
                      stops: [0.1, 0.9],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: 15.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      _buildMainButton(),
                      userType == 'user'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                  _buildCalendarButton(),
                                  _buildPersonalPostButton(),
                                ])
                          : _buildCalendarButton(),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 210.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: _buildList(),
                ),
              ],
            ),
          );
        });
  }
}
