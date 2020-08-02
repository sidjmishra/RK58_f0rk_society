import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class DataModel extends StatefulWidget {
  @override
  _DataModelState createState() => _DataModelState();
}

class _DataModelState extends State<DataModel> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebviewScaffold(
        url: 'https://polar-oasis-35822.herokuapp.com/',
      ),
    );
  }
}