import 'package:aharyaadmin/model/contants.dart';
import 'package:aharyaadmin/services/database.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {

  final String userName;
  final String chatRoomId;
  ConversationScreen({this.userName, this.chatRoomId});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DataMethods dataMethods = new DataMethods();
  TextEditingController message = new TextEditingController();

  Stream chatMessageStream;

  sendMessage() {
    if(message.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': message.text,
        'sendBy': Constants.myName,
        'timeStamp': DateTime.now().millisecondsSinceEpoch
      };
      dataMethods.addConversationsMessages(widget.chatRoomId, messageMap);
      message.text = '';
    }
  }

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                isSendBy: snapshot.data.documents[index].data["sendBy"] == Constants.myName,
              );
            }) : Container();
      },
    );
  }

  @override
  void initState() {
    dataMethods.getConversationMessage(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 75.0,
                color: Colors.grey[100],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: message,
                        decoration: InputDecoration(
                          hintText: 'Type your message here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        height: 45.0,
                        width: 45.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.orange[500],
                                Colors.orange[300],
                                Colors.orange[100],
                              ]
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Icon(Icons.send, color: Colors.white,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {

  final String message;
  final bool isSendBy;
  MessageTile({this.message, this.isSendBy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendBy ? 0 : 12, right: isSendBy ? 12 : 0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendBy ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 11),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSendBy ? [
                  Colors.yellow[800],
                  Colors.yellow[800],
                ] : [
                  Colors.orange[200],
                  Colors.orange[200]
                ]
            ),
          borderRadius: isSendBy ?
            BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0), bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(0.0)) :
          BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0), bottomLeft: Radius.circular(0.0), bottomRight: Radius.circular(20.0)),
        ),
        child: Text(message,
          style: isSendBy ? TextStyle(
              color: Colors.white,
              fontSize: 18
          ) : TextStyle(
              color: Colors.black87,
              fontSize: 18
          ),
        ),
      ),
    );
  }
}

