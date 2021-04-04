import 'package:app1/models/post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final Post post = new Post();
  final dbRef = FirebaseDatabase.instance.reference();
  String _imageUrl = '';
  String errorMsg = '';
  String userID = '';
  String userType = '';

  void showErrorMsg() {
    setState(() {
      errorMsg = 'Only the host may delete the post!';
    });
  }

  @override
  void initState() {
    super.initState();
    var ref = FirebaseStorage.instance.ref().child('images.png');
    ref.getDownloadURL().then((loc) => setState(() => _imageUrl = loc));
    getPost();
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
  }

  getPost() async {
    List<String> tags = new List<String>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String postID = prefs.getString('postID');
    String postTitle = prefs.getString('postTitle');
    String postDesc = prefs.getString('postDesc');
    String postLoc = prefs.getString('postLoc');
    String postTopic = prefs.getString('postTopic');
    String postDate = prefs.getString('postDate');
    String userName = prefs.getString('UserName');
    bool personal = prefs.getBool('personal');
    tags = prefs.getStringList('tags');
    setState(() {
      post.postID = postID;
      post.title = postTitle;
      post.description = postDesc;
      post.tags = tags;
      post.location = postLoc;
      post.topic = postTopic;
      post.date = postDate;
      post.userName = userName;
      post.personal = personal;
    });
  }

  _deletePost() async {
    await dbRef
        .child('Topics')
        .child(post.topic)
        .child('Posts')
        .child(post.postID)
        .remove();
  }

  Widget _buildDeleteButton() {
    return userType == 'admin' || post.personal
        ? Container(
            padding: EdgeInsets.only(right: 25.0),
            width: 200.0,
            child: RaisedButton(
              elevation: 5.0,
              onPressed: () => {
                _deletePost(),
                Navigator.pop(context),
              },
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              child: Text(
                'Delete post',
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
        : Container();
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
                horizontal: 20.0,
                vertical: 120.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Image.network(
                          _imageUrl,
                          fit: BoxFit.cover,
                        ),
                        ListTile(
                          title: Text(post.title),
                          subtitle: !post.personal
                              ? Text(post.location +
                                  ' ' +
                                  post.date +
                                  '\nHost: ' +
                                  post.userName)
                              : Text(post.location +
                                  ' ' +
                                  post.date +
                                  '-personal event-'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            post.description +
                                '\n\n' +
                                'Tags: ' +
                                post.tags.toString(),
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  _buildDeleteButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
