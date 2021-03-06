import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/constants/asset_paths.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/logic/managers/startup.dart';
import 'package:tareas/network/auth/identity.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/ui/extensions/buttons.dart';
import 'package:tareas/ui/extensions/clippers.dart';
import 'package:tareas/ui/login_form.dart';
import 'package:tareas/constants/brand_colors.dart';

class StartupPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _StartupPageState();
  }

}

class _RetryDialog extends StatelessWidget {

  final StartupManager manager;
  final Function onRetryPressed;
  final Function onCloseAndReLoginPressed;

  _RetryDialog (this.manager, { @required this.onRetryPressed, @required this.onCloseAndReLoginPressed });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.only(
            left: 24,
            top: 24,
            right: 24,
            bottom: 12
        ),
        title: Text(
          FlutterI18n.translate(context, TranslationKeys.connectionError),
          style: TextStyle(
              fontWeight: FontWeight.w600
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                child: Text(
                    FlutterI18n.translate(context, TranslationKeys.connectionErrorMessage)
                ),
                margin: EdgeInsets.only(
                    top: 10,
                    bottom: 35
                )
            ),
            ValueListenableBuilder(
              valueListenable: this.manager.loadingDelegate.notifier,
              builder: (BuildContext context, bool isLoading, Widget widget) {
                return PrimaryButton(
                  text: FlutterI18n.translate(context, TranslationKeys.reconnect),
                  color: BrandColors.primaryColor,
                  isLoading: this.manager.loadingDelegate.isLoading,
                  iconData: IconAssetPaths.globe,
                  onPressed: this.onRetryPressed,
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: FlatButton(
                child: Text(
                  FlutterI18n.translate(context, TranslationKeys.closeAndReconnect),
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.red
                  ),
                ),
                onPressed: this.onCloseAndReLoginPressed,
              ),
            )
          ],
        )
    );
  }

  static void show(BuildContext context, StartupManager startupManager, { @required Function onCloseAndReLoginPressed, @required Function onRetryPressed }) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return _RetryDialog(
            startupManager,
            onCloseAndReLoginPressed: onCloseAndReLoginPressed,
            onRetryPressed: onRetryPressed,
          );
        }
    );
  }

}


class _StartupPageState extends State<StartupPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StartupManager manager = StartupManager();


  void _handleAuthError(e) {
    _presentRetryDialog();
  }

  void _presentHome() {
    AuthService().presentHome(context);
  }

  @override
  void initState() {

    manager.tryAutoInitialize(
      onSuccess: _presentHome,
      onError: _handleAuthError
    );

    super.initState();
  }

  void _presentRetryDialog() {
    _RetryDialog.show(
      context,
      manager,
      onCloseAndReLoginPressed: ()  {
        AuthService().logout();
        Navigator.pop(context);
      },
      onRetryPressed: () {
        this.manager.tryAutoInitialize(
            onSuccess: () {
              Navigator.pop(context);
              _presentHome();
            }
        );
      }
    );
  }


  void _startLoginProcess() {
    manager.initializeAuth(
      onSuccess: _presentHome,
      onError: _handleAuthError
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ValueListenableBuilder(
        valueListenable: this.manager.loadingDelegate.notifier,
        builder: (BuildContext context, bool isLoading, Widget widget) {
          if (this.manager.loadingDelegate.isLoading) {
            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ImageAssetPaths.loading),
                      fit: BoxFit.cover
                  )
              ),
            );
          } else {
            return Container(
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                          flex: 6,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(ImageAssetPaths.loginBackground),
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
                    child: LoginForm(onSignInPressed: (BuildContext context) => _startLoginProcess()),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

}
