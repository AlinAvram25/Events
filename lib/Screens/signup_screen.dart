import 'package:app1/Screens/main_screen.dart';
import 'package:app1/utilities/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dbRef = FirebaseDatabase.instance.reference();
  String errorMessage = '';
  bool isVisible = false;
  bool admin = false;
  String userID = '';
  String userName = '';

  Future addIdToSP(String id, String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
    prefs.setString('name', userName);
    if (admin) {
      prefs.setString('userType', 'admin');
    } else {
      prefs.setString('userType', 'user');
    }
  }

  bool matchPass() {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage =
            'Fields \'password\' and \'confirm password\' must match';
      });
      return false;
    }

    return true;
  }

  bool emptyTF() {
    if (nameController.text == '' ||
        emailController.text == '' ||
        passwordController.text == '' ||
        confirmPasswordController.text == '') {
      setState(() {
        errorMessage = 'Please, fill in all textfields';
      });
      return false;
    }
    return true;
  }

  void setErrorMessage(String msg) {
    setState(() {
      errorMessage = msg;
    });
  }

  Widget _buildNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
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
          height: 50.0,
          child: TextField(
            controller: nameController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Enter your first and last name',
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
          height: 50.0,
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
          height: 50.0,
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

  Widget _buildConfirmPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirm password',
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
          height: 50.0,
          child: TextField(
            controller: confirmPasswordController,
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

  Widget _buildSignUpButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => {
          signUp(),
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Sign Up',
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

  Widget _buildLogInButton() {
    return GestureDetector(
      onTap: () => {
        Navigator.pop(context),
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Log in! ',
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

  Widget _buildWrongPassword() {
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

  Widget _buildSwitch() {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text(
        'User ',
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
        ),
      ),
      Switch(
          value: admin,
          onChanged: (value) {
            setState(() {
              admin = !admin;
            });
          }),
      Text(
        ' Admin',
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
        ),
      ),
    ]);
  }

  signUp() async {
    if (!emptyTF()) {
    } else if (!matchPass()) {
    } else {
      FirebaseAuthHelper authHelper = new FirebaseAuthHelper();
      final status = await authHelper.createAccount(
          email: emailController.text, pass: passwordController.text);
      if (status == AuthResultStatus.successful) {
        setState(() {
          errorMessage = '';
        });
        userName = nameController.text;
        userID = authHelper.userID;
        write(userID);
        await addIdToSP(userID, userName);
        nameController.text = '';
        emailController.text = '';
        passwordController.text = '';
        confirmPasswordController.text = '';

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        setErrorMessage(errorMsg);
      }
    }
  }

  // signUp() async {
  //   if (passwordController.text != confirmPasswordController.text) {
  //     wrongPass();
  //   } else {
  //     try {
  //       UserCredential userCredential = await FirebaseAuth.instance
  //           .createUserWithEmailAndPassword(
  //               email: emailController.text, password: passwordController.text);
  //       if (userCredential != null) {
  //         userID = userCredential.user.uid;
  //         userName = nameController.text;
  //         write(userID);
  //         addIdToSP(userID, userName);
  //         if (admin)
  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (context) => AdminScreen()));
  //         else
  //           Navigator.push(
  //               context, MaterialPageRoute(builder: (context) => UserScreen()));
  //       }
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'weak-password') {
  //         weakPass();
  //       } else if (e.code == 'email-already-in-use') {
  //         emailInUse();
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }

  void write(String userID) {
    String tipUser;
    if (admin) {
      tipUser = 'admin';
    } else {
      tipUser = 'user';
    }
    dbRef
        .child('User')
        .child(userID)
        .set({'tipUser': tipUser, 'Name': nameController.text});
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
                vertical: 40.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  _buildNameTextField(),
                  SizedBox(height: 15.0),
                  _buildEmailTextField(),
                  SizedBox(height: 15.0),
                  _buildPasswordTextField(),
                  SizedBox(height: 15.0),
                  _buildConfirmPasswordTextField(),
                  SizedBox(height: 15.0),
                  _buildSwitch(),
                  _buildSignUpButton(),
                  _buildLogInButton(),
                  _buildWrongPassword(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
