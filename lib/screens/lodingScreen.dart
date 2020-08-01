import 'package:block/services/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    gotoNext();
  }

  void gotoNext() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Wrapper()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/bprd.png',
              height: 90.0,
              width: 90.0,
            ),
            SizedBox(height: 10),
            Text(
              'Bureau of Police and Research Development',
              maxLines: 2,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/makeinIndia.png',
                  height: 40.0,
                  width: 40.0,
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
    );
  }
}
