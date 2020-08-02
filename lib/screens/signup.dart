import 'package:block/Animation/FadeAnimation.dart';
import 'package:block/screens/login.dart';
import 'package:block/services/auth.dart';
import 'package:block/services/database.dart';
import 'package:block/views/Profile/profile.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
//  final Function toggle;
//  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  UserDatabaseServices userDatabaseServices = UserDatabaseServices();

  TextEditingController userNameText = TextEditingController();
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();

  String email;
  String password;

  Future signMeUp() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods
          .signUpWithEmailAndPassword(emailText.text, passwordText.text, userNameText.text)
          .then(
            (value) {
          print('$value');
          if (value != 'error') {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Profile()));
          }
        },
      );
    }
    return 'error';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.orange[900],
                  Colors.orange[800],
                  Colors.orange[400],
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                        1,
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
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

                              // UserName
                              FadeAnimation(
                                1.3,
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(225, 95, 27, .3),
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
                                              return val.isEmpty ||
                                                      val.length < 2
                                                  ? 'Please Enter Proper UserName'
                                                  : null;
                                            },
                                            controller: userNameText,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              hintText: 'Username',
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

                              // Email
                              FadeAnimation(
                                1.3,
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(225, 95, 27, .3),
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
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(225, 95, 27, .3),
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
                              SizedBox(height: 30),
                              FadeAnimation(
                                1.7,
                                GestureDetector(
                                  onTap: () async {
                                    var val = await signMeUp();
                                    if (val == 'error') {
                                      print('error received');
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(authMethods.err),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    margin: EdgeInsets.symmetric(horizontal: 50),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.orange[900],
                                    ),
                                    child: Center(
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
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 1,
                                width: 100,
                                child: Container(
                                  color: Colors.orange,
                                ),
                              ),
                              SizedBox(height: 10),
                              FadeAnimation(
                                1.7,
                                GestureDetector(
                                  onTap: () {
//                                    widget.toggle;
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) => LogIn()));
                                  },
                                  child: Container(
                                    height: 40,
                                    margin: EdgeInsets.symmetric(horizontal: 50),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.orange[400],
                                    ),
                                    child: Center(
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}