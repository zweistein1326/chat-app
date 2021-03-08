import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharing_app/helper/helperFunctions.dart';
import 'package:sharing_app/models/user.dart';
import '../helper/constants.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection('users')
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUserByEmail(String email) async {
    return await Firestore.instance
        .collection('users')
        .where("email", isEqualTo: email)
        .getDocuments();
  }

  uploadUserInfo(usermap) {
    Firestore.instance
        .collection('users')
        .document()
        .setData(usermap)
        .catchError((err) => print(err));
  }

  createChatRoom(String chatroomId, Map chatroomMap) {
    Firestore.instance
        .collection('chatroom')
        .document(chatroomId)
        .setData(chatroomMap);
  }

  sendMessage(String message, String chatRoomId, messageMap) {
    Firestore.instance
        .collection('chatroom')
        .document(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) => print(e));
  }

  fetchMessages(String chatRoomId) async {
    return await Firestore.instance
        .collection('chatroom')
        .document(chatRoomId)
        .collection('chats')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  getChatRooms() async {
    return await Firestore.instance
        .collection('chatroom')
        .where('users', arrayContains: await HelperFunctions.getUserNameSP())
        .snapshots();
  }
}
