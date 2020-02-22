import 'package:flutter/material.dart';
import 'package:tareas/extensions/asset_paths.dart';
import 'package:tareas/extensions/brand_colors.dart';
import 'package:tareas/extensions/custom_fonts.dart';
import 'package:tareas/widgets/textfield.dart';

class LoginForm extends StatelessWidget {

  Widget _buildCaption() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15
      ),
      child: Text(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi feugiat, massa eu ultrices viverra, lorem sem faucibus est, ut ullamcorper est nisl at turpis. ",
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            fontFamily: CustomFonts.openSans
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10
      ),
      child: Text(
        "tareas",
        style: TextStyle(
            color: BrandColors.secondaryColor,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            fontFamily: CustomFonts.openSans
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
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
              "Inloggen",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  fontFamily: CustomFonts.openSans
              )
          ),
          onPressed: () {

          },
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


  Widget _buildTextField({ String label, bool obscureText = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 5
      ),
      child: DefaultTextField(
        hint: label,
        obscureText: obscureText,
      ),
    );
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
              child: Container(
                padding: EdgeInsets.all(14),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildTitle(),
                    _buildCaption(),
                    _buildTextField(
                      label: "Gebruikersnaam",
                    ),
                    _buildTextField(
                      label: "Wachtwoord",
                      obscureText: true
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _buildConfirmButton()

                  ],
                )
              ),
            ),
            constraints: BoxConstraints(
                maxWidth: 350
            ),
        )
      ],
    );
  }

}