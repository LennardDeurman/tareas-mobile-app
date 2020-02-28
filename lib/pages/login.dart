import 'package:flutter/material.dart';
import 'package:tareas/extensions/asset_paths.dart';
import 'package:tareas/extensions/brand_colors.dart';
import 'package:tareas/extensions/top_border_clipper.dart';
import 'package:tareas/widgets/login_form.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }

}



class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AssetPaths.loginBackground),
                        fit: BoxFit.cover
                      )
                    ),
                  )
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Expanded(
                    flex: 5,
                    child: Container(
                      color: Colors.transparent,
                    )
                ),
                Expanded(
                  flex: 5,
                  child: ClipPath(
                    clipper: TopBorderClipper(borderHeight: 30),
                    child: Container(
                      color: BrandColors.primaryColor
                    ),
                  )
                )
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: LoginForm(),
            )
          ],
        ),
      ),
    );
  }

}