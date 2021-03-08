import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharing_app/helper/constants.dart';
import 'package:sharing_app/helper/helperFunctions.dart';
import 'package:sharing_app/screens/chatRoomScreen.dart';
import 'package:sharing_app/screens/conversationScreen.dart';
import 'package:sharing_app/screens/signIn.dart';
import 'package:sharing_app/services/database.dart';
import 'package:sharing_app/widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTEC = new TextEditingController();
  DatabaseMethods database = new DatabaseMethods();
  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => searchTile(
                  username: searchSnapshot.documents[index].data['name'],
                  email: searchSnapshot.documents[index].data['email'],
                ),
            itemCount: searchSnapshot.documents.length)
        : Container();
  }

  beginChatRoom(String username) async {
    String myName = await HelperFunctions.getUserNameSP();
    if (username != myName) {
      String chatRoomId = getChatRoomId(username, myName);
      List<String> users = [username, myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        'chatroomId': chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print('this you dumbass');
    }
  }

  initiateSearch() {
    database.getUserByUsername(searchTEC.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchTile({String username, String email}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(username, style: simpleTextStyle()),
              Text(email, style: simpleTextStyle()),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              //Add users to friends/family list
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              beginChatRoom(username);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: Colors.blue),
              child: Icon(
                Icons.chat_bubble_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTEC,
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search username...',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
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
  if (a.compareTo(b) > 0) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
