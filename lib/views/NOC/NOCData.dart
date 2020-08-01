import 'package:block/modal/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NocDatabase {
  final String uid;
  NocDatabase({this.uid});
  final CollectionReference userCollection =
      Firestore.instance.collection('NOC');

  Future userSubmitted(
      String id,
      String email,
      String name,
      String phone,
      String address1,
      String address2,
      String pincode,
      String purpose,
      String description,
      urls) async {
    await userCollection.document(uid).setData({
      'UserName': Constants.myName,
      'Email': Constants.myEmail,
      'Uid': Constants.myUid
    });
    return await userCollection
        .document(uid)
        .collection('all_data')
        .document(id)
        .setData({
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'address1': address1,
      'address2': address2,
      'pincode': pincode,
      'purpose': purpose,
      'description': description,
      'Urls': urls,
      'Date of Filing': DateTime.now().toString(),
      'Status': 'Pending',
    });
  }
}
