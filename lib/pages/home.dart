import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tareas/extensions/brand_colors.dart';
import 'package:tareas/extensions/top_border_clipper.dart';
import 'package:tareas/extensions/translation_keys.dart';
import 'package:tareas/pages/profile.dart';
import 'package:tareas/pages/subscribed_tasks.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}



class _HomePageState extends State<HomePage> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SafeArea(
                top: true,
                bottom: false,
                child: TabBarView(
                  children: <Widget>[
                    Container(
                      child: Text("page1"),
                    ),
                    SubscribedTasksPage(),
                    ProfilePage()
                  ],
                ),
              ),
            ),
            ClipPath(
              clipper: TopBorderClipper(borderHeight: 10),
              child: Container(
                  color: BrandColors.primaryColor,
                  padding: EdgeInsets.only(
                    top: 15
                  ),
                  child: SafeArea(
                    bottom: true,
                    top: false,
                    child: TabBar(
                      indicatorColor: Colors.transparent,
                      tabs: <Widget>[
                        Tab(
                          icon: FaIcon(FontAwesomeIcons.thLarge),
                          text: FlutterI18n.translate(context, TranslationKeys.open),
                        ),
                        Container(
                          child: Tab(
                            icon: FaIcon(FontAwesomeIcons.tasks),
                            text: FlutterI18n.translate(context, TranslationKeys.subscribed),
                          ),
                          padding: EdgeInsets.only(
                            bottom: 10
                          ),
                        ),
                        Tab(
                          icon: FaIcon(FontAwesomeIcons.userAlt),
                          text: FlutterI18n.translate(context, TranslationKeys.profile),
                        )
                      ],
                    ),
                  ),
              ),
            )

          ],
        ),
        length: 3,
      ),
    );
  }

}