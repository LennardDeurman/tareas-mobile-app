import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tareas/managers/extensions.dart';
import 'package:tareas/managers/startup.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/ui/extensions/clippers.dart';
import 'package:tareas/constants/asset_paths.dart';
import 'package:tareas/constants/brand_colors.dart';

class StartupPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _StartupPageState();
  }

}


class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }

}



class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

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


class _StartupPageState extends State<StartupPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StartupManager manager = StartupManager();


  @override
  void initState() {

    manager.tryAutoInitialize(
      onSuccess: _presentHome,
      onError: (e) {
        _showSnackbar("Er ging iets mis, probeer opnieuw in te loggen");
      }
    );

    super.initState();
  }

  void _presentHome() {
    AuthService().presentHome(context);
  }

  void _showSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: Text(
                message
            )
        )
    );
  }

  void _onContinueClicked() {
    manager.initializeAuth(
      onSuccess: _presentHome,
      onError: (e) {
        _showSnackbar("Er kon niet worden ingelogd");
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: ScopedModel<LoadingDelegate>(
            model: this.manager.loadingDelegate,
            child: ScopedModelDescendant<LoadingDelegate>(
              builder: (context, child, model) {
                if (this.manager.loadingDelegate.isLoading) {
                  return SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return RaisedButton(
                    child: Text("Doorgaan"),
                    onPressed: _onContinueClicked,
                  );
                }
              }
            ),
          ),
        ),
      ),
    );
  }

}
