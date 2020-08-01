import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabaseServices {
  final String uid;
  final String fcmToken;
  UserDatabaseServices({this.fcmToken, this.uid});
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future userSigned(String username, String email) async {
    return await userCollection.document(uid).setData({
      'displayName': username,
      'email': email,
      'uid': uid,
      'fcmToken': fcmToken,
    });
  }
}

class DataMethods {
  Future getUserData(String coll, String uid) async {
    return await Firestore.instance
        .collection(coll)
        .document(uid)
        .collection('all_data')
        .getDocuments();
  }

  Future getProfile(String uid) async {
    return await Firestore.instance.collection('User Details')
        .where('uid', isEqualTo: uid)
        .getDocuments();
  }

  Future getAdminByName(String username) async {
    return await Firestore.instance.collection('AppAdmin')
        .where('displayName', isEqualTo: username)
        .getDocuments();
  }

  Future getUserByName(String username) async {
    return await Firestore.instance.collection('users')
        .where('displayName', isEqualTo: username)
        .getDocuments();
  }

  Future getUserByEmail(String email) async {
    return await Firestore.instance.collection('users')
        .where('email', isEqualTo: email)
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
        .document(chatRoomId).updateData({
      'Timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    Firestore.instance.collection('ChatRoom')
        .document(chatRoomId).collection('chats')
        .add(messageMap).catchError((e) {
      print(e.toString());
    });
  }

  Future getConversationMessage(String chatRoomId) async {
    return await Firestore.instance.collection('ChatRoom')
        .document(chatRoomId).collection('chats')
        .orderBy('timeStamp')
        .snapshots();
  }

  Future getChatRooms(String userName) async {
    return await Firestore.instance.collection('ChatRoom')
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
