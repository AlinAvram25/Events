import 'package:basic_utils/basic_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewEvent extends StatefulWidget {
  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  String errorMessage = '';
  String userName = '';
  String userID = '';
  String userType = '';
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final tagsController = TextEditingController();
  final locationController = TextEditingController();
  final dbRef = FirebaseDatabase.instance.reference();
  List<String> topicsList = new List<String>();
  String selectedTopic;
  DateTime _dateTime;
  String _pickedDate = '';
  String _pickedDateString = '';
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    getId();
  }

  void updateDropdown() async {
    topicsList = await getTopics();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      updateDropdown();
    });
  }

  void invalidChars() {
    setState(() {
      errorMessage = '\'Tags\' can not contain: . \$ [ ] # /';
    });
  }

  void textfieldError() {
    setState(() {
      errorMessage = 'Please, fill in all textfields!';
    });
  }

  void dateError() {
    setState(() {
      errorMessage = 'Please, pick a date!';
    });
  }

  void topicError() {
    setState(() {
      errorMessage = 'Please, choose a topic!';
    });
  }

  Future getTopics() async {
    List<String> list = new List<String>();
    await dbRef.child('Topics').once().then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> topics = dataSnapshot.value;
      topics.forEach((name, topicDetails) {
        list.add(name);
      });
    });
    return list;
  }

  getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = prefs.getString('id');
    String name = prefs.getString('name');
    String type = prefs.getString('userType');
    setState(() {
      userID = str;
      userName = name;
      userType = type;
    });
    return str;
  }

  Widget _buildTitleTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Title',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xFFa3d1f0),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 50.0,
          child: TextField(
            controller: titleController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(8.0),
              hintText: 'Enter post title',
              hintStyle: TextStyle(
                color: Colors.white54,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Description',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xFFa3d1f0),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 50.0,
          child: TextField(
            controller: descController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(8.0),
              hintText: 'Enter post description',
              hintStyle: TextStyle(
                color: Colors.white54,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Tags',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xFFa3d1f0),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 50.0,
          child: TextField(
            controller: tagsController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(8.0),
              hintText: 'Enter post tags separated by space',
              hintStyle: TextStyle(
                color: Colors.white54,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Location',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xFFa3d1f0),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 50.0,
          child: TextField(
            controller: locationController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(8.0),
              hintText: 'Enter the location of the event',
              hintStyle: TextStyle(
                color: Colors.white54,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return FutureBuilder(
        future: getTopics(),
        builder: (context, snapshot) {
          return DropdownButton<String>(
            items: topicsList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: selectedTopic,
            hint: Text('Topic'),
            onChanged: (newValue) {
              setState(() {
                selectedTopic = newValue;
              });
            },
          );
        });
  }

  Widget _buildDateButton() {
    return Container(
      width: 150.0,
      child: RaisedButton(
        elevation: 2.0,
        onPressed: () => {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
          ).then((date) {
            setState(() {
              _dateTime = date;
              _pickedDate = 'You picked ' + formatter.format(_dateTime);
              _pickedDateString = formatter.format(_dateTime);
            });
          })
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  Icons.date_range,
                  color: Color(0xFF07558a),
                ),
              ),
              TextSpan(
                text: ' Pick date',
                style: TextStyle(
                  color: Color(0xFF07558a),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateString() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _pickedDate,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: 16.0,
            ),
          ),
        ]);
  }

  Widget _buildPostButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 45.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => {
          if (validation())
            {
              createPost(),
              Navigator.pop(context),
            }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Post Event!',
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

  Widget _buildError() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            errorMessage,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ]);
  }

  List<String> getTagsList() {
    List<String> list = new List<String>();
    String tag = '';
    String tagsStr = tagsController.text;
    for (int i = 0; i < tagsStr.length; i++) {
      if (tagsStr[i] != ' ') {
        tag = StringUtils.addCharAtPosition(tag, tagsStr[i], tag.length);
      } else if (tag != '') {
        list.add(tag);
        tag = '';
      }
    }
    if (tag != '') list.add(tag);
    return list;
  }

  bool validation() {
    int ok = 0;
    if (descController.text.isEmpty ||
        locationController.text.isEmpty ||
        titleController.text.isEmpty ||
        tagsController.text.isEmpty)
      ok = 1;
    else if (_pickedDateString == '') {
      ok = 2;
    } else if (selectedTopic == null) {
      ok = 3;
    }
    String tags = tagsController.text;
    for (int i = 0; i < tags.length; i++) {
      if (tags[i] == '.' ||
          tags[i] == '\$' ||
          tags[i] == '[' ||
          tags[i] == ']' ||
          tags[i] == '#' ||
          tags[i] == '/') {
        ok = 4;
      }
    }
    if (ok == 1) {
      textfieldError();
      return false;
    } else if (ok == 2) {
      dateError();
      return false;
    } else if (ok == 3) {
      topicError();
      return false;
    } else if (ok == 4) {
      invalidChars();
      return false;
    }
    return true;
  }

  void createPost() {
    try {
      List<String> tagsList = new List<String>();
      Map<String, int> map = new Map<String, int>();
      tagsList = getTagsList();
      var newPostRef =
          dbRef.child('Topics').child(selectedTopic).child('Posts').push();
      if (userType == 'admin') {
        newPostRef.set({
          'Description': descController.text,
          'Location': locationController.text,
          'Title': titleController.text,
          'Topic': selectedTopic,
          'UserID': userID,
          'Date': _pickedDateString,
          'UserName': userName,
        });

        for (String tag in tagsList) {
          map.putIfAbsent(tag, () => 1);
        }
        newPostRef.child('Tags').set(map);
      } else {
        newPostRef.set({
          'Description': descController.text,
          'Location': locationController.text,
          'Title': titleController.text,
          'Topic': selectedTopic,
          'UserID': userID,
          'Date': _pickedDateString,
          'UserName': userName,
          'Personal': 1,
        });

        for (String tag in tagsList) {
          map.putIfAbsent(tag, () => 1);
        }
        newPostRef.child('Tags').set(map);
      }
    } catch (e) {
      setState(() {
        errorMessage = e.mesage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 50.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'New post',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  _buildTitleTextField(),
                  SizedBox(height: 10.0),
                  _buildDescriptionTextField(),
                  SizedBox(height: 10.0),
                  _buildTagsTextField(),
                  SizedBox(height: 10.0),
                  _buildLocationTextField(),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          _buildDateButton(),
                          SizedBox(height: 10.0),
                          _buildDateString(),
                        ],
                      ),
                      SizedBox(width: 20.0),
                      _buildDropdown(),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  _buildPostButton(),
                  SizedBox(height: 10.0),
                  _buildError(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
