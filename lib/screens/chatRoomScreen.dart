import 'package:flutter/material.dart';
import 'package:sharing_app/helper/authenticate.dart';
import 'package:sharing_app/helper/constants.dart';
import 'package:sharing_app/helper/helperFunctions.dart';
import 'package:sharing_app/screens/conversationScreen.dart';
import 'package:sharing_app/screens/search.dart';
import 'package:sharing_app/screens/signIn.dart';
import 'package:sharing_app/services/auth.dart';
import 'package:sharing_app/services/database.dart';
import 'package:sharing_app/widgets/widget.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods auth = new AuthMethods();
  DatabaseMethods database = new DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                        snapshot.data.documents[index].data['chatroomId']
                            .toString()
                            .replaceAll('_', '')
                            .replaceAll(Constants.myName, ''),
                        snapshot.data.documents[index].data['chatroomId']);
                  },
                  itemCount: snapshot.data.documents.length,
                )
              : Container();
        },
        stream: chatRoomStream);
  }

  void initState() {
    getUserInfo();
    database.getChatRooms().then((val) {
      setState(() {
        chatRoomStream = val;
      });
    });
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShareU'),
        actions: [
          GestureDetector(
            onTap: () {
              auth.signOut();
              HelperFunctions.saveUserEmailSP('');
              HelperFunctions.saveUserNameSP('');
              HelperFunctions.saveUserLoggedInSP(false);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.exit_to_app,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
      body: chatRoomList(),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatroomId;
  ChatRoomTile(this.username, this.chatroomId);
  @override
  Widget build(BuildContext context) {
    final myName = HelperFunctions.getUserNameSP();
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ConversationScreen(chatroomId)));
      },
      child: Container(
        color: Colors.black26,
        margin: EdgeInsets.only(bottom: 4),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue,
              ),
              alignment: Alignment.center,
              child: Text(
                '${username[0].toUpperCase()}',
                style: mediumTextStyle(),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                '${username}',
                style: mediumTextStyle(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
