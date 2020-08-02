import 'package:block/views/Status/provide.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseUser loggedInUser;

class Status extends StatelessWidget {
  final String uid;
  Status({this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Report Status',
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
      body: Options(userId: uid),
    );
  }
}

class Options extends StatelessWidget {
  final String userId;
  Options({this.userId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                print(userId);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Paid(uid: userId);
                }));
              },
              child: ButtonDesign(text: 'Bribe Report')),
          GestureDetector(
              onTap: () {
                print(userId);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Unusual(uid: userId);
                }));
              },
              child: ButtonDesign(text: 'Unusual Incident')),
          GestureDetector(
              onTap: () {
                print(userId);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HotStatus(uid: userId);
                }));
              },
              child: ButtonDesign(text: 'Hot Report')),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FIR(uid: userId, typeReport: 'FIR');
              }));
            },
            child: ButtonDesign(text: 'FIR Report'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FIR(uid: userId, typeReport: 'NCR');
              }));
            },
            child: ButtonDesign(text: 'NCR Report'),
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RTI(uid: userId);
                }));
              },
              child: ButtonDesign(text: 'Right to Information Status')),
          GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NOC(uid: userId);
                }));
              },
              child: ButtonDesign(text: 'NOC Status')),
          GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Apoint(uid: userId);
                }));
              },
              child: ButtonDesign(text: 'Appointment Status')),
          GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Jail(uid: userId);
                }));
              },
              child: ButtonDesign(text: 'Prison Management')),
          SizedBox(height: 50.0),
        ],
      ),
    );
  }
}

class ButtonDesign extends StatelessWidget {
  final String text;
  ButtonDesign({this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.grey[100],
            Colors.grey[200],
            Colors.grey[100],
          ]),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.teal[800],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Center(
              child: Text(
            text,
//            style: TextStyle(color: Colors.white),
          )),
        ),
      ),
    );
  }
}
