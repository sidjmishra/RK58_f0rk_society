import 'dart:math';

import 'package:block/modal/constants.dart';
import 'package:block/views/JailManagement/jailData.dart';
import 'package:block/views/Profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:block/Animation/FadeAnimation.dart';
import 'package:block/services/auth.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class JailManage extends StatefulWidget {
  @override
  _JailManageState createState() => _JailManageState();
}

class _JailManageState extends State<JailManage> {

  final _formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  bool isLoading = false;

  TextEditingController name = TextEditingController();
  TextEditingController add_1 = TextEditingController();
  TextEditingController add_2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController userContact = TextEditingController();
  TextEditingController dateCtl = TextEditingController();
  TextEditingController state = TextEditingController();

  final _states = ['Andhra Pradesh', 'Arunachal Pradesh', 'Assam',	'Bihar', 'Chhattisgarh', 'Delhi', 'Goa',
    'Gujarat', 'Haryana',	'Himachal Pradesh',	'Jammu and kashmir',	'Ladakh',	'Jharkhand',	'Karnataka',
    'Kerala',	'Madhya Pradesh',	'Maharashtra', 'Manipur',	'Meghalaya', 'Mizoram',	'Nagaland', 'Odisha',	'Punjab',
    'Rajasthan', 'Sikkim',	'Tamil Nadu',	'Telangana', 'Tripura',	'Uttarakhand', 'Uttar Pradesh', 'West Bengal',
    'Andaman and Nicobar', 'Chandigarh', 'Dadra and Nagar Haveli', 'Daman and Diu', 'Lakshadweep'];
  final _issueCategory = ['Infrastructure', 'Food', 'Management', 'Staff Behaviour'];
  final _category = ['Police', 'Canteen Staff', 'Working Staff', 'Visitor'];
  String hintCategory = 'Select Role';
  String hintState = 'Select State';
  String hintIssue = 'Select Issue';
  var _currentSelectedCategory;
  var _currentSelectedState;
  var pickedCountryName;
  DateTime pickedDate;
  var pickedCountry;
  var _currentIssue;
  var officeName;
  var stateName;
  var selection;
  var category;
  var issue;
  var id;
  String subLocal;

  void resetForm() {
    name.clear();
    dateCtl.clear();
    amount.clear();
    add_1.clear();
    add_2.clear();
    city.clear();
    userContact.clear();
    pincode.clear();
    details.clear();
    _currentSelectedCategory = null;
    _currentIssue = null;
    _currentSelectedState = null;
    pickedCountry = null;
    pickedCountryName = null;
  }

  void randomId() async {
    var number = Random.secure();
    QuerySnapshot dataID;

    id = Constants.myUid.substring(0, 4) + number.nextInt(9999).toString();
    dataID = await Firestore.instance.collection('Jail Management').document(Constants.myUid).collection('all_data').getDocuments();
    if(dataID.documents.isNotEmpty) {
      for(var index = 0; index < dataID.documents.length; index++) {
        if(dataID.documents[index].data['id'] == id && id.length < 8) {
          setState(() {
            id = Constants.myUid.substring(0, 4) + number.nextInt(9999).toString();
          });
        }
      }
    }
    print(id);
  }

  @override
  void initState() {
    randomId();
    super.initState();
  }

