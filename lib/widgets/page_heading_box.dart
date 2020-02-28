import 'package:flutter/material.dart';
class PageHeadingBox extends StatelessWidget {

  final String title;

  PageHeadingBox ({
    @required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: buildAppBarChildren(),
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w600
        ),
      )
    );
  }

  List<Widget> buildAppBarChildren() {
    return [
      buildTitle()
    ];
  }

}