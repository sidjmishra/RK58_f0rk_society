import 'dart:math';

import 'package:block/modal/constants.dart';
import 'package:block/views/FirNcr/NCRData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:block/Animation/FadeAnimation.dart';
import 'package:block/services/auth.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NCRFiling extends StatefulWidget {
  final String typeReport;
  NCRFiling({this.typeReport});

  @override
  _NCRFilingState createState() => _NCRFilingState();
}

class _NCRFilingState extends State<NCRFiling> {
  final _formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  bool isLoading = false;

  TextEditingController fatherName = TextEditingController();
  TextEditingController add_1 = TextEditingController();
  TextEditingController add_2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController userContact = TextEditingController();
  TextEditingController suspectdesc = TextEditingController();
  TextEditingController idNumber = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController dateCtl = TextEditingController();

  final _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and kashmir',
    'Ladakh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttarakhand',
    'Uttar Pradesh',
    'West Bengal',
    'Andaman and Nicobar',
    'Chandigarh',
    'Dadra and Nagar Haveli',
    'Daman and Diu',
    'Lakshadweep'
  ];
  final _idType = ['Passport', 'PAN Card', 'Aadhar Card'];
  final _category = [
    'Theft',
    'Murder',
    'Dowry Death',
    'Rape',
    'Criminal Breach of Trust',
    'Unnatural offenses',
    'Attempting to wage war',
    'Kidnapping',
    'Other'
  ];
  final _categoryNCR = [
    'Forgery',
    'Pick Pocket',
    'Cheating',
    'Assault',
    'Other'
  ];
  String hintCategory = 'Select Category';
  String hintState = 'Select States';
  String hintID = 'Select UID type';
  var _currentSelectedCategory;
  var _currentSelectedState;
  var _currentSelectedID;
  var pickedCountryName;
  var pickedCountry;
  var stateName;
  String subLocal;
  var id;

  // Files
  List<String> urls = [];
  List _paths;
  String _extension;
  DateTime date = DateTime.now();

  Future openFileExplorer() async {
    try {
      StorageReference storageReference;
      StorageUploadTask storageUploadTask;
      _paths = await FilePicker.getMultiFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'svg', 'wav', 'mp4', 'pdf'],
      );
      _paths.forEach((filePath) async {
        _extension = filePath.toString().split('.').last;
        storageReference =
            FirebaseStorage.instance.ref().child('FIR_NCR');
        storageUploadTask = storageReference
            .child(date.toString() + '.$_extension')
            .putFile(filePath);
        String url =
        await (await storageUploadTask.onComplete).ref.getDownloadURL();
        setState(() {
          urls.add(url);
        });
        print(urls);
      });
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return;
    }
  }

  void randomId() async {
    var number = Random.secure();
    QuerySnapshot dataID;

    id = Constants.myUid.substring(0, 4) + number.nextInt(9999).toString();
    dataID = await Firestore.instance.collection('FIR_NCR').document(Constants.myUid).collection(widget.typeReport).getDocuments();
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

  void resetForm() {
    fatherName.clear();
    add_1.clear();
    add_2.clear();
    city.clear();
    userContact.clear();
    pincode.clear();
    details.clear();
    _currentSelectedCategory = null;
    _currentSelectedState = null;
    dateCtl.clear();
    _currentSelectedID = null;
    suspectdesc.clear();
    idNumber.clear();
    urls.clear();
  }

  @override
  void initState() {
    randomId();
    super.initState();
  }

  void setData() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      NCRDatabase(uid: Constants.myUid, type: widget.typeReport)
          .userSubmitted(
          id,
          Constants.myEmail,
          Constants.myName,
          _currentSelectedCategory,
          fatherName.text,
          add_1.text,
          add_2.text,
          city.text,
          pincode.text,
          _currentSelectedState,
          _currentSelectedID,
          idNumber.text,
          userContact.text,
          details.text,
          suspectdesc.text,
          dateCtl.text,
          urls)
          .then((value) {
        Alert(
            context: context,
            type: AlertType.success,
            title: 'Data Submitted',
            desc:
            'Report with id: $id\nCategory: $_currentSelectedCategory\nU.I.D Number: ${idNumber.text}'
                'UserName: ${Constants.myName}, Email: ${Constants.myEmail}\nFiles Submitted: ${urls.length}\n\n'
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
    if (pickedCountryName == null && pickedCountry == null) {
      pickedCountry = '+91';
      pickedCountryName = 'India';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '${widget.typeReport} Reporting',
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
                      'Fill details about the incident!',
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
                    //
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(
                            1.3,
                            Text(
                              'Category of Offence',
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
                                      items: widget.typeReport == 'FIR'
                                          ? _category
                                          .map((String dropDownStringItem) {
                                        return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Text(dropDownStringItem),
                                        );
                                      }).toList()
                                          : _categoryNCR
                                          .map((String dropDownStringItem) {
                                        return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Text(dropDownStringItem),
                                        );
                                      }).toList(),
                                      value: _currentSelectedCategory,
                                      onChanged: (String newValueSelected) {
                                        setState(() {
                                          _currentSelectedCategory =
                                              newValueSelected;
                                        });
                                      },
                                      hint: Text(
                                        hintCategory,
                                        style:
                                        TextStyle(color: Colors.grey[300]),
                                      ),
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
                              'Date of Event',
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
                                        bottom:
                                        BorderSide(color: Colors.grey[300]),
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
                                            .requestFocus(FocusNode());
                                        date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                        );
                                        dateCtl.text = date
                                            .toIso8601String()
                                            .substring(0, 10);
                                        print(dateCtl);
                                      },
                                      maxLength: 10,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Enter the Date',
                                        hintStyle:
                                        TextStyle(color: Colors.grey[300]),
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
                              'User Father/Husband Name',
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
                                        bottom:
                                        BorderSide(color: Colors.grey[300]),
                                      ),
                                    ),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please Enter name';
                                        }
                                        return null;
                                      },
                                      controller: fatherName,
                                      maxLength: 100,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText:
                                        'Complainant\'s Father/Husband Name',
                                        hintStyle:
                                        TextStyle(color: Colors.grey[300]),
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
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Text(
                              'Complainant Address',
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
                                        bottom:
                                        BorderSide(color: Colors.grey[300]),
                                      ),
                                    ),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty &&
                                            value.length < 10) {
                                          return 'Please Enter address';
                                        }
                                        return null;
                                      },
                                      controller: add_1,
                                      maxLength: 100,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Address Line 1',
                                        hintStyle:
                                        TextStyle(color: Colors.grey[300]),
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
                                        bottom:
                                        BorderSide(color: Colors.grey[300]),
                                      ),
                                    ),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty &&
                                            value.length < 10) {
                                          return 'Please Enter address';
                                        }
                                        return null;
                                      },
                                      controller: add_2,
                                      maxLength: 100,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Address Line 2',
                                        hintStyle:
                                        TextStyle(color: Colors.grey[300]),
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
                                        bottom:
                                        BorderSide(color: Colors.grey[300]),
                                      ),
                                    ),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty && value.length < 3) {
                                          return 'Please Enter city';
                                        }
                                        return null;
                                      },
                                      controller: city,
                                      maxLength: 20,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'City/Locality',
                                        hintStyle:
                                        TextStyle(color: Colors.grey[300]),
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
                                          child: DropdownButton<String>(
                                            items: _states.map(
                                                    (String dropDownStringItem) {
                                                  return DropdownMenuItem<String>(
                                                    value: dropDownStringItem,
                                                    child: Text(dropDownStringItem),
                                                  );
                                                }).toList(),
                                            value: _currentSelectedState,
                                            onChanged:
                                                (String newValueSelected) {
                                              setState(() {
                                                _currentSelectedState =
                                                    newValueSelected;
                                              });
                                            },
                                            hint: Text(
                                              hintState,
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
                                              if (value.isEmpty &&
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
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          FadeAnimation(
                            1.3,
                            Text(
                              'Complainant U.I.D',
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: FadeAnimation(
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
                                          child: DropdownButton<String>(
                                            items: _idType.map(
                                                    (String dropDownStringItem) {
                                                  return DropdownMenuItem<String>(
                                                    value: dropDownStringItem,
                                                    child: Text(dropDownStringItem),
                                                  );
                                                }).toList(),
                                            value: _currentSelectedID,
                                            onChanged:
                                                (String newValueSelected) {
                                              setState(() {
                                                _currentSelectedID =
                                                    newValueSelected;
                                              });
                                            },
                                            hint: Text(
                                              hintID,
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
                                width: 5,
                              ),
                              Expanded(
                                child: FadeAnimation(
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
                                              if (value.isEmpty && value.length < 8) {
                                                return 'Please Enter valid data';
                                              }
                                              return null;
                                            },
                                            controller: idNumber,
                                            maxLength:
                                            _currentSelectedID == 'Passport'
                                                ? 8
                                                : 12,
                                            keyboardType: _currentSelectedID ==
                                                'Aadhar Card'
                                                ? TextInputType.number
                                                : TextInputType.text,
                                            decoration: InputDecoration(
                                              hintText: 'U.I.D. Number',
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
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
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
                                        bottom:
                                        BorderSide(color: Colors.grey[300]),
                                      ),
                                    ),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please Enter details';
                                        }
                                        return null;
                                      },
                                      controller: details,
                                      maxLength: 300,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText:
                                        'Give Details About the Incident',
                                        hintStyle:
                                        TextStyle(color: Colors.grey[300]),
                                        border: InputBorder.none,
                                        counterText: '',
                                      ),
                                      //TextInputType.multiline,
                                      maxLines: 5,
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
                              'Suspect of Case\n(Any or else NA)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
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
                                        bottom:
                                        BorderSide(color: Colors.grey[300]),
                                      ),
                                    ),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please Enter description or type NA';
                                        }
                                        return null;
                                      },
                                      controller: suspectdesc,
                                      maxLength: 300,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText:
                                        'Give Description of the Suspect',
                                        hintStyle:
                                        TextStyle(color: Colors.grey[300]),
                                        border: InputBorder.none,
                                        counterText: '',
                                      ),
                                      //TextInputType.multiline,
                                      maxLines: 5,
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
                                        bottom:
                                        BorderSide(color: Colors.grey[300]),
                                      ),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ListTile(
                                                title:
                                                _buildCountryPickerDropdown(
                                                    hasPriorityList: true),
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
                          SizedBox(height: 20),
                          OutlineButton(
                            onPressed: () => openFileExplorer(),
                            child: Text('Open file explorer'),
                          ),
                          urls.isEmpty
                              ? Text('No files submitted(If added then wait)')
                              : _paths.isNotEmpty && urls.isEmpty
                              ? CircularProgressIndicator()
                              : Text('${urls.length} Files Uploaded'),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
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
          width: dropdownButtonWidth,
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
                ? (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode)
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
              print(country);
            },
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty && value.length < 10) {
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
            Expanded(child: Text('+${country.phoneCode}(${country.isoCode})')),
          ],
        ),
      );

  Widget _buildDropdownItemWithLongText(
      Country country, double dropdownItemWidth) =>
      SizedBox(
        width: dropdownItemWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
          padding: const EdgeInsets.all(8),
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
