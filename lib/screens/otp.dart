import 'dart:convert';
import 'dart:math';

import 'package:block/Animation/FadeAnimation.dart';
import 'package:block/modal/constants.dart';
import 'package:block/services/auth.dart';
import 'package:block/services/database.dart';
import 'package:block/views/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Otp extends StatefulWidget {

  final String phone;
  Otp({this.phone});

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController otpText = TextEditingController();

  AuthMethods authMethods = AuthMethods();
  UserDatabaseServices userDatabaseServices = UserDatabaseServices();

  var number = Random.secure();
  var id;
  void randomId() async {
    id = number.nextInt(999999).toString();
    if (id.length < 6) {
      setState(() {
        id = number.nextInt(999999).toString();
      });
    }
    print(id);
    await sendOtp(id);
  }

  Future sendOtp(var otp) async {
    Map data;
    String body;
    http.Response response;

    data = {
      'phoneNumber': '+91${widget.phone}',
      'message': 'The verification otp is $otp'
    };
    body = json.encode(data);

    response = await http.post(
      'https://a8p45lswv7.execute-api.us-east-1.amazonaws.com/api/otp',
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    print(response);
  }

  Future signMeUp() async {
    if (_formKey.currentState.validate() && otpText.text == id) {
      setState(() {
        isLoading = true;
      });

      await Firestore.instance
          .collection('User Details')
          .document(Constants.myUid)
          .updateData({'User': 'Verified'});
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      randomId();
    }
    return 'error';
  }

  @override
  void initState() {
    randomId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60), topRight: Radius.circular(60)),
        ),
        child: Padding(
          padding: EdgeInsets.all(35),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),

                  Center(
                    child: Text(
                      'You would receive an OTP on the phone number same as on Aadhar Card',
                      maxLines: 3,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),

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
                                  bottom: BorderSide(color: Colors.grey[300]),
                                ),
                              ),
                              child: TextFormField(
                                validator: (val) {
                                  return val.isEmpty &&
                                          val.length < 6 &&
                                          val == id
                                      ? 'Invalid OTP! Try again'
                                      : null;
                                },
                                controller: otpText,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Enter Otp',
                                  hintStyle: TextStyle(color: Colors.grey[300]),
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
                  FadeAnimation(
                    1.7,
                    GestureDetector(
                      onTap: () async {
                        var val = await signMeUp();
                        if (val == 'error') {
                          print('error recieved');
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
                          color: Color(0xff212832),
                        ),
                        child: Center(
                          child: Text(
                            'Verify',
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
    );
  }
}

//var val = await signMeUp();
//if (val == 'error') {
//print('error recieved');
//Scaffold.of(context).showSnackBar(
//SnackBar(
//content: Text(authMethods.err),
//),
//);
//}
