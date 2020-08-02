import 'package:block/modal/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaidBribeDatabase {
  final String uid;

  PaidBribeDatabase({this.uid});
  CollectionReference userCollection;
  List evidenceUrl = [];

  // Done
  Future userPaid(String id, String email, String category, String address1, String address2, String city, String state, String pincode, String userContact, String details, String amount, String date, String countryIso, String countryName) async {
    userCollection = Firestore.instance.collection('PaidBribe');
    await userCollection.document(uid).setData({
      'UserName': Constants.myName,
      'Email': Constants.myEmail,
      'Uid': Constants.myUid,
      'User ID': HotConstants.myUID
    });
    await userCollection.document(uid).collection('all_data').document(id).setData({
      'id': id,
      'email': email,
      'category': category,
      'address1': address1,
      'address2': address2,
      'city': city,
      'pincode': pincode,
      'state': state,
      'contact': userContact,
      'details': details,
      'amount': amount,
      'date': date,
      'Date of Filing': DateTime.now().toString(),
      'CountryCode': countryIso,
      'CountryName': countryName,
//      'Urls': urls,
      'Status': 'Pending'
    });
    await evidenceData(id, 'PaidBribe');
  }

  // Done
  Future unusualBehaviour(String id, String email, String category, String address1, String address2, String city, String state, String pincode, String userContact, String details, String official, String date, String countryIso, String countryName) async {
    userCollection = Firestore.instance.collection('UnusualBehaviour');
    await userCollection.document(uid).setData({
      'UserName': Constants.myName,
      'Email': Constants.myEmail,
      'Uid': Constants.myUid,
      'User ID': HotConstants.myUID
    });
    await userCollection.document(uid).collection('all_data').document(id).setData({
      'id': id,
      'email': email,
      'category': category,
      'address1': address1,
      'address2': address2,
      'city': city,
      'pincode': pincode,
      'state': state,
      'contact': userContact,
      'details': details,
      'Official': official,
      'date': date,
      'Date of Filing': DateTime.now().toString(),
      'CountryCode': countryIso,
      'CountryName': countryName,
//      'Urls': urls,
      'Status': 'Pending'
    });
    await evidenceData(id, 'UnusualBehaviour');
  }

  Future evidenceData(String id, String type) async {
    CollectionReference evidenceCollection;
    evidenceCollection = Firestore.instance.collection('EvidenceLinks');
    await evidenceCollection.document(id).setData({
      'Uid': Constants.myUid,
      'complaintID': id,
      'EvidenceLinkImage': evidenceUrl,
      'EvidenceLinkVideo': evidenceUrl,
    });
  }
}
