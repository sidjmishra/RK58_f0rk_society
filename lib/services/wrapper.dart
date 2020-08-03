import 'package:aharyaadmin/home.dart';
import 'package:aharyaadmin/model/user.dart';
import 'package:aharyaadmin/services/authenticate.dart';
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
