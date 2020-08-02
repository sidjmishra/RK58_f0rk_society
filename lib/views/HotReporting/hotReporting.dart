import 'dart:io';
import 'dart:math';

import 'package:block/modal/constants.dart';
import 'package:block/services/location.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HotReport extends StatefulWidget {
  final String uid;
  final String hotAddress;
  final String startStamp;
  final String UID;
  final String fullName;
  final String phoneNumber;

  HotReport(
      {this.uid,
      this.hotAddress,
      this.fullName,
      this.phoneNumber,
      this.UID,
      this.startStamp});

  @override
  _HotReportState createState() => _HotReportState();
}

class _HotReportState extends State<HotReport> {
  Location location = Location();

  var id;
  bool done = false;
  File videoFile;
  File fileVideo;
  String subLocal;
  String endStamp = DateTime.now().toString();

  VideoPlayerController videoPlayerController;
  QuerySnapshot hotReportStream;
  QuerySnapshot dataId;

  @override
  void initState() {
    randomId();
    _pick();
    super.initState();
  }

  Future _pick() async {
    // ignore: deprecated_member_use
    fileVideo = await ImagePicker.pickVideo(
      source: ImageSource.camera,
    );
    if (fileVideo != null) {
      setState(() {
        videoFile = fileVideo;
        videoPlayerController = VideoPlayerController.file(videoFile)
          ..initialize().then((value) {
            videoPlayerController.play();
            videoPlayerController.setLooping(true);
          });
      });
      print(videoPlayerController.toString());
      print(videoFile.toString());
    }
  }

  Future _storeReport() async {
    StorageReference storageReference;
    StorageUploadTask storageUploadTask;
    if (videoFile != null) {
      storageReference = FirebaseStorage.instance.ref().child('Hot Report');
      storageUploadTask =
          storageReference.child(endStamp + '.mp4').putFile(videoFile);
      String url =
          await (await storageUploadTask.onComplete).ref.getDownloadURL();
      _sendReport(url);
      Navigator.pop(context);
    }
  }

  void randomId() async {
    var number = Random.secure();
    QuerySnapshot dataID;

    id = Constants.myUid.substring(0, 4) + number.nextInt(9999).toString();
    dataID = await Firestore.instance
        .collection('Hot Report')
        .document(widget.uid)
        .collection('all_data')
        .getDocuments();
    if (dataID.documents.isNotEmpty) {
      for (var index = 0; index < dataID.documents.length; index++) {
        if (dataID.documents[index].data['complaintID'] == id &&
            id.length < 8) {
          setState(() {
            id = Constants.myUid.substring(0, 4) +
                number.nextInt(9999).toString();
          });
        }
      }
    }
    print(id);
  }

  void _sendReport(url) async {
    await Firestore.instance
        .collection('Hot Report')
        .document(widget.uid)
        .setData({
      'Uid': widget.uid,
      'Time Stamp': endStamp,
    });

    await Firestore.instance
        .collection('Hot Report')
        .document(widget.uid)
        .collection('all_data')
        .document()
        .setData({
      'Full Name': widget.fullName,
      'Phone Number': widget.phoneNumber,
      'U.I.D': widget.UID,
      'Url': url,
      'Uid': widget.uid,
      'Current Location': widget.hotAddress,
      'Start Stamp': widget.startStamp,
      'End Stamp': endStamp,
      'complaintID': id,
      'Status': 'Pending'
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (videoPlayerController != null) {
      videoPlayerController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hot Reporting',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * (0.4),
                  child: videoFile == null
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.teal,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'No Data Available',
                            ),
                          ),
                        )
                      : FittedBox(
                          fit: BoxFit.contain,
                          child: mounted
                              ? Chewie(
                                  controller: ChewieController(
                                    videoPlayerController:
                                        videoPlayerController,
                                    aspectRatio: 3 / 2,
                                    autoPlay: true,
                                  ),
                                )
                              : Container(),
                        ),
                ),
                SizedBox(height: 15.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * (0.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Color(0xff212832),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Complaint ID: ' + id,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'User ID: ' + widget.uid,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'Hot Address: ' + widget.hotAddress,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'Full Name: ' + widget.fullName,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'Phone Number: ' + widget.phoneNumber,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          widget.UID,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'Start Stamp: ' + widget.startStamp,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'End Stamp: ' + endStamp,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                videoFile != null && done == true
                    ? CircularProgressIndicator()
                    : Text('No proper data'),
                SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    _storeReport();
                    setState(() {
                      done = true;
                    });
                  },
                  child: Container(
                    height: 40.0,
                    width: MediaQuery.of(context).size.width,
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.teal,
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
