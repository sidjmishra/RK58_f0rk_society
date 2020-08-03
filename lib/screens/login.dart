import 'package:aharyaadmin/home.dart';
import 'package:aharyaadmin/screens/reset.dart';
import 'package:aharyaadmin/services/auth.dart';
import 'package:aharyaadmin/services/location.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  final Function toggle;
  LogIn(this.toggle);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  AuthMethods authMethods = new AuthMethods();
  Location location = Location();

  final _formKey = GlobalKey<FormState>();
  String subLocal;
  String email;
  String password;
  bool isLoading = false;

  TextEditingController userNameText = new TextEditingController();
  TextEditingController emailText = new TextEditingController();
  TextEditingController passwordText = new TextEditingController();

  @override
  void initState() {
    super.initState();
    locator();
  }

  void locator() {
    setState(() {
      location.getCurrentLocation();
      subLocal = '${location.subLocal}: ${location.feature}';
    });
  }

  signMeIn() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      if (userNameText.text == 'Aharya@admin2513') {
        authMethods
            .signInWithEmailAndPassword(emailText.text, passwordText.text)
            .then((value) {
          print('$value');
          email = emailText.text;
          password = passwordText.text;

          print('$email \n $password');
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => HomePage()
          ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
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
                  SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Welcome!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height * (0.9),
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
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[300]),
                                          ),
                                        ),
                                        child: TextFormField(
                                          validator: (val) {
                                            return val.isEmpty || val.length < 2
                                                ? "Please Enter Proper UserName"
                                                : null;
                                          },
                                          controller: userNameText,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            hintText: "Username",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[300]),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),

                                // Email
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
                                                : "Enter correct email";
                                          },
                                          controller: emailText,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            hintText: "Email Address",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[300]),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),

                                // Password
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
                                                ? "Enter Password 6+ characters"
                                                : null;
                                          },
                                          controller: passwordText,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          decoration: InputDecoration(
                                            hintText: "Password",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[300]),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
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
                                SizedBox(height: 10),
                                Container(
                                  height: 40,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orange[900],
                                  ),
                                  child: Center(
                                    child: FlatButton(
                                      onPressed: () {
                                        signMeIn();
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
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 1,
                                  width: 100,
                                  child: Container(
                                    color: Colors.orange,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  height: 40,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orange[900],
                                  ),
                                  child: Center(
                                    child: FlatButton(
                                      onPressed: () {
                                        widget.toggle();
                                      },
                                      child: Text(
                                        'Sign Up',
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
