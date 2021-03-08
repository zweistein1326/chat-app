import 'package:flutter/material.dart';
import 'package:sharing_app/helper/constants.dart';
import 'package:sharing_app/helper/helperFunctions.dart';
import 'package:sharing_app/screens/signIn.dart';
import 'package:sharing_app/services/database.dart';
import 'package:sharing_app/widgets/widget.dart';

class ConversationScreen extends StatefulWidget {
  String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageTEC = new TextEditingController();
  DatabaseMethods database = new DatabaseMethods();
  Stream chatMessageStream;

  Widget ChatMessageList() {
    // chats = database.getChat();
    // ListView.builder(itemBuilder: null)

    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemBuilder: (context, index) => MessageTile(
                    snapshot.data.documents[index].data["message"],
                    snapshot.data.documents[index].data["sendBy"] ==
                        Constants.myName),
                itemCount: snapshot.data.documents.length)
            : Container();
      },
    );
  }

  sendMessage() async {
    String myName = await HelperFunctions.getUserNameSP();

    Map<String, dynamic> messageMap = {
      "message": messageTEC.text,
      "sendBy": myName,
      'timestamp': DateTime.now().microsecondsSinceEpoch,
    };
    database.sendMessage(messageTEC.text, widget.chatRoomId, messageMap);
    messageTEC.clear();
  }

  getMessages() {
    database.fetchMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
  }

  void initState() {
    getMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: Container(
          child: Stack(
            children: [
              // ListView.builder(itemBuilder: null),
              ChatMessageList(),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Color(0x54FFFFFF),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onSubmitted: (_) {
                            sendMessage();
                          },
                          controller: messageTEC,
                          style: TextStyle(
                            color: Colors.white54,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Message...',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0x36FFFFF),
                                  Color(0x0FFFFFFF),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(40)),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [Color(0xff007EF4), Color(0xff2A75BC)]
                    : [Color(0x1AFFFFFF), Color(0x1AFFFFFF)])),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
