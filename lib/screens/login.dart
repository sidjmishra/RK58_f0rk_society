import 'package:block/Animation/FadeAnimation.dart';
import 'package:block/screens/signup.dart';
import 'package:block/services/auth.dart';
import 'package:block/services/location.dart';
import 'package:block/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:block/screens/reset.dart';
import 'package:block/components/transition.dart';

class LogIn extends StatefulWidget {
//  final Function toggle;
//  LogIn(this.toggle);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  AuthMethods authMethods = AuthMethods();
  Location location = Location();
  final _formKey = GlobalKey<FormState>();

  String subLocal = '';
  String email;
  String password;
  bool isLoading = false;

  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();

  @override
  void initState() {
    super.initState();
    locator();
  }

  void locator() {
    setState(() {
      location.getCurrentLocation();
      subLocal = '${location.subLocal}: ${location.feature}';
      print(subLocal);
    });
  }

  Future signMeIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods
          .signInWithEmailAndPassword(emailText.text, passwordText.text)
          .then((value) {
        print(value);
        if (value != 'error') {
          email = emailText.text;
          password = passwordText.text;
          print('$email \n $password');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      });
    }
    return 'error';
  }

  void googleLogin() {
    authMethods
        .handleSignIn()
        .then((FirebaseUser user) => load())
        .catchError((e) => print(e));
  }

  void load() {
    if (authMethods.stat == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomePage();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            begin: Alignment.topCenter,
//            colors: [
//              Color(0xff212832),
//              Color(0x212832),
//              Colors.orange[400],
//            ],
//          ),
          color: Color(0xff212832),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeAnimation(
                        1,
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      FadeAnimation(
                        1.3,
                        Text(
                          'Welcome!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(35),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),

                          // Email
                          FadeAnimation(
                            1.3,
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xff99D5D5),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  FadeAnimation(
                                    1.5,
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[300]),
                                        ),
                                      ),
                                      child: TextFormField(
                                        validator: (val) {
                                          return RegExp(
                                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(val)
                                              ? null
                                              : 'Enter correct email';
                                        },
                                        controller: emailText,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          hintText: 'Email Address',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[300]),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),

                          // Password
                          FadeAnimation(
                            1.3,
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xff99D5D5),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: FadeAnimation(
                                1.5,
                                Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[300]),
                                        ),
                                      ),
                                      child: TextFormField(
                                        obscureText: true,
                                        validator: (val) {
                                          return val.length < 6
                                              ? 'Enter Password 6+ characters'
                                              : null;
                                        },
                                        controller: passwordText,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration: InputDecoration(
                                          hintText: 'Password',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[300]),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
                          FadeAnimation(
                            1.4,
                            FlatButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ResetPassword();
                                }));
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          FadeAnimation(
                            1.7,
                            Container(
                              height: 40,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xff212832),
                              ),
                              child: Center(
                                child: FlatButton(
                                  onPressed: () async {
                                    var val = await signMeIn();
                                    print(val);
                                    if (val == 'error') {
                                      print('error recieved');
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(authMethods.errorMessage),
                                      ));
                                    }
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              locator();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FadeAnimation(
                                  1,
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  ),
                                ),
                                FadeAnimation(
                                  1,
                                  subLocal == 'null: null'
                                      ? Text('Get Location')
                                      : Text('$subLocal'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            height: 1,
                            width: 100,
                            child: Container(
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(height: 10),
                          FadeAnimation(
                            1.6,
                            Text(
                              'OR',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          FadeAnimation(
                            1.9,
                            Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 25),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Color(0xff32E0C3),
                                    ),
                                    child: Center(
                                      child: FlatButton.icon(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Transition()));
                                        },
                                        icon: Icon(
                                          AntDesign.google,
                                          color: Colors.blueGrey,
                                          size: 20,
                                        ),
                                        label: Text(
                                          'Google',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 25),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Color(0xff212832),
                                    ),
                                    child: Center(
                                      child: FlatButton(
                                        onPressed: () {
//                                          widget.toggle();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUp()));
                                        },
                                        child: Text(
                                          'SignUp',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }));
  }
}
