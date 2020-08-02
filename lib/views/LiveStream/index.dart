import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:block/modal/constants.dart';
import 'package:block/views/LiveStream/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

Permission permissionHandle;

class IndexPage extends StatefulWidget {

  final String streamAddress;
  IndexPage({this.streamAddress});

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {

  final PermissionHandlerPlatform _permissionHandler = PermissionHandlerPlatform.instance;
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;

  ClientRole _role = ClientRole.Broadcaster;
  QuerySnapshot snapshotUserName;
  QuerySnapshot querySnapshot;

  Future getHistory() async {
    querySnapshot = await Firestore.instance.collection('LiveStream')
        .document(Constants.myUid)
        .collection('StreamData')
        .orderBy('DateTime', descending: true)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future addChannel() async {
    await Firestore.instance.collection('LiveStream')
        .document(Constants.myUid)
        .collection('StreamData')
        .document()
        .setData({
      'Channel Name': _channelController.text,
      'Streamer Name': HotConstants.myFullName,
      'Username': Constants.myName,
      'Stream Location': widget.streamAddress,
      'DateTime': DateTime.now().toString().substring(0, 16)
    });

    await Firestore.instance.collection('LiveStream')
        .document(Constants.myUid).setData({
      'Channel Name': _channelController.text,
      'Streamer Name': HotConstants.myFullName,
      'Username': Constants.myName,
      'Location': widget.streamAddress,
      'DateTime': DateTime.now().toString().substring(0, 16),
      'Time': DateTime.now().millisecondsSinceEpoch,
      'Status': 'Live'
    });
  }
  @override
  void initState() {
    print(widget.streamAddress);
    super.initState();
  }

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aharya Live Stream',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: TextField(
                                controller: _channelController,
                                decoration: InputDecoration(
                                  errorText:
                                  _validateError ? 'Channel name is mandatory' : null,
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                  ),
                                  hintText: 'Channel name',
                                ),
                              ))
                        ],
                      ),
                      Column(
                        children: [
                          ListTile(
                            title: Text(ClientRole.Broadcaster.toString()),
                            leading: Radio(
                              value: ClientRole.Broadcaster,
                              groupValue: _role,
                              onChanged: (ClientRole value) {
                                setState(() {
                                  _role = value;
                                });
                              },
                            ),
                          ),
//                    ListTile(
//                      title: Text(ClientRole.Audience.toString()),
//                      leading: Radio(
//                        value: ClientRole.Audience,
//                        groupValue: _role,
//                        onChanged: (ClientRole value) {
//                          setState(() {
//                            _role = value;
//                          });
//                        },
//                      ),
//                    )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                onPressed: onJoin,
                                child: Text('Join'),
                                color: Colors.orangeAccent,
                                textColor: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Text('Stream History',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),

                // History
                Expanded(
                  child: FutureBuilder(
                    future: getHistory(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text('No Data Available'),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                      Color.fromRGBO(225, 95, 27, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Date & Time: ' + snapshot.data[index].data['DateTime'].toString().substring(0, 16)),
                                      SizedBox(height: 5.0),
                                      Text('Channel name:'+ snapshot.data[index].data['Channel Name']),
                                      SizedBox(height: 5.0),
                                      Text('Streamer Name:'+ snapshot.data[index].data['Streamer Name'],
                                        maxLines: 2,
                                      ),
                                      SizedBox(height: 5.0),
                                      Text('Stream Location:'+ snapshot.data[index].data['Stream Location'],
                                        maxLines: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }},
                  ),
                ),
                SizedBox(height: 100.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _requestPermission(Permission.camera);
      await _requestPermission(Permission.microphone);
      await addChannel();
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: _channelController.text,
            role: _role,
          ),
        ),
      );
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }
}
