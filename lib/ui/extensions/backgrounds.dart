import 'package:flutter/material.dart';

class BackgroundsBuilder {

  Widget loadingBackground() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget noResultsBackground() {
    return Container(
      child: Center(
        child: Text("No result"),
      ),
    );
  }

  Widget errorBackground() {
    return Container(
      child: Center(
        child: Text("Error occured"),
      ),
    );
  }

}