import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';

class ManageSubsScreen extends StatefulWidget {
  @override
  _ManageSubsScreenState createState() => _ManageSubsScreenState();
}

class _ManageSubsScreenState extends State<ManageSubsScreen> {
  String userID = '';
  List<String> topics = new List<String>();
  final dbRef = FirebaseDatabase.instance.reference();
  List<bool> _isChecked;
  AsyncMemoizer _memoizer;

  @override
  void initState() {
    super.initState();
    setState(() {
      getTopics();
      getSubscriptions();
    });
    _memoizer = AsyncMemoizer();
    getId();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      getTopics();
      getSubscriptions();
    });
  }

  getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = prefs.getString('id');
    setState(() {
      userID = str;
    });
    return str;
  }

  Future getSubscriptions() async {
    return this._memoizer.runOnce(() async {
      await Future.delayed(Duration(milliseconds: 100));
      await dbRef
          .child('User')
          .child(userID)
          .child('Subscriptions')
          .once()
          .then((DataSnapshot dataSnapshot) {
        Map<dynamic, dynamic> subscriptions = dataSnapshot.value;
        if (subscriptions != null)
          subscriptions.forEach((name, value) {
            for (int i = 0; i < topics.length; i++) {
              if (topics[i] == name) {
                setState(() {
                  _isChecked[i] = true;
                });
              }
            }
          });
      });
    });
  }

  Future getTopics() async {
    return this._memoizer.runOnce(() async {
      await Future.delayed(Duration(milliseconds: 200));
      List<String> list = new List<String>();
      await dbRef.child('Topics').once().then((DataSnapshot dataSnapshot) {
        Map<dynamic, dynamic> topics = dataSnapshot.value;
        topics.forEach((name, topicDetails) {
          list.add(name);
        });
      });
      topics = list;
      _isChecked = List<bool>.filled(topics.length, false);
      await Future.delayed(Duration(milliseconds: 100));
      await dbRef
          .child('User')
          .child(userID)
          .child('Subscriptions')
          .once()
          .then((DataSnapshot dataSnapshot) {
        Map<dynamic, dynamic> subscriptions = dataSnapshot.value;
        if (subscriptions != null)
          subscriptions.forEach((name, value) {
            for (int i = 0; i < topics.length; i++) {
              if (topics[i] == name) {
                setState(() {
                  _isChecked[i] = true;
                });
              }
            }
          });
      });
    });
  }

  void updateSubscriptions() async {
    Map<String, int> map = new Map<String, int>();
    for (int i = 0; i < topics.length; i++) {
      if (_isChecked[i] == true) {
        map.putIfAbsent(topics[i], () => 1);
        await dbRef
            .child('Topics')
            .child(topics[i])
            .child('Subscribers')
            .update({
          userID: 1,
        });
      } else {
        await dbRef
            .child('Topics')
            .child(topics[i])
            .child('Subscribers')
            .child(userID)
            .remove();
      }
    }
    await dbRef.child('User').child(userID).child('Subscriptions').set(map);
  }

  Widget _buildSaveButton() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: 50.0),
      child: Container(
        width: 100.0,
        height: 50.0,
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () => {
            updateSubscriptions(),
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.white,
          child: Text(
            'Save',
            style: TextStyle(
              color: Color(0xFF07558a),
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }

  _buildList() {
    return topics.length != 0
        ? RefreshIndicator(
            child: Container(
              padding: EdgeInsets.only(
                top: 20.0,
                left: 20.0,
                right: 20.0,
                bottom: 200.0,
              ),
              height: double.infinity,
              child: ListView.builder(
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: CheckboxListTile(
                      title: Text(topics[index]),
                      value: _isChecked[index],
                      onChanged: (val) {
                        setState(
                          () {
                            _isChecked[index] = val;
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            onRefresh: getTopics,
          )
        : Center(
            child: Text(
              'Loading topics...',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getTopics(),
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
                _buildList(),
                _buildSaveButton(),
              ],
            ),
          );
        });
  }
}
