import 'package:app1/Screens/main_screen.dart';
import 'package:app1/Screens/signup_screen.dart';
import 'package:app1/utilities/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String errorMessage = '';
  String userType = '';
  String userID = '';
  String userName = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future addIdToSP(String id, String name, String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
    prefs.setString('name', name);
    prefs.setString('userType', userType);
  }

  void setErrorMessage(String msg) {
    setState(() {
      errorMessage = msg;
    });
  }

  bool emptyTF() {
    if (emailController.text == '' || passwordController.text == '') {
      setState(() {
        errorMessage = 'Please, fill in all textfields';
      });
      return false;
    }
    return true;
  }

  Widget _buildEmailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 10.0),
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
          height: 60.0,
          child: TextField(
            controller: emailController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
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

  Widget _buildPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 10.0),
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
          height: 60.0,
          child: TextField(
            controller: passwordController,
            obscureText: true,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
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

  Widget _buildLogInButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => {
          logIn(),
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LogIn',
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

  Widget _buildSignUpButton() {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUp())),
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign up! ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorText() {
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

  logIn() async {
    if (!emptyTF()) {
    } else {
      FirebaseAuthHelper authHelper = new FirebaseAuthHelper();
      AuthResultStatus status = await authHelper.login(
          email: emailController.text, pass: passwordController.text);
      if (status == AuthResultStatus.successful) {
        setState(() {
          errorMessage = '';
        });
        userType = authHelper.userType;
        userName = authHelper.userName;
        userID = authHelper.userID;
        await addIdToSP(userID, userName, userType);
        emailController.text = '';
        passwordController.text = '';
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        setErrorMessage(errorMsg);
      }
    }
  }

  // logIn() async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(
  //             email: emailController.text, password: passwordController.text);
  //     if (userCredential != null) {
  //       dynamic dbUser = dbRef.child('User').child(userCredential.user.uid);
  //       await dbUser.once().then((DataSnapshot dataSnapshot) {
  //         Map<dynamic, dynamic> values = dataSnapshot.value;
  //         userType = values['tipUser'];
  //         userName = values['Name'];
  //       });
  //       userID = userCredential.user.uid;
  //       await addIdToSP(userID, userName);
  //       if (userType == 'admin') {
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => AdminScreen()));
  //       } else {
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => UserScreen()));
  //       }
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //     } else {
  //       print(e.code);
  //     }
  //   }
  // }

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
                vertical: 120.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Log in',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  _buildEmailTextField(),
                  SizedBox(height: 30.0),
                  _buildPasswordTextField(),
                  _buildLogInButton(),
                  _buildSignUpButton(),
                  _buildErrorText(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
