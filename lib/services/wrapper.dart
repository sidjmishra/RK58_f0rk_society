import 'package:block/modal/user.dart';
import 'package:block/services/authenticate.dart';
import 'package:block/views/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user == null){
      return Authenticate();
    }
    else {
      return HomePage();
    }
  }
}
