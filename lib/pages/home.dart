import 'package:flutter/material.dart';
import 'package:tareas/pages/profile.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {


  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3,
        vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            text: "Open activiteiten",
          ),
          Tab(
            text: "Ingeschreven",
          ),
          Tab(
            text: "Profiel",
          )
        ],
      ),
      body: DefaultTabController(
        child: TabBarView(
          controller: _tabController,
          children: [
            Container(),
            Container(),
            ProfilePage(),
          ],
        ),
        length: 3,
      ),
    );
  }

}