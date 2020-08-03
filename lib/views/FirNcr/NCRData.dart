import 'package:block/modal/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class NCRDatabase {
  String uid;
  String type;
  NCRDatabase({@required this.uid, this.type});
  CollectionReference userCollection = Firestore.instance.collection('FIR_NCR');

  Future userSubmitted(
      String id,
      String email,
      String userName,
      String category,
      String fatherHusbandName,
      String address1,
      String address2,
      String city,
      String pincode,
      String state,
      String idType,
      String idNumber,
      String userContact,
      String details,
      String suspectDetails,
      String dateOfIncident,
      urls) async {
    await userCollection.document(uid).setData({
      'UserName': Constants.myName,
      'Email': Constants.myEmail,
      'Uid': Constants.myUid
    });
    type == 'FIR' ? await userCollection
        .document(uid)
        .collection('FIR')
        .document(id)
        .setData({
      'id': id,
      'email': email,
      'Name of User': userName,
      'Father/Husband Name': fatherHusbandName,
      'category': category,
      'address1': address1,
      'address2': address2,
      'city': city,
      'pincode': pincode,
      'state': state,
      'U.I.D. Type': idType,
      'U.I.D. Number': idNumber,
      'contact': userContact,
      'Details of Suspect': suspectDetails,
      'Details of Incident': details,
      'Date of Incident': dateOfIncident,
      'Date of Filing': DateTime.now().toString(),
      'Urls': urls,
      'Status': 'Pending'
    }) : await userCollection
        .document(uid)
        .collection('NCR')
        .document(id)
        .setData({
      'id': id,
      'email': email,
      'Name of User': userName,
      'Father/Husband Name': fatherHusbandName,
      'category': category,
      'address1': address1,
      'address2': address2,
      'city': city,
      'pincode': pincode,
      'state': state,
      'U.I.D. Type': idType,
      'U.I.D. Number': idNumber,
      'contact': userContact,
      'Details of Suspect': suspectDetails,
      'Details of Incident': details,
      'Date of Incident': dateOfIncident,
      'Date of Filing': DateTime.now(),
      'Urls': urls,
      'Status': 'Pending'
    });
  }
}
