import 'package:block/Animation/FadeAnimation.dart';
import 'package:block/views/helpline.dart';
import 'package:block/views/home.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen(
      {this.category,
      this.address1,
      this.address2,
      this.date,
      this.state,
      this.pincode});
  final String category, address1, address2, date, state, pincode;
  @override
  _NotificationScreenState createState() => _NotificationScreenState(
      category, address1, address2, date, state, pincode);
}

class _NotificationScreenState extends State<NotificationScreen> {
  final String category, address1, address2, date, state, pincode;
  _NotificationScreenState(this.category, this.address1, this.address2,
      this.date, this.state, this.pincode);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report Details',
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
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Center(
                child: Text('Menu'),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
              },
              title: Text('Home'),
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
              Colors.orange[800],
              Colors.orange[400],
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  FadeAnimation(
                    1,
                    Text(
                      'Report Details',
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
                      'Details of the latest report near you!',
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Card(
                          child: Container(
                            height: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Address:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                                Text(
                                  '$address1,\n$address2,\n$state,\n$pincode',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            height: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Category:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                                Text(
                                  '$category',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            height: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Date:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                                Text(
                                  '$date',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
