import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharing_app/helper/authenticate.dart';
import 'package:sharing_app/helper/helperFunctions.dart';
import 'package:sharing_app/screens/chatRoomScreen.dart';
import 'package:sharing_app/services/auth.dart';
import 'package:sharing_app/services/database.dart';
import 'package:sharing_app/widgets/widget.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthMethods auth = new AuthMethods();
  DatabaseMethods database = new DatabaseMethods();

  signIn() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      HelperFunctions.saveUserEmailSP(emailTEC.text);

      auth.signInWithEmail(emailTEC.text, passwordTEC.text).then((val) {
        database.getUserByEmail(emailTEC.text).then((user) {
          HelperFunctions.saveUserNameSP(user.documents[0].data['name']);
        });
        setState(() {
          isLoading = false;
        });
        HelperFunctions.saveUserLoggedInSP(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0.9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)
                                ? null
                                : "Please provide a valid email";
                          },
                          controller: emailTEC,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration('email'),
                        ),
                        TextFormField(
                          validator: (val) {
                            return val.length > 4
                                ? null
                                : "Please use a stronger password";
                          },
                          controller: passwordTEC,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration('password'),
                        ),
                        SizedBox(height: 8),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'Forgot Password?',
                              style: simpleTextStyle(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: signIn,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  colors: [
                                    const Color(0xff007EF4),
                                    const Color(0xff2A75BC),
                                  ]),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Sign In',
                              style: simpleTextStyle(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Sign In with Google',
                            style:
                                TextStyle(color: Colors.black87, fontSize: 17),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: mediumTextStyle(),
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  'Register now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}

TextStyle simpleTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}

TextStyle mediumTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}
