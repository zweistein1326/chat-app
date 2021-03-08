import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Future signInWithEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (err) {
      print(err);
    }
  }

  Future singUpWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (err) {
      print(err.toString());
    }
  }

  Future resetPass(String email, String password) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (err) {
      print(err.toString());
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(err){
      print(err.toString());
    }
  }

  // Future signInWithGoogle(String email) async{
  //   try{
  //     return await 
  //   }
  //   catch(err){print(err.toString());}
  // }
}
