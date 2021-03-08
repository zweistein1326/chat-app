import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  String title;
  HomePage(this.title);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('Area where user details will be shown'),
      ),
    );
  }
}
