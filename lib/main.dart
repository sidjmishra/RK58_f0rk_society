import 'package:block/services/auth.dart';
import 'package:block/services/location.dart';
import 'package:block/services/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'modal/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Location location = Location();

  @override
  void initState() {
    super.initState();
    location.getCurrentLocation();
    print(location.getCurrentLocation());
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthMethods().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aharya',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper(),
      ),
    );
  }
}
