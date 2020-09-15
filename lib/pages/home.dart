import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/icons.dart';
import 'package:tareas/ui/extensions/clippers.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/pages/open_activities.dart';
import 'package:tareas/pages/profile.dart';
import 'package:tareas/pages/subscribed_activities.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {


  TabController _controller;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        child: Container(
          color: Colors.white,
          child: SafeArea(
            top: true,
            bottom: false,
            child: Container(
              color: BrandColors.primaryColor,
              child: SafeArea(
                child: Container(
                  color: Colors.white,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(child: TabBarView(
                              controller: _controller,
                              children: <Widget>[
                                OpenActivitiesPage(),
                                SubscribedActivitiesPage(),
                                ProfilePage()
                              ],
                            ), margin: EdgeInsets.only(
                              bottom: 90
                            ))
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ClipPath(
                          clipper: TopBorderClipper(borderHeight: 10),
                          child: Container(
                            height: 100,
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: TabBar(
                                    indicatorColor: Colors.transparent,
                                    labelColor: Colors.white,
                                    controller: _controller,
                                    tabs: <Widget>[
                                      Tab(
                                        icon: SvgPicture.asset(
                                          IconAssetPaths.thLarge,
                                          width: 24,
                                          height: 24,
                                          color: Colors.white,
                                        ),
                                        text: FlutterI18n.translate(context, TranslationKeys.open),
                                      ),
                                      Container(
                                        child: Tab(
                                          icon: SvgPicture.asset(
                                              IconAssetPaths.tasks,
                                              width: 24,
                                              height: 24,
                                              color: Colors.white,
                                          ),
                                          text: FlutterI18n.translate(context, TranslationKeys.subscribed),
                                        ),
                                        padding: EdgeInsets.only(
                                            bottom: 10
                                        ),
                                      ),
                                      Tab(
                                        icon: SvgPicture.asset(
                                            IconAssetPaths.user,
                                            width: 24,
                                            height: 24,
                                            color: Colors.white,
                                        ),
                                        text: FlutterI18n.translate(context, TranslationKeys.profile),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            color: BrandColors.primaryColor,
                          )
                        )
                      )
                    ],
                  ),
                ),
                top: false,
                bottom: true,
              ),
            ),
          ),
        ),
        length: 3,
      ),
    );
  }

}