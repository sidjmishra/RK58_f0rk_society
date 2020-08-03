import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabaseServices {

  final String uid;
  UserDatabaseServices({this.uid});
  final CollectionReference userCollection = Firestore.instance.collection('AppAdmin');

  String cityName;

  Future userSigned(String email, String city) async {
//    cityName = city.substring(0, 1).toUpperCase();
    return await userCollection.document(uid).setData({
      'displayName': city.toUpperCase() + '@Aharya',
      'email': email,
      'uid': uid,
      'city': city,
      'Date': DateTime.now(),
    });
  }
}

class DataMethods {
  getUserByName(String username) async {
    return await Firestore.instance.collection('users')
        .where('displayName', isEqualTo: username)
        .getDocuments();
  }

  getUserByEmail(String userEmail) async {
    return await Firestore.instance.collection('AppAdmin')
        .where('email', isEqualTo: userEmail)
        .getDocuments();
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance.collection('ChatRoom')
        .document(chatRoomId).setData(chatRoomMap).catchError((e) {
          print(e.toString());
    });
  }

  addConversationsMessages(String chatRoomId, messageMap) {
    Firestore.instance.collection('ChatRoom')
        .document(chatRoomId).collection('chats')
        .add(messageMap).catchError((e) {
          print(e.toString());
    });
  }

  getConversationMessage(String chatRoomId) async {
    return await Firestore.instance.collection('ChatRoom')
        .document(chatRoomId).collection('chats')
        .orderBy('timeStamp')
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await Firestore.instance.collection('ChatRoom')
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
