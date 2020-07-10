import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tareas/managers/extensions.dart';
import 'package:tareas/managers/startup.dart';
import 'package:tareas/network/auth/service.dart';

class StartupPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _StartupPageState();
  }

}


class _StartupPageState extends State<StartupPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StartupManager manager = StartupManager();


  @override
  void initState() {
    super.initState();
    manager.tryAutoInitialize(
      onSuccess: _presentHome,
      onError: (e) {
        _showSnackbar("Er ging iets mis, probeer opnieuw in te loggen");
      }
    );
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
