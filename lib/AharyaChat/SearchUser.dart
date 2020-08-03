import 'package:aharyaadmin/AharyaChat/ConversationScreen.dart';
import 'package:aharyaadmin/model/contants.dart';
import 'package:aharyaadmin/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DataMethods dataMethods = new DataMethods();
  TextEditingController searchText = new TextEditingController();

  QuerySnapshot searchSnapshot;

  initiateSearch() {
    dataMethods.getUserByName(searchText.text).then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  createChatroomAndStartConversation(String username) {
    if(username != Constants.myName) {
      String chatRoomId = getChatRoomId(username, Constants.myName);

      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        'users': users,
        'chatRoomId': chatRoomId
      };
      dataMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(userName: username, chatRoomId: chatRoomId)
      ));
    } else {
      print('Naah');
    }
  }

  Widget searchTile({String username, String email}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(username, style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0
              )),
              Text(email, style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18.0
              )),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(username);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(child: Text('Message', style: TextStyle(color: Colors.white),)),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchList() {
    return searchSnapshot != null ? ListView.builder(
      shrinkWrap: true,
        itemCount: searchSnapshot.documents.length,
        itemBuilder: (context, index) {
          return searchTile(
            username: searchSnapshot.documents[index].data["username"],
            email: searchSnapshot.documents[index].data["email"],
          );
        }
    ) : Container();
  }

  @override
  void initState() {
    super.initState();
    initiateSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aharya Chat'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey[100],
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                        controller: searchText,
                        decoration: InputDecoration(
                          hintText: 'Search Username',
                          border: InputBorder.none,
                        ),
                      ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0) ,
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange[500],
                            Colors.orange[300],
                            Colors.orange[100],
                          ]
                        )
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

