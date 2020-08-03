import 'package:aharyaadmin/AharyaChat/ConversationScreen.dart';
import 'package:aharyaadmin/AharyaChat/SearchUser.dart';
import 'package:aharyaadmin/model/contants.dart';
import 'package:aharyaadmin/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  DataMethods dataMethods = new DataMethods();

  Stream chatRoomsStream;

  Widget chatList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return ChatRoomTile(
                userName: snapshot.data.documents[index].data['chatRoomId']
                .toString().replaceAll('_', '').replaceAll(Constants.myName, ''),
                chatRoomId: snapshot.data.documents[index].data['chatRoomId'],
              );
            }
        ) : Container(
          child: Center(child: Text('Search for User')),
        );
      },
    );
  }

  @override
  void initState() {
    dataMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aharya Chat',
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: chatList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()
            )
          );
        },
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {

  final String userName;
  final String chatRoomId;
  ChatRoomTile({this.userName, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(userName: userName, chatRoomId: chatRoomId)
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black12)
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.orange[300],
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Text('${userName.substring(0, 1).toUpperCase()}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            SizedBox(width: 10.0),
            Text(userName,
              style: TextStyle(
                fontSize: 20.0
              ),
            ),
          ],
        ),
      ),
    );
  }
}

