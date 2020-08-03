import 'dart:math';

import 'package:block/modal/constants.dart';
import 'package:block/views/Bribe/webPage.dart';
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
import 'PaidBribeData.dart';

class HonestOfficial extends StatefulWidget {
  @override
  _HonestOfficialState createState() => _HonestOfficialState();
}

class _HonestOfficialState extends State<HonestOfficial> {

  AuthMethods authMethods = AuthMethods();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController add_1 = TextEditingController();
  TextEditingController add_2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController officialName = TextEditingController();
  TextEditingController userContact = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController dateCtl = TextEditingController();

  final _states = ['Andhra Pradesh', 'Andaman and Nicobar', 'Arunachal Pradesh', 'Assam',	'Bihar', 'Chandigarh', 'Chhattisgarh',
    'Dadra and Nagar Haveli', 'Daman and Diu', 'Delhi', 'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh',	'Jammu and kashmir',	'Ladakh',
    'Lakshadweep', 'Jharkhand',	'Karnataka', 'Kerala',	'Madhya Pradesh',	'Maharashtra', 'Manipur',	'Meghalaya', 'Mizoram',	'Nagaland',
    'Odisha',	'Punjab', 'Rajasthan', 'Sikkim',	'Tamil Nadu',	'Telangana', 'Tripura',	'Uttarakhand', 'Uttar Pradesh', 'West Bengal'];
  final _category = ['Police', 'Traffic', 'Prison Management', 'Driver licensing', 'Document Verification', 'Property Registration',
    'Municipal Corporation', 'Electricity Board', 'Transport Office', 'Tax office', 'Water Department', 'Others'];
  String hintCategory = 'Select Category';
  String hintState = 'Select State';
  var _currentSelectedCategory;
  var _currentSelectedState;
  var pickedCountryName;
  var pickedDate;
  var pickedCountry;
  var officeName;
  var stateName;
  var selection;
  var category;
  var id;
  String subLocal;

  // Files
//  List<String> urls = [];
//  List _paths;
//  String _extension;
//  DateTime dateNow = DateTime.now();

//  Future openFileExplorer() async {
//    try {
//      StorageReference storageReference;
//      StorageUploadTask storageUploadTask;
//
//      _paths = await FilePicker.getMultiFile(
//        type: FileType.custom,
//        allowedExtensions: ['jpg', 'jpeg', 'png', 'svg', 'mp4'],
//      );
//      _paths.forEach((filePath) async {
//        _extension = filePath.toString().split('.').last;
//        storageReference =
//        FirebaseStorage.instance.ref().child('FIR_NCR');
//        storageUploadTask = storageReference
//            .child(dateNow.toString() + '.$_extension')
//            .putFile(filePath);
//        String url =
//        await (await storageUploadTask.onComplete).ref.getDownloadURL();
//        if(url != null) {
//          setState(() {
//            urls.add(url);
//          });
//        }
//      });
//    } on PlatformException catch (e) {
//      print(e.toString());
//    }
//    if (!mounted) {
//      return;
//    }
//  }

  void randomId() async {
    var number = Random.secure();
    QuerySnapshot dataID;

    id = Constants.myUid.substring(0, 4) + number.nextInt(9999).toString();
    dataID = await Firestore.instance.collection('UnusualBehaviour').document(Constants.myUid).collection('all_data').getDocuments();
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
    add_1.clear();
    add_2.clear();
    city.clear();
    officialName.clear();
    pincode.clear();
    details.clear();
    _currentSelectedCategory = null;
    _currentSelectedState = null;
    dateCtl.clear();
    userContact.clear();
//    urls.clear();
  }

