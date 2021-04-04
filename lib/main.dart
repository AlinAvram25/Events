import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

import 'Screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'dart:async';
//import 'dart:io';

//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      debugShowCheckedModeBanner: false,
      home: LogIn(),
    );
  }
}

// class MessageHandler extends StatefulWidget {
//   @override
//   createState() => _MessageHandlerState();
// }

// class _MessageHandlerState extends State<MessageHandler> {
//   final Firestore _db = Firestore.instance;
//   final FirebaseMessaging _fcm = FirebaseMessaging();

//   @override
//   void initState() {
//     super.initState();

//     _fcm.subscribeToTopic('');
//     _fcm.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");

//         final snackbar = SnackBar(
//             content: Text(message['notification']['title']),
//             action: SnackBarAction(
//               label: 'Go',
//               onPressed: () => null,
//             ));
//         Scaffold.of(context).showSnackBar(snackbar);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return null;
//   }
// }
