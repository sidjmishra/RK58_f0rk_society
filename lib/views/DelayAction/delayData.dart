import 'package:block/modal/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DelayDatabase {
  final String uid;
  DelayDatabase({@required this.uid});
  CollectionReference userCollection =
  Firestore.instance.collection('Delay in Actions');
  Future userSubmitted(
      String id,
      String email,
      String name,
      String phone,
      String userId,
      String complainID,
      String application,
      ) async {
    await userCollection.document(uid).setData({
      'UserName': Constants.myName,
      'Email': Constants.myEmail,
      'Uid': Constants.myUid
    });
    await userCollection
        .document(uid)
        .collection('all_data')
        .document(id)
        .setData({
      'id': id,
      'User Email': email,
      'Full Name': name,
      'ApplicationType': application,
      'User Identification': userId,
      'User Contact': phone,
      'Requested Complain ID': complainID,
      'Date of Filing': DateTime.now().toString(),
      'Status': 'Pending'
    });
  }
}