  void setData() {
    if (pickedCountryName == null && pickedCountry == null) {
      pickedCountry = '+91';
      pickedCountryName = 'India';
    }
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      JailDatabase(uid: Constants.myUid)
          .userSubmitted(
          id,
          Constants.myEmail,
          name.text,
          _currentSelectedCategory,
          _currentIssue,
          add_1.text,
          add_2.text,
          city.text,
          pincode.text,
          _currentSelectedState,
          userContact.text,
          details.text,
          dateCtl.text,
          pickedCountry.toString(),
          pickedCountryName.toString())
          .then((value) {
        Alert(
            context: context,
            type: AlertType.success,
            title: 'Data Submitted',
            desc:
            'Report with id: $id\nCategory: $_currentSelectedCategory\nIssue Category: $_currentIssue\n'
                'UserName: ${Constants.myName}, Email: ${Constants.myEmail}\n\n'
                '(Would recommend to take screenshot of it)',
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Jail Management',
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
      body: HotConstants.myPhone == null
          ? Column(
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
                      'Report',
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
                      'Fill details about the complain!',
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
                            Text(
                              'Role of Applicant',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1,
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Color.fromRGBO(225, 95, 27, .3),
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
                                      child: DropdownButton<String>(
                                        items: _category.map(
                                                (String dropDownStringItem) {
                                              return DropdownMenuItem<String>(
                                                value: dropDownStringItem,
                                                child:
                                                Text(dropDownStringItem),
                                              );
                                            }).toList(),
                                        value: _currentSelectedCategory,
                                        onChanged:
                                            (String newValueSelected) {
                                          setState(() {
                                            _currentSelectedCategory =
                                                newValueSelected;
                                          });
                                        },
                                        hint: Text(
                                          hintCategory,
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
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Text(
                              'Issue Category',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1,
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Color.fromRGBO(225, 95, 27, .3),
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
                                      child: DropdownButton<String>(
                                        items: _issueCategory.map(
                                                (String dropDownStringItem) {
                                              return DropdownMenuItem<String>(
                                                value: dropDownStringItem,
                                                child: Text(dropDownStringItem),
                                              );
                                            }).toList(),
                                        value: _currentIssue,
                                        onChanged:
                                            (String newValueSelected) {
                                          setState(() {
                                            _currentIssue =
                                                newValueSelected;
                                          });
                                        },
                                        hint: Text(
                                          hintIssue,
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
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Text(
                              'Applicant Name',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Color.fromRGBO(225, 95, 27, .3),
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
                                      validator: (value) {
                                        if (value.isEmpty ||
                                            value.length < 6) {
                                          return 'Please Enter Full Name';
                                        }
                                        return null;
                                      },
                                      controller: name,
                                      maxLength: 30,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Full Name',
                                        hintStyle: TextStyle(
                                            color: Colors.grey[300]),
                                        border: InputBorder.none,
                                        counterText: '',
                                      ),
                                      //TextInputType.multiline,
                                      maxLines: null,
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
                              'Address of Prison',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Color.fromRGBO(225, 95, 27, .3),
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
                                      validator: (value) {
                                        if (value.isEmpty ||
                                            value.length < 6) {
                                          return 'Please Enter address';
                                        }
                                        return null;
                                      },
                                      controller: add_1,
                                      maxLength: 100,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Address Line 1',
                                        hintStyle: TextStyle(
                                            color: Colors.grey[300]),
                                        border: InputBorder.none,
                                        counterText: '',
                                      ),
                                      //TextInputType.multiline,
                                      maxLines: null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          FadeAnimation(
                            1.3,
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Color.fromRGBO(225, 95, 27, .3),
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
                                              value.length < 6) {
                                            return 'Please Enter address';
                                          }
                                          return null;
                                        },
                                        controller: add_2,
                                        maxLength: 100,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: 'Address Line 2',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[300]),
                                          border: InputBorder.none,
                                          counterText: '',
                                        ),
                                        //TextInputType.multiline,
                                        maxLines: null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Color.fromRGBO(225, 95, 27, .3),
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
                                              value.length < 3) {
                                            return 'Please Enter city';
                                          }
                                          return null;
                                        },
                                        controller: city,
                                        maxLength: 20,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: 'City/Locality',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[300]),
                                          border: InputBorder.none,
                                          counterText: '',
                                        ),
                                        //TextInputType.multiline,
                                        maxLines: null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: FadeAnimation(
                                  1.3,
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              225, 95, 27, .3),
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
                                            child: DropdownButton<String>(
                                              items: _states.map((String
                                              dropDownStringItem) {
                                                return DropdownMenuItem<
                                                    String>(
                                                  value:
                                                  dropDownStringItem,
                                                  child: Text(
                                                      dropDownStringItem),
                                                );
                                              }).toList(),
                                              value:
                                              _currentSelectedState,
                                              onChanged: (String
                                              newValueSelected) {
                                                setState(() {
                                                  _currentSelectedState =
                                                      newValueSelected;
                                                });
                                              },
                                              hint: Text(
                                                hintState,
                                                style: TextStyle(
                                                    color:
                                                    Colors.grey[300]),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 1,
                                child: FadeAnimation(
                                  1.3,
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              225, 95, 27, .3),
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
                                                    color:
                                                    Colors.grey[300]),
                                              ),
                                            ),
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value.isEmpty ||
                                                    value.length < 6) {
                                                  return 'Please Enter valid pincode';
                                                }
                                                return null;
                                              },
                                              controller: pincode,
                                              maxLength: 6,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: 'Pincode',
                                                hintStyle: TextStyle(
                                                    color:
                                                    Colors.grey[300]),
                                                border: InputBorder.none,
                                                counterText: '',
                                              ),
                                              //TextInputType.multiline,
                                              maxLines: null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          FadeAnimation(
                            1.3,
                            Text(
                              'Details of Incident',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          FadeAnimation(
                            1.3,
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Color.fromRGBO(225, 95, 27, .3),
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
                                              value.length < 6) {
                                            return 'Please Enter details';
                                          }
                                          return null;
                                        },
                                        controller: details,
                                        maxLength: 300,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText:
                                          'Give Details About the Incident/Complain',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[300]),
                                          border: InputBorder.none,
                                          counterText: '',
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
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Text(
                              'Date',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Color.fromRGBO(225, 95, 27, .3),
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
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please Enter date';
                                        }
                                        return null;
                                      },
                                      controller: dateCtl,
                                      textAlign: TextAlign.center,
                                      onTap: () async {
                                        DateTime date = DateTime(2000);
                                        FocusScope.of(context)
                                            .requestFocus(
                                            FocusNode());
                                        date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                        );
                                        dateCtl.text = date
                                            .toIso8601String()
                                            .substring(0, 10);
                                      },
                                      maxLength: 10,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Enter the Date',
                                        hintStyle: TextStyle(
                                            color: Colors.grey[300]),
                                        border: InputBorder.none,
                                        counterText: '',
                                      ),
                                      maxLines: null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Text(
                              'Contact Details',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Color.fromRGBO(225, 95, 27, .3),
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
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: <Widget>[
                                                ListTile(
                                                  title:
                                                  _buildCountryPickerDropdown(
                                                      hasPriorityList:
                                                      true),
                                                  dense: true,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                                margin:
                                EdgeInsets.symmetric(horizontal: 5),
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
                              Container(
                                height: 50,
                                width: 125,
                                margin:
                                EdgeInsets.symmetric(horizontal: 5),
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

  _buildCountryPickerDropdown(
      {bool filtered = false,
        bool sortedByIsoCode = false,
        bool hasPriorityList = false,
        bool hasSelectedItemBuilder = false}) {
    double dropdownButtonWidth = MediaQuery.of(context).size.width * 0.4;
    //respect dropdown button icon size
    double dropdownItemWidth = dropdownButtonWidth - 50;
    double dropdownSelectedItemWidth = dropdownButtonWidth - 70;
    return Row(
      children: <Widget>[
        SizedBox(
          width: dropdownButtonWidth - 10,
          child: CountryPickerDropdown(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            itemHeight: null,
            isDense: false,
            selectedItemBuilder: hasSelectedItemBuilder == true
                ? (Country country) => _buildDropdownSelectedItemBuilder(
                country, dropdownSelectedItemWidth)
                : null,
            itemBuilder: (Country country) => hasSelectedItemBuilder == true
                ? _buildDropdownItemWithLongText(country, dropdownItemWidth)
                : _buildDropdownItem(country, dropdownItemWidth),
            initialValue: 'IN',
            itemFilter: filtered
                ? (c) => ['IN', 'US', 'GB', 'UAE'].contains(c.isoCode)
                : null,
            priorityList: hasPriorityList
                ? [
              CountryPickerUtils.getCountryByIsoCode('IN'),
            ]
                : null,
            sortComparator: sortedByIsoCode
                ? (Country a, Country b) => a.isoCode.compareTo(b.isoCode)
                : null,
            onValuePicked: (Country country) {
              print('${country.name}');
              pickedCountry = country.phoneCode;
              pickedCountryName = country.name;
              if (country == null) {
                pickedCountry = '+91';
                pickedCountryName = 'India';
              }
            },
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty || value.length < 10) {
                return 'Please Enter valid phone number';
              }
              return null;
            },
            controller: userContact,
            decoration: InputDecoration(
              hintText: 'Phone',
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintStyle: TextStyle(color: Colors.grey[300]),
              counterText: '',
            ),
            keyboardType: TextInputType.number,
            maxLength: 10,
          ),
        )
      ],
    );
  }

  Widget _buildDropdownItem(Country country, double dropdownItemWidth) =>
      SizedBox(
        width: dropdownItemWidth,
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
                flex: 1,
                child: Text(
                  '+${country.phoneCode}(${country.isoCode})',
                  style: TextStyle(fontSize: 15),
                )),
          ],
        ),
      );

  Widget _buildDropdownItemWithLongText(
      Country country, double dropdownItemWidth) =>
      SizedBox(
        width: dropdownItemWidth,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              SizedBox(
                width: 8.0,
              ),
              Expanded(child: Text('${country.name}')),
            ],
          ),
        ),
      );

  Widget _buildDropdownSelectedItemBuilder(
      Country country, double dropdownItemWidth) =>
      SizedBox(
        width: dropdownItemWidth,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                  child: Text(
                    '${country.name}',
                    style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      );
}
