import 'dart:math';

import 'package:block/Animation/FadeAnimation.dart';
import 'package:block/modal/constants.dart';
import 'package:block/screens/otp.dart';
import 'package:block/services/auth.dart';
import 'package:block/services/database.dart';
import 'package:block/views/Profile/profileData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

FirebaseUser loggedInUser;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthMethods authMethods = AuthMethods();
  QuerySnapshot snapshotUserName;
  DataMethods dataMethods = DataMethods();
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  QuerySnapshot querySnapshot;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController add_1 = TextEditingController();
  TextEditingController add_2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController userContact = TextEditingController();
  TextEditingController idNumber = TextEditingController();
  TextEditingController dateCtl = TextEditingController();

  final _states = [
    'Andhra Pradesh',
    'Andaman and Nicobar',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chandigarh',
    'Chhattisgarh',
    'Dadra and Nagar Haveli',
    'Daman and Diu',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and kashmir',
    'Ladakh',
    'Lakshadweep',
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
    'West Bengal'
  ];
  final _idType = ['Aadhar Card'];
  final _gender = ['Male', 'Female', 'Other'];
  String hintState = 'Select State';
  String hintID = 'Select UID type';
  String hintGender = 'Select Gender';
  var _currentSelectedState;
  var _currentSelectedID;
  var _currentSelectedGender;

  DateTime date;
  bool isLoading = false;
  String applicant;
  String email;

  // Files
  List<String> urls = [];
  List _paths;
  String _extension;
  DateTime dateTime = DateTime.now();

  Future openFileExplorer() async {
    StorageReference storageReference;
    StorageUploadTask storageUploadTask;

    try {
      _paths = await FilePicker.getMultiFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      _paths.forEach((filePath) async {
        _extension = filePath.toString().split('.').last;
        storageReference = FirebaseStorage.instance.ref().child('Profile');
        storageUploadTask = storageReference
            .child('${lastName.text}' + dateTime.toString() + '.$_extension')
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

  Future getUserInfo() async {
    await dataMethods.getUserByEmail(email).then((value) {
      snapshotUserName = value;
      print(snapshotUserName);
      for (var index = 0; index < snapshotUserName.documents.length; index++) {
        if (snapshotUserName.documents[index].data['email'] == email) {
          print(email);
          Constants.myName =
              snapshotUserName.documents[index].data['displayName'];
          Constants.myEmail = snapshotUserName.documents[index].data['email'];
          Constants.myUid = snapshotUserName.documents[index].data['uid'];
        }
      }
    });
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        applicant = loggedInUser.uid;
        email = loggedInUser.email;
        print(applicant);
        print(email);
      }
    } catch (e) {
      print(e);
    }
  }

  void resetForm() {
    firstName.clear();
    lastName.clear();
    add_1.clear();
    add_2.clear();
    city.clear();
    userContact.clear();
    pincode.clear();
    _currentSelectedGender = null;
    _currentSelectedState = null;
    _currentSelectedID = null;
    dateCtl.clear();
    idNumber.clear();
    urls.clear();
  }

  Future setData() async {
    if (_formKey.currentState.validate() && urls.length == 2) {
      setState(() {
        isLoading = true;
      });

      await ProfileData(uid: applicant)
          .userSubmitted(
              Constants.myUid,
              firstName.text,
              lastName.text,
              Constants.myEmail,
              _currentSelectedGender,
              dateCtl.text,
              add_1.text,
              add_2.text,
              pincode.text,
              city.text,
              userContact.text,
              _currentSelectedState,
              _currentSelectedID,
              idNumber.text,
              urls)
          .then((value) {
            getPhone(idNumber.text);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Otp()
        ));
      });
    } else {
      return 'error';
    }
  }

  Future getPhone(String aadhar) async {
    querySnapshot = await Firestore.instance.collection('Aadhar Card').getDocuments();
    for (var index = 0; index < querySnapshot.documents.length; index++) {
      if(querySnapshot.documents[index].data['Aadhar'] == aadhar) {
        HotConstants.myPhone = await querySnapshot.documents[index].data['Phone'];
      }
    }
    print(HotConstants.myPhone);
  }

  @override
  void initState() {
    getCurrentUser();
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  FadeAnimation(
                    1.3,
                    Text(
                      'User Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),

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
                    child: Container(
                      child: DropdownButton<String>(
                        items: _gender.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        value: _currentSelectedGender,
                        onChanged: (String newValueSelected) {
                          setState(() {
                            _currentSelectedGender = newValueSelected;
                          });
                        },
                        hint: Text(
                          hintGender,
                          style: TextStyle(color: Colors.grey[300]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Date of Birth
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
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]),
                        ),
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter date of birth';
                          }
                          return null;
                        },
                        controller: dateCtl,
                        textAlign: TextAlign.center,
                        onTap: () async {
                          date = DateTime(2000);
                          FocusScope.of(context).requestFocus(FocusNode());
                          date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          dateCtl.text = date.toIso8601String().substring(0, 10);
                          print(dateCtl);
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Date of Birth',
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ProfileArea(
                    textWidget: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter a first name';
                        }
                        return null;
                      },
                      maxLength: 20,
                      maxLines: null,
                      controller: firstName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'First Name',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ProfileArea(
                    textWidget: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter a last name';
                        }
                        return null;
                      },
                      maxLength: 20,
                      controller: lastName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Last Name',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ProfileArea(
                    textWidget: TextFormField(
                      validator: (value) {
                        if (value.isEmpty && value.length < 10) {
                          return 'Enter a valid address';
                        }
                        return null;
                      },
                      maxLength: 40,
                      maxLines: 2,
                      controller: add_1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Address Line 1',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ProfileArea(
                    textWidget: TextFormField(
                      validator: (value) {
                        if (value.isEmpty && value.length < 10) {
                          return 'Enter a valid address';
                        }
                        return null;
                      },
                      maxLength: 40,
                      maxLines: 2,
                      controller: add_2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Address Line 2',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ProfileArea(
                    textWidget: TextFormField(
                      validator: (value) {
                        if (value.isEmpty && value.length < 6) {
                          return 'Enter a valid pincode';
                        }
                        return null;
                      },
                      maxLength: 6,
                      maxLines: null,
                      controller: pincode,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Pincode',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ProfileArea(
                    textWidget: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter a valid city name';
                        }
                        return null;
                      },
                      maxLength: 20,
                      maxLines: null,
                      controller: city,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'City',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ProfileArea(
                    textWidget: TextFormField(
                      validator: (value) {
                        if (value.isEmpty && value.length < 10) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                      maxLength: 10,
                      maxLines: null,
                      controller: userContact,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  // state
                  SizedBox(height: 10.0),
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
                    child: Container(
                      child: DropdownButton<String>(
                        items: _states.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        value: _currentSelectedState,
                        onChanged: (String newValueSelected) {
                          setState(() {
                            _currentSelectedState = newValueSelected;
                          });
                        },
                        hint: Text(
                          hintState,
                          style: TextStyle(color: Colors.grey[300]),
                        ),
                      ),
                    ),
                  ),

                  // uid
                  SizedBox(height: 10.0),
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
                    child: Container(
                      child: DropdownButton<String>(
                        items: _idType.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        value: _currentSelectedID,
                        onChanged: (String newValueSelected) {
                          setState(() {
                            _currentSelectedID = newValueSelected;
                          });
                        },
                        hint: Text(
                          hintID,
                          style: TextStyle(color: Colors.grey[300]),
                        ),
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
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]),
                        ),
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty && value.length < 12) {
                            return 'Enter a valid ID';
                          }
                          return null;
                        },
                        maxLength: 12,
                        maxLines: null,
                        controller: idNumber,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'UID Number',
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeAnimation(
                    1.3,
                    Text(
                      'Submit Aadhar Card & passport size picture',
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
                      ? Text('No files submitted(If added then wait)')
                      : Text('${urls.length} Files Uploaded'),
                  SizedBox(height: 20),

                  // Button
                  GestureDetector(
                    onTap: () async {
                      var val = await setData();
                      print(val);
                      if (val == 'error') {
                        print('error recieved');
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(
                              content: Text('Please add files'),
                        ));
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 123,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.orange[400],
                      ),
                      child: Center(
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
        );
    }),
    );
  }
}

class ProfileArea extends StatelessWidget {
  final Widget textWidget;

  ProfileArea({this.textWidget});

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]),
            ),
          ),
          child: textWidget,
        ),
      ),
    );
  }
}
