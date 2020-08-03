import 'package:aharyaadmin/model/user.dart';
import 'package:aharyaadmin/services/auth.dart';
import 'package:aharyaadmin/services/location.dart';
import 'package:aharyaadmin/services/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper(),
      ),
    );
  }
}

