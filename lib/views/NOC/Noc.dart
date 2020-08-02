import 'dart:math';

import 'package:block/Animation/FadeAnimation.dart';
import 'package:block/components/date_picker.dart';
import 'package:block/components/dropdown.dart';
import 'package:block/components/dropdowncategory.dart';
import 'package:block/modal/constants.dart';
import 'package:block/services/auth.dart';
import 'package:block/views/NOC/NOCData.dart';
import 'package:block/views/Profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NOC extends StatefulWidget {
  @override
  _NOCState createState() => _NOCState();
}

class _NOCState extends State<NOC> {
  AuthMethods authMethods = AuthMethods();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController purpose = TextEditingController();
  TextEditingController description = TextEditingController();

  var id;
  String subLocal;

  // Files
  List<String> urls = [];
  List _paths;
  String _extension;
  DateTime date = DateTime.now();

  void resetForm() {
    name.clear();
    phone.clear();
    address1.clear();
    address2.clear();
    city.clear();
    pincode.clear();
    purpose.clear();
    description.clear();
    urls.clear();
  }

  void randomId() async {
    var number = Random.secure();
    QuerySnapshot dataID;

    id = Constants.myUid.substring(0, 4) + number.nextInt(9999).toString();
    dataID = await Firestore.instance.collection('NOC').document(Constants.myUid).collection('all_data').getDocuments();
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

  Future openFileExplorer() async {
    try {
      _paths = await FilePicker.getMultiFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'svg', 'mp4', 'pdf'],
      );
      _paths.forEach((filePath) async {
        _extension = filePath.toString().split('.').last;
        StorageReference storageReference =
        FirebaseStorage.instance.ref().child('FIR_NCR');
        StorageUploadTask storageUploadTask = storageReference
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
      NocDatabase(uid: Constants.myUid)
          .userSubmitted(
          id,
          Constants.myEmail,
          name.text,
          phone.text,
          address1.text,
          address2.text,
          pincode.text,
          purpose.text,
          description.text,
          urls
      ).then((value) {
        Alert(
            context: context,
            type: AlertType.success,
            title: 'Data Submitted',
            desc:
            'Report with id: $id\nCategory: ${purpose.text}\n'
                'Name: ${name.text}, Email: ${Constants.myEmail}\nFiles Submitted: ${urls.length}\n\n'
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
        title: Text(
          'No Objection Certificate',
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
                Icons.home,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      // Add validator
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
                      'NOC',
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
                      'Fill details about the NOC!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(35),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(
                            1.3,
                            Text(
                              'Select Department',
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
                          DropdownCategory(),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Text(
                              'User Details',
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
                                          if (value.isEmpty) {
                                            return 'Please Enter full name';
                                          }
                                          return null;
                                        },
                                        controller: name,
                                        maxLength: 100,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: 'Name',
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
                                              value.length < 10) {
                                            return 'Please Enter valid phone number';
                                          }
                                          return null;
                                        },
                                        controller: phone,
                                        maxLength: 10,
                                        keyboardType:
                                        TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: 'Phone Number',
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
                                          if (value.isEmpty) {
                                            return 'Please Enter address';
                                          }
                                          return null;
                                        },
                                        controller: address1,
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
                                          if (value.isEmpty) {
                                            return 'Please Enter address';
                                          }
                                          return null;
                                        },
                                        controller: address2,
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
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Dropdown(),
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
                              'Details of NOC',
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
                                          if (value.isEmpty) {
                                            return 'Please fill data';
                                          }
                                          return null;
                                        },
                                        controller: purpose,
                                        maxLength: 30,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: 'Purpose of NOC',
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
                                            return 'Please Enter description';
                                          }
                                          return null;
                                        },
                                        controller: description,
                                        maxLength: 300,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: 'NOC Description',
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
                          SizedBox(height: 10),
                          DatePickerFunction(),
                          SizedBox(height: 20),
                          FadeAnimation(
                            1.3,
                            Text(
                              'Any Attachment (Submit if any)',
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
                            onPressed: () => openFileExplorer(),
                            child: Text('Open file explorer'),
                          ),
                          urls.isEmpty
                              ? Text('')
                              : Text('${urls.length} Files Uploaded'),
                          SizedBox(height: 20),
                          FadeAnimation(
                            1.7,
                            Container(
                              height: 40,
                              margin:
                              EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.orange[900],
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
      ),
    );
  }
}
