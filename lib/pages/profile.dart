import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }

}

class _ProfilePageState extends State<ProfilePage> {

  //TODO: Delete button
  //TODO: Sign out button
  //TODO:

  void _signOut() {

  }

  void _deleteAccount() {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          FlatButton(
            child: Text("Verwijder"),
            onPressed: _deleteAccount,
          ),
          FlatButton(
            child: Text("Uitloggen"),
            onPressed: _signOut,
          )
        ],
      ),
    );
  }

}