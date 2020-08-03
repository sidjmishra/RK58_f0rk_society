import 'dart:io';

import 'package:aharyaadmin/home.dart';
import 'package:aharyaadmin/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

FirebaseUser loggedInUser;

class UploadBlog extends StatefulWidget {
  @override
  _UploadBlogState createState() => _UploadBlogState();
}

class _UploadBlogState extends State<UploadBlog> {

  File dataImage;
  final _formKey = GlobalKey<FormState>();
  TextEditingController blogItem = new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  final _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      dataImage = imageFile;
    });
  }

  bool validateAndSave() {
    if(_formKey.currentState.validate()) {
      // Might save the current state
      return true;
    } else {
      return false;
    }
  }

  void uploadAndSave() async {
    if(validateAndSave()) {
      DateTime date = DateTime.now();
      final StorageReference storageReference = FirebaseStorage.instance.ref().child('Blog Data');
      final StorageUploadTask storageUploadTask = storageReference.child(date.toString() + '.jpg').putFile(dataImage);
      String url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      print(url);

      saveToStorage(url);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) {
                return HomePage();
              }
          )
      );
    }
  }

  void saveToStorage(url) async {
    DateTime dateTime = DateTime.now();
    var formatDate = DateFormat('MMM dd, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dateTime);
    String time = formatTime.format(dateTime);
    CollectionReference collectionReference = Firestore.instance.collection('Blog Data');
    collectionReference.document(loggedInUser.uid).collection('all_data').document().setData({
      'imageUrl': url,
      'Description': blogItem.text,
      'Date Posted': date,
      'Time Posted': time,
      'Email': loggedInUser.email,
      'Report': 'Appropriate',
      'Role': 'Official',
    });

    CollectionReference retrievalReference = Firestore.instance.collection('Blog Retrieve');
    retrievalReference.document().setData({
      'imageUrl': url,
      'Description': blogItem.text,
      'Date Posted': date,
      'Time Posted': time,
      'Email': loggedInUser.email,
      'Report': 'Appropriate',
      'Role': 'Official',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Blog',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: Center(
        child: dataImage == null ? Text('Add an Image') : addImage(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add new blog!',
        child: Icon(
          Icons.add_a_photo,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget addImage() {
    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Image.file(
                    dataImage,
                    height: MediaQuery.of(context).size.height * (0.4),
                    width: MediaQuery.of(context).size.width * (0.8),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Colors
                              .grey[300]),
                    ),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter some description';
                      }
                      return null;
                    },
                    controller: blogItem,
                    maxLength: 300,
                    keyboardType:
                    TextInputType.text,
                    decoration:
                    InputDecoration(
                      hintText: 'Add Description',
                      hintStyle: TextStyle(
                          color: Colors
                              .grey[300]),
                      border:
                      InputBorder.none,
                      counterText: '',
                    ),
                    //TextInputType.multiline,
                    maxLines: 7,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  height: 40,
                  margin: EdgeInsets.symmetric(
                      horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(50),
                    color: Colors.orange[400],
                  ),
                  child: Center(
                    child: FlatButton(
                      onPressed: uploadAndSave,
                      child: Text(
                        'Post',
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
    );
  }
}
