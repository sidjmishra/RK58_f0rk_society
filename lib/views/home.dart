import 'package:block/Animation/FadeAnimation.dart';
import 'package:block/modal/constants.dart';
import 'package:block/services/auth.dart';
import 'package:block/services/authenticate.dart';
import 'package:block/services/database.dart';
import 'package:block/services/location.dart';
import 'package:block/views/Appointment/appointment.dart';
import 'package:block/views/Bribe/bribeReport.dart';
import 'package:block/views/Chat/ChatRoom.dart';
import 'package:block/views/DelayAction/delayAction.dart';
import 'package:block/views/FirNcr/Reporting.dart';
import 'package:block/views/JailManagement/jailManage.dart';
import 'package:block/views/NOC/Noc.dart';
import 'package:block/views/Profile/profile.dart';
import 'package:block/views/helpline.dart';
import 'package:block/views/Status/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:block/components/notificationScreen.dart';

FirebaseUser loggedInUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthMethods authMethods = AuthMethods();
  Location location = Location();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  QuerySnapshot snapshotUserName;
  DataMethods dataMethods = DataMethods();

  final _auth = FirebaseAuth.instance;
  String applicant;
  String email;
  String id;
  String sublocal;
  String currentAddress;

  Future getUserInfo() async {
    await dataMethods.getUserByEmail(email).then((value) {
      snapshotUserName = value;
      print(snapshotUserName);
      for (var index = 0; index < snapshotUserName.documents.length; index++) {
        if (snapshotUserName.documents[index].data['email'] == email) {
          Constants.myName =
          snapshotUserName.documents[index].data['displayName'];
          Constants.myEmail = snapshotUserName.documents[index].data['email'];
          Constants.myUid = snapshotUserName.documents[index].data['uid'];
          print(Constants.myName);
          print(Constants.myEmail);
          print(Constants.myUid);
        }
      }
      getUserProfile();
    });
  }

  Future getUserProfile() async {
    await dataMethods.getProfile(Constants.myUid).then((value) {
      snapshotUserName = value;
      for (var index = 0; index < snapshotUserName.documents.length; index++) {
        if (snapshotUserName.documents[index].data['uid'] == Constants.myUid) {
          HotConstants.myFullName =
              snapshotUserName.documents[index].data['First Name'] +
                  ' ' +
                  snapshotUserName.documents[index].data['Last Name'];
//          HotConstants.myPhone = snapshotUserName.documents[index].data['Phone Number'];
          HotConstants.myUID =
              snapshotUserName.documents[index].data['U.I.D type'] +
                  ': ' +
                  snapshotUserName.documents[index].data['U.I.D number'];
          print(HotConstants.myFullName);
          print(HotConstants.myPhone);
          print(HotConstants.myUID);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    locator();
    getUserInfo();
    ThemeData(
      applyElevationOverlayColor: true,
      accentColor: Colors.deepOrange,
    );
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        if (message['data']['Type'] == 'Foreground') {
          await showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) => AlertDialog(
              elevation: 24,
              content: ListTile(
                title: Text(
                  message['notification']['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  message['notification']['body'],
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  color: Colors.amber,
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        locator();
        if (message['data']['Type'] == 'Background') {
          await Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
                return NotificationScreen(
                  pincode: message['data']['pincode'],
                  category: message['data']['category'],
                  address1: message['data']['address1'],
                  address2: message['data']['address2'],
                  date: message['data']['date'],
                  state: message['data']['state'],
                );
              }));
        }
      },
      onResume: (Map<String, dynamic> message) async {
        locator();
        if (message['data']['Type'] == 'Background' &&
            location.pin == message['data']['pincode']) {
          await Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
                return NotificationScreen(
                  pincode: message['data']['pincode'],
                  category: message['data']['category'],
                  address1: message['data']['address1'],
                  address2: message['data']['address2'],
                  date: message['data']['date'],
                  state: message['data']['state'],
                );
              }));
        }
        print('onResume: $message');
      },
    );
  }

  void locator() {
    setState(() {
      location.getCurrentLocation();
      getCurrentUser();
      currentAddress = '${location.address}';
      sublocal = '${location.local}, ${location.subLocal}. ${location.feature}';
    });
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        applicant = (loggedInUser.uid).substring(0, 4);
        email = loggedInUser.email;
        id = loggedInUser.uid;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AHARYA',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatRoom()));
              },
              tooltip: 'Aharya Chat',
              icon: Icon(
                AntDesign.wechat,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
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
                  SizedBox(height: 5.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          locator();
                        },
                        child: Icon(
                          AntDesign.user,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      email != null && sublocal != null
                          ? Text(
                        'Applicant ID: ${Constants.myUid.substring(0, 4)} \nEmail ID: ${Constants.myEmail} \nLocality: ${location.local}, ${location.subLocal}. ${location.feature}',
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return BribeReport();
                  }),
                );
              },
              leading: Icon(Icons.attach_money),
              title: Text('Bribe Report',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Reporting();
                  }),
                );
              },
              leading: Icon(Icons.report),
              title: Text('Reporting',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
              subtitle: Text('FIR or NCR Reporting'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return JailManage();
                  }),
                );
              },
              leading: Icon(Icons.business),
              title: Text('Prison Management',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
              subtitle: Text('Report regarding the prison management'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NOC();
                  }),
                );
              },
              leading: Icon(Icons.receipt),
              title: Text('No Objection Certificate',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
              subtitle: Text('NOC Request'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return DelayAction();
                  }),
                );
              },
              leading: Icon(Icons.assignment_late),
              title: Text('Delay in actions',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
              subtitle: Text('Right To Information'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Appointment();
                  }),
                );
              },
              leading: Icon(Icons.group_add),
              title: Text('Appointment Request',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
            ),
            ListTile(
              onTap: () {
                print(Constants.myUid);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Status(uid: Constants.myUid);
                  }),
                );
              },
              leading: Icon(Icons.show_chart),
              title: Text('Status',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return HelpLine();
                  }),
                );
              },
              leading: Icon(Icons.info_outline),
              title: Text('Helpline Numbers',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Profile();
                  }),
                );
              },
              leading: Icon(Icons.supervised_user_circle),
              title: Text('Profile',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
            ),
            ListTile(
              onTap: () {
                authMethods.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange[900],
              Colors.orange[500],
              Colors.orange[600],
              Colors.orange[800],
              Colors.orange[400],
            ],
          ),
        ),
        child: HotConstants.myPhone == null
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
        ) :  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  FadeAnimation(
                    1,
                    Center(
                      child: Image.asset(
                        'assets/bprd.png',
                        height: 60.0,
                        width: 60.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Bureau of Police Research Development',
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/makeinIndia.png',
                        height: 45.0,
                        width: 45.0,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Make In India',
                        style: TextStyle(
                            color: Colors.yellow[500],
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        AntDesign.heart,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              // ScrollView
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      // Bribe Reporting
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * (0.35),
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
                                    'assets/bprd.png',
                                    width: 50.0,
                                    height: 50.0,
                                  ),
                                  SizedBox(width: 20.0),
                                  Text(
                                    'Bribe Reporting',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'A simple way to report a bribe with assured security of evidence while submitting the data. The fast way to make your complain reach the official for quick actions.',
                                maxLines: 10,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.0,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BribeReport()));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Bribe Reporting',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.0),
                                    ),
                                    SizedBox(width: 20.0),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.orangeAccent,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
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
