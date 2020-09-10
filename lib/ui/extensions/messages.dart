import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

ScaffoldFeatureController showSnackBar({
  GlobalKey<ScaffoldState> scaffoldKey,
  BuildContext buildContext,
  @required String message,
  @required bool isError,
}) {

  if (scaffoldKey != null) {
    return scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green),
    );
  }

  if (buildContext != null) {
    Scaffold.of(buildContext).showSnackBar(
        SnackBar(
            content: Text(message),
            backgroundColor: isError ? Colors.red : Colors.green)
    );
  }

  throw Exception("Either a buildContext or scaffoldkey is required");

}

void showToast({ String message }) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14
  );
}