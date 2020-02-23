import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/extensions/asset_paths.dart';
import 'package:tareas/extensions/brand_colors.dart';
import 'package:tareas/extensions/custom_fonts.dart';
import 'package:tareas/extensions/translation_keys.dart';
import 'package:tareas/extensions/validators.dart';
import 'package:tareas/widgets/login_textfield.dart';

class LoginForm extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return LoginFormState();
  }

}

class LoginFormState extends State<LoginForm> {


  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget _buildSubText(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 15
      ),
      child: Text(
        FlutterI18n.translate(context, TranslationKeys.loginPageSubText),
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            fontFamily: CustomFonts.openSans
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 10
      ),
      child: Text(
        FlutterI18n.translate(context, TranslationKeys.appName),
        style: TextStyle(
            color: BrandColors.secondaryColor,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            fontFamily: CustomFonts.openSans
        ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
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
          onPressed: _signInPressed,
        )
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Image(
        image: AssetImage(AssetPaths.loginLogo),
      ),
    );
  }


  Widget _buildTextField({ String label, Function validator, bool obscureText = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 5
      ),
      child: LoginTextField(
        hint: label,
        validator: validator,
        obscureText: obscureText,
      ),
    );
  }


  void _signInPressed() {
    if (this.formKey.currentState.validate()) {
      this.formKey.currentState.save();
    }
  }


  @override
  Widget build(BuildContext context) {


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _buildLogo(),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
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
                    _buildTitle(context),
                    _buildSubText(context),
                    _buildTextField(
                        label: FlutterI18n.translate(context, TranslationKeys.username),
                        validator: (String value) {
                          return Validators.usernameValidator(value, context);
                        }
                    ),
                    _buildTextField(
                        label: FlutterI18n.translate(context, TranslationKeys.password),
                        obscureText: true,
                        validator: (String value) {
                          return Validators.passwordValidator(value, context);
                        }
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _buildSignInButton(context)
                  ],
                )
            ), key: formKey),
          ),
          constraints: BoxConstraints(
              maxWidth: 350
          ),
        )
      ],
    );
  }

}