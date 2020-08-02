import 'dart:math';

import 'package:block/modal/constants.dart';
import 'package:block/views/DelayAction/delayData.dart';
import 'package:block/views/Profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:block/Animation/FadeAnimation.dart';
import 'package:block/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DelayAction extends StatefulWidget {
  @override
  _DelayActionState createState() => _DelayActionState();
}

class _DelayActionState extends State<DelayAction> {
  final _formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();

  TextEditingController complainID = TextEditingController();
  QuerySnapshot querySnapshot;

  final _application = [
    'Bribe Report',
    'FIR Reporting',
    'NCR Reporting',
    'NOC Filing'
  ];
  String hintApplication = 'Select Application Type';
  String complains = 'Select the id';
  var _currentComplains;
  var _currentApplication;
  bool isLoading = false;
  String subLocal;
  var id;

  List<String> bribeIDs = [];
  List<String> firIDs = [];
  List<String> ncrIDs = [];
  List<String> nocIDs = [];

  Future getComplainID(String coll, String col) async {
    DateTime dateNow;
    DateTime dateFile;
    dateNow = DateTime.now();

    querySnapshot = await Firestore.instance
        .collection(coll)
        .document(Constants.myUid)
        .collection(col)
        .getDocuments();
    for (var index = 0; index < querySnapshot.documents.length; index++) {
      dateFile =
          DateTime.parse(querySnapshot.documents[index].data['Date of Filing']);
      if (dateNow.difference(dateFile).inDays > 1) {
        if (coll == 'PaidBribe' && col == 'all_data') {
          bribeIDs.add(querySnapshot.documents[index].data['id'].toString());
        } else if (coll == 'FIR_NCR' && col == 'FIR') {
          firIDs.add(querySnapshot.documents[index].data['id'].toString());
        } else if (coll == 'FIR_NCR' && col == 'NCR') {
          ncrIDs.add(querySnapshot.documents[index].data['id'].toString());
        } else if (coll == 'NOC' && col == 'all_data') {
          nocIDs.add(querySnapshot.documents[index].data['id'].toString());
        } else {
          print('error');
        }
      }
    }
    print(bribeIDs);
  }

  void resetForm() {
    complainID.clear();
    _currentApplication = null;
  }

  void randomId() async {
    var number = Random.secure();
    QuerySnapshot dataID;

    id = Constants.myUid.substring(0, 4) + number.nextInt(9999).toString();
    dataID = await Firestore.instance
        .collection('Delay in Actions')
        .document(Constants.myUid)
        .collection('all_data')
        .getDocuments();
    if (dataID.documents.isNotEmpty) {
      for (var index = 0; index < dataID.documents.length; index++) {
        if (dataID.documents[index].data['id'] == id && id.length < 8) {
          setState(() {
            id = Constants.myUid.substring(0, 4) +
                number.nextInt(9999).toString();
          });
        }
      }
    }
    print(id);
  }

