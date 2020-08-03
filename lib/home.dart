import 'package:aharyaadmin/AharyaBlog/HomeBlog.dart';
import 'package:aharyaadmin/AharyaBlog/UploadBlog.dart';
import 'package:aharyaadmin/AharyaChat/ChatRoom.dart';
import 'package:aharyaadmin/BribeCases/bribe.dart';
import 'package:aharyaadmin/LiveStream/index.dart';
import 'package:aharyaadmin/model/contants.dart';
import 'package:aharyaadmin/services/auth.dart';
import 'package:aharyaadmin/services/authenticate.dart';
import 'package:aharyaadmin/services/database.dart';
import 'package:aharyaadmin/services/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseUser loggedInUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  AuthMethods authMethods = AuthMethods();
  final _auth = FirebaseAuth.instance;
  Location location = Location();
  QuerySnapshot snapshotUserName;
  DataMethods dataMethods = DataMethods();

  String applicant;

  String email;

  String sublocal;

  void locator() {
    setState(() {
      location.getCurrentLocation();
      getCurrentUser();
      sublocal = '${location.local}, ${location.subLocal}. ${location.feature}';
      print(sublocal);
    });
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        applicant = (loggedInUser.uid).substring(0, 4);
        email = loggedInUser.email;
        print(email);
      }
    } catch (e) {
      print(e);
    }
  }

  void getUserInfo() {
      dataMethods.getUserByEmail(email).then((value) {
        snapshotUserName = value;
        print(snapshotUserName);
        for(var index = 0; index < snapshotUserName.documents.length; index++) {
          print(index);
          if(snapshotUserName.documents[index].data['email'] == email) {
            Constants.myName = snapshotUserName.documents[index].data['displayName'];
            Constants.myEmail = snapshotUserName.documents[index].data['email'];
            Constants.myUid = snapshotUserName.documents[index].data['uid'];
            print(Constants.myName);
            print(Constants.myEmail);
            print(Constants.myUid);
          }
        }
      });
  }

  @override
  void initState() {
    super.initState();
    locator();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return UploadBlog();
            }
          ));
        },
        tooltip: 'Add Blog',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Aharya Blog',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(
                  context,
                MaterialPageRoute(
                  builder: (context) => Authenticate()
                )
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          locator();
                        },
                        child: Icon(
                          Icons.supervised_user_circle,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      email != null && sublocal != null
                          ? Text(
                              'Email ID: $email \nLocality: $sublocal',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            )
                          : Text(
                              'Tap icon to get ID',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Aharya Chat'),
              leading: Icon(Icons.chat),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatRoom()
                  )
                );
              },
            ),
            ListTile(
              title: Text('Live Streams'),
              leading: Icon(Icons.live_tv),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IndexPage()
                    )
                );
              },
            ),
            ListTile(
              title: Text('Bribe Cases'),
              leading: Icon(Icons.bug_report),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BribeCases()
                    )
                );
              },
            ),
          ],
        ),
      ),
      body: ListPost(),
    );
  }
}
