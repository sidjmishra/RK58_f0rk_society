import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:block/Animation/FadeAnimation.dart';
import 'package:block/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:block/services/database.dart';
import 'package:http/http.dart' as http;

class FeedbackPage extends StatefulWidget {
  FeedbackPage({this.type, this.uid});
  final String type;
  final String uid;
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  AuthMethods authMethods = AuthMethods();

  DataMethods data = DataMethods();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController feedback = TextEditingController();
  var rating;
  var ratingField = ['0', '1', '2', '3', '4', '5'];

  void resetForm() {
    feedback.text = null;
    rating = null;
  }

  void setData() async {
    print(widget.type);
    print(widget.uid);
    await data.submitFeedback(
      widget.uid,
      widget.type,
      feedback.text,
      rating,
    ).then((value) {
      sendAnalysis();
      Navigator.pop(context);
    });

  }

  Future sendAnalysis() async {
    Map data;
    String body;
    http.Response response;

    data = {
      'text': feedback.text,
      'api_key': '03guykFK7X7r8Xw7ABcSaIQjiAfgoir91cKtbANGCXU',
      'lang_code': 'en'
    };
    body = json.encode(data);

    response = await http.post(
      'https://apis.paralleldots.com/v4/sentiment',
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    print(response.statusCode);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Feedback',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(
                Icons.clear,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.teal[900],
              Colors.teal[800],
              Colors.teal[400],
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  FadeAnimation(
                    1,
                    Text(
                      'Feedback',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      )),
                  child: Padding(
                    padding: EdgeInsets.all(35),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          FadeAnimation(
                            1.3,
                            Text(
                              'Details of Service Provided',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
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
                                        validator: (value) {
                                          if (value.isEmpty ||
                                              value.length < 2) {
                                            return 'Please Enter Feedback of Experience';
                                          }
                                          return null;
                                        },
                                        controller: feedback,
                                        maxLength: 300,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: 'Feedback',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[300]),
                                          border: InputBorder.none,
                                        ),
                                        //TextInputType.multiline,
                                        maxLines: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          FadeAnimation(
                            1.3,
                            Text(
                              'Category',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          FadeAnimation(
                            1,
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
                                1,
                                Column(
                                  children: <Widget>[
                                    Container(
                                      child: DropdownButtonFormField<String>(
                                        items: ratingField
                                            .map((String dropDownStringItem) {
                                          return DropdownMenuItem<String>(
                                            value: dropDownStringItem,
                                            child: Text(dropDownStringItem),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                        validator: (_currentSelectedCategory) =>
                                            _currentSelectedCategory.isEmpty
                                                ? 'Field Required'
                                                : null,
                                        value: rating,
                                        onChanged: (String newValueSelected) {
                                          setState(() {
                                            rating = newValueSelected;
                                          });
                                        },
                                        hint: Text(
                                          'Please Rate Our Service',
                                          style: TextStyle(
                                              color: Colors.grey[300]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 50,
                                width: 125,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.teal[400],
                                ),
                                child: Center(
                                  child: FlatButton(
                                    onPressed: () {
                                      setData();
                                    },
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 125,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.red[400],
                                ),
                                child: Center(
                                  child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        resetForm();
                                      });
                                    },
                                    child: Text(
                                      'Reset',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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