  void setBlock() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      PaidBribeDatabase(uid: Constants.myUid)
          .unusualBehaviour(
          id,
          Constants.myEmail,
          _currentSelectedCategory,
          add_1.text,
          add_2.text,
          city.text,
          _currentSelectedState,
          pincode.text,
          userContact.text,
          details.text,
          officialName.text,
          dateCtl.text,
          pickedCountry,
          pickedCountryName,
//          urls
      ).then((value) {
        Clipboard.setData(ClipboardData(text: id));
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => DataModel()
        ));
      });
    }
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
      PaidBribeDatabase(uid: Constants.myUid)
          .unusualBehaviour(
        id,
        Constants.myEmail,
        _currentSelectedCategory,
        add_1.text,
        add_2.text,
        city.text,
        _currentSelectedState,
        pincode.text,
        userContact.text,
        details.text,
        officialName.text,
        dateCtl.text,
        pickedCountry,
        pickedCountryName,
//              urls
      ).then((value) {
        Alert(
            context: context,
            type: AlertType.success,
            title: 'Data Submitted',
            desc:
            'Report with id: $id\nCategory: $_currentSelectedCategory\nOfficial Name: ${officialName.text}\n'
                'UserName: ${Constants.myName}, Email: ${Constants.myEmail}'
                '\n\n(Would recommend to take screenshot of it)',
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
          'Faced an Unusual incident',
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
//          gradient: LinearGradient(
//            begin: Alignment.topCenter,
//            colors: [
//              Colors.orange[900],
//              Colors.orange[800],
//              Colors.orange[400],
//            ],
//          ),
        color: Color(0xff212832),
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
                      'Unusual Behaviour',
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
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
                                    Color(0xff99D5D5),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: FadeAnimation(
                                1,
                                Column(
                                  children: <Widget>[
                                    Container(
                                      child:
                                      DropdownButtonFormField<String>(
                                        items: _category.map(
                                                (String dropDownStringItem) {
                                              return DropdownMenuItem<String>(
                                                value: dropDownStringItem,
                                                child:
                                                Text(dropDownStringItem),
                                              );
                                            }).toList(),
                                        validator: (value) =>
                                        value == null
                                            ? 'Field Required'
                                            : null,
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
                              'Address of Govt. Office',
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
                                    Color(0xff99D5D5),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
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
                                    Color(0xff99D5D5),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
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
                                    Color(0xff99D5D5),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
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
                                          color: Color(0xff99D5D5),
                                          blurRadius: 10,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: FadeAnimation(
                                      1.5,
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            child:
                                            DropdownButtonFormField<
                                                String>(
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
                                              validator: (value) =>
                                              value == null
                                                  ? 'Field Required'
                                                  : null,
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
                                          color: Color(0xff99D5D5),
                                          blurRadius: 10,
                                          offset: Offset(0, 5),
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
                                              keyboardType:
                                              TextInputType.number,
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
                                    Color(0xff99D5D5),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
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
                                          'Give Details About the Incident',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[300]),
                                          border: InputBorder.none,
                                          counterText: '',
                                        ),
                                        //TextInputType.multiline,
                                        maxLines: 6,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(
                                  'Name of Official',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '(* if known)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
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
                                    Color(0xff99D5D5),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
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
                                          if (value.isEmpty) {
                                            return 'Please Enter name';
                                          }
                                          return null;
                                        },
                                        controller: officialName,
                                        maxLength: 20,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText:
                                          'Enter Name of Official',
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
                            Text(
                              'Date of Incident',
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
                                    Color(0xff99D5D5),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
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
                                    Color(0xff99D5D5),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
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
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: id));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Copy complaint ID for evidence submission',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(width: 10.0),
                                Icon(Icons.launch,
                                  color: Colors.greenAccent,
                                ),
                              ],
                            ),
                          ),
                                SizedBox(height: 20),
                                FadeAnimation(
                                  1.3,
                                  Text(
                                    'Evidences (Submit if any)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                OutlineButton(
                                  onPressed: () {
                                    setBlock();
//                                    openFileExplorer();
                                  },
                                  child: Text('Add files'),
                                ),
                                isLoading
                                    ? Text('Files Uploaded')
                                    : Text('No Files Uploaded'),
                          SizedBox(height: 20),
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
                                  color: Color(0xff32E0C3),
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
                                  color: Color(0xff212832),
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
              pickedCountry = country.isoCode;
              pickedCountryName = country.name;
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
