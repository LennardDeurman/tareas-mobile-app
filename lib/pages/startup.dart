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
import 'package:tareas/constants/asset_paths.dart';
import 'package:tareas/constants/brand_colors.dart';

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

    manager.tryAutoInitialize(
      onSuccess: _presentHome,
      onError: (e) {
        if (e is MissingIdentityError) {
          _presentRetryDialog();
        } else {
          _showSnackbar(FlutterI18n.translate(context, TranslationKeys.connectionErrorMessage));
        }
      }
    );

    super.initState();
  }

  void _presentRetryDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
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
                        onPressed: () {
                          this.manager.tryAutoInitialize(
                              onSuccess: () {
                                Navigator.pop(context);
                                _presentHome();
                              }
                          );
                        },
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
                      onPressed: () {
                        this.manager.loadingDelegate.isLoading = false;
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              )
          );
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
        _showSnackbar(FlutterI18n.translate(context, TranslationKeys.errorLogin));
      }
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
                      image: AssetImage(AssetPaths.loading),
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
                    child: LoginForm(onSignInPressed: (BuildContext context) {
                      _onContinueClicked();
                    }),
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
