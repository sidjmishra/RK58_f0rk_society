import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:aharyaadmin/LiveStream/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

Permission permissionHandle;

class IndexPage extends StatefulWidget {
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
  
  QuerySnapshot queryHistory;
  
  Future getHistory() async {
    queryHistory = await Firestore.instance.collection('LiveStream').orderBy('Time', descending: true).getDocuments();
    return queryHistory.documents;
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
        title: Text('Aharya Stream',
          style: TextStyle(color: Colors.white),
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
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
                          ListTile(
                            title: Text(ClientRole.Audience.toString()),
                            leading: Radio(
                              value: ClientRole.Audience,
                              groupValue: _role,
                              onChanged: (ClientRole value) {
                                setState(() {
                                  _role = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
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
                      )
                    ],
                  ),
                ),

                Text('User Stream History'  ,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 10.0),

                // Status History
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
                                      snapshot.data[index].data['Status'] == 'Live'
                                          ? Text('Status: ' + snapshot.data[index].data['Status'],
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ) : Text('Status: ' + snapshot.data[index].data['Status'],
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('Channel name: '+ snapshot.data[index].data['Channel Name'],
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          )
                                      ),
                                      SizedBox(height: 5.0),
                                      Text('Stream Location: '+ snapshot.data[index].data['Location'],
                                        maxLines: 4,
                                      ),
                                      SizedBox(height: 5.0),
                                      Text('Streamer Name: '+ snapshot.data[index].data['Streamer Name'],
                                        maxLines: 2,
                                      ),
                                      SizedBox(height: 5.0),
                                      Text('Streamer Username: '+ snapshot.data[index].data['Username'],
                                        maxLines: 2,
                                      ),
                                      SizedBox(height: 5.0),
                                      Text('Date & Time: ' + snapshot.data[index].data['DateTime'].toString().substring(0, 16)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }
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
//    var result = await _permissionHandler.requestPermissions([PermissionGroup.contacts]);
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