  void setData() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      DelayDatabase(uid: Constants.myUid)
          .userSubmitted(
        id,
        Constants.myEmail,
        HotConstants.myFullName,
        HotConstants.myPhone,
        HotConstants.myUID,
        complainID.text,
        _currentApplication,
      )
          .then((value) {
        Alert(
            context: context,
            type: AlertType.success,
            title: 'Data Submitted',
            desc: 'Report with id: $id\nCategory: $_currentApplication\n'
                'Full Name: ${HotConstants.myFullName}, Email: ${Constants.myEmail}\n\n'
                'Soon you will receive an email.(Would recommend to take screenshot of it)',
            buttons: [
              DialogButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ]).show();
        resetForm();
        randomId();
      });
    }
  }

  @override
  void initState() {
    randomId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Right to Information',
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
      body: HotConstants.myPhone == ''
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            Text('User Not verified'),
            SizedBox(height: 20.0),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => Profile()
                ));
              },
              color: Colors.orangeAccent,
              child: Text('Add Information'),
            ),
        ],
      ),
          ) : Container(
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
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  FadeAnimation(
                    1,
                    Text(
                      'Delay in Actions',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  FadeAnimation(
                    1.3,
                    Text(
                      'RTI Act in order to track your issued report',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
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
                                  Container(
                                    child: DropdownButton<String>(
                                      items: _application
                                          .map((String dropDownStringItem) {
                                        return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Text(dropDownStringItem),
                                        );
                                      }).toList(),
                                      value: _currentApplication,
                                      onChanged: (String newValueSelected) {
                                        setState(() {
                                          _currentApplication =
                                              newValueSelected;
                                          if (_currentApplication ==
                                              'Bribe Report') {
                                            getComplainID(
                                                'PaidBribe', 'all_data');
                                          } else if (_currentApplication ==
                                              'FIR Reporting') {
                                            getComplainID('FIR_NCR', 'FIR');
                                          } else if (_currentApplication ==
                                              'NCR Reporting') {
                                            getComplainID('FIR_NCR', 'NCR');
                                          } else if (_currentApplication ==
                                              'NOC Filing') {
                                            getComplainID('NOC', 'all_data');
                                          } else {
                                            print('Error');
                                          }
                                        });
                                      },
                                      hint: Text(
                                        hintApplication,
                                        style:
                                            TextStyle(color: Colors.grey[300]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          FadeAnimation(
                            1.3,
                            Text(
                              'Complain ID',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
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
                                _currentApplication == 'Bribe Report'
                                    ? Container(
                                        child: DropdownButton<String>(
                                          items: bribeIDs
                                              .map((String dropDownStringItem) {
                                            return DropdownMenuItem<String>(
                                              value: dropDownStringItem,
                                              child: Text(dropDownStringItem),
                                            );
                                          }).toList(),
                                          value: _currentComplains,
                                          onChanged: (String newValueSelected) {
                                            setState(() {
                                              _currentComplains =
                                                  newValueSelected;
                                            });
                                          },
                                          hint: Text(
                                            complains,
                                            style: TextStyle(
                                                color: Colors.grey[300]),
                                          ),
                                        ),
                                      )
                                    : _currentApplication == 'FIR Reporting'
                                        ? Container(
                                            child: DropdownButton<String>(
                                              items: firIDs.map(
                                                  (String dropDownStringItem) {
                                                return DropdownMenuItem<String>(
                                                  value: dropDownStringItem,
                                                  child:
                                                      Text(dropDownStringItem),
                                                );
                                              }).toList(),
                                              value: _currentComplains,
                                              onChanged:
                                                  (String newValueSelected) {
                                                setState(() {
                                                  _currentComplains =
                                                      newValueSelected;
                                                });
                                              },
                                              hint: Text(
                                                complains,
                                                style: TextStyle(
                                                    color: Colors.grey[300]),
                                              ),
                                            ),
                                          )
                                        : _currentApplication == 'NCR Reporting'
                                            ? Container(
                                                child: DropdownButton<String>(
                                                  items: ncrIDs.map((String
                                                      dropDownStringItem) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: dropDownStringItem,
                                                      child: Text(
                                                          dropDownStringItem),
                                                    );
                                                  }).toList(),
                                                  value: _currentComplains,
                                                  onChanged: (String
                                                      newValueSelected) {
                                                    setState(() {
                                                      _currentComplains =
                                                          newValueSelected;
                                                    });
                                                  },
                                                  hint: Text(
                                                    complains,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[300]),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                child: DropdownButton<String>(
                                                  items: nocIDs.map((String
                                                      dropDownStringItem) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: dropDownStringItem,
                                                      child: Text(
                                                          dropDownStringItem),
                                                    );
                                                  }).toList(),
                                                  value: _currentComplains,
                                                  onChanged: (String
                                                      newValueSelected) {
                                                    setState(() {
                                                      _currentComplains =
                                                          newValueSelected;
                                                    });
                                                  },
                                                  hint: Text(
                                                    complains,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[300]),
                                                  ),
                                                ),
                                              ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          HotConstants.myFullName == null
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
//                            height: MediaQuery.of(context).size.height * (0.4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                      color: Colors.orange[200],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Image.asset(
                                              'assets/playstore.png',
                                              width: 50.0,
                                              height: 50.0,
                                            ),
                                            SizedBox(width: 20.0),
                                            Text(
                                              'User Details',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        // Name
                                        Text(
                                          'No user data found. Please set the user profile',
                                          maxLines: 3,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
//                            height: MediaQuery.of(context).size.height * (0.4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                      color: Colors.orange[200],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Image.asset(
                                              'assets/playstore.png',
                                              width: 50.0,
                                              height: 50.0,
                                            ),
                                            SizedBox(width: 20.0),
                                            Text(
                                              'User Details',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        // Name
                                        Text(
                                          'Full Name: ' +
                                              HotConstants.myFullName,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        // Email
                                        Text(
                                          'Email: ' + Constants.myEmail,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          'User Identification: ' +
                                              HotConstants.myUID,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          'User Contact: ' +
                                              HotConstants.myPhone,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          'Status ID:' + id,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          SizedBox(height: 10),
                          Container(
                            height: 50,
                            width: 123,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.orange[400],
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

  Widget formDesign({Widget textData}) {
    return FadeAnimation(
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
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]),
                ),
              ),
              child: textData,
            ),
          ],
        ),
      ),
    );
  }
}
