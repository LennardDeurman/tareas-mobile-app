import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/constants/custom_fonts.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/asset_paths.dart';

class LoginFormUI {

  Widget subText(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 15
      ),
      child: Text(
        FlutterI18n.translate(context, TranslationKeys.loginPageSubText),
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            fontFamily: CustomFonts.openSans
        ),
      ),
    );
  }


  Widget signInButton(BuildContext context, { Function onPressed }) {
    return SizedBox(
        width: double.infinity,
        child: FlatButton(
          textColor: Colors.white,
          color: BrandColors.primaryColor,
          padding: EdgeInsets.symmetric(
              vertical: 14
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          child: Text(
              FlutterI18n.translate(context, TranslationKeys.signIn),
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  fontFamily: CustomFonts.openSans
              )
          ),
          onPressed: onPressed,
        )
    );
  }

  Widget caption(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Text(
          FlutterI18n.translate(context, TranslationKeys.loginCaptionText),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: CustomFonts.openSans
          )
      ),
    );
  }

  Widget logo(BuildContext context) {

    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Image(
            image: AssetImage(AssetPaths.loginLogo),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: 5
          ),
          child: Text(
            FlutterI18n.translate(context, TranslationKeys.appName).toLowerCase(),
            style: TextStyle(
                color: BrandColors.secondaryColor,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                fontFamily: CustomFonts.openSans
            ),
          ),
        )
      ],
    );
  }



}

class LoginForm extends StatelessWidget with LoginFormUI {

  final Function(BuildContext context) onSignInPressed;

  LoginForm ({ this.onSignInPressed });

  @override
  Widget build(BuildContext context) {


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        logo(context),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 20.0,
                )
              ]
          ),
          child: Center(
            child: Form(child: Container(
                padding: EdgeInsets.all(14),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    caption(context),
                    subText(context),
                    SizedBox(
                      height: 30,
                    ),
                    signInButton(context, onPressed: () {
                      onSignInPressed(context);
                    })
                  ],
                )
            )),
          ),
          constraints: BoxConstraints(
              maxWidth: 320
          ),
        )
      ],
    );
  }

}