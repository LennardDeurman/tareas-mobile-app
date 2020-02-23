import 'package:flutter/material.dart';
import 'package:tareas/extensions/brand_colors.dart';


class LoginTextField extends StatelessWidget {

    final String hint;
    final bool obscureText;
    final Function validator;
    final Function onSaved;
    final TextEditingController controller;
    final Key key;


    LoginTextField ({  this.hint, this.obscureText = false, this.validator,
      this.onSaved, this.controller,
      this.key
    }) : super(key: key);

    InputBorder get errorBorder {
      return OutlineInputBorder(
        borderSide: BorderSide(color: BrandColors.errorColor),
        borderRadius: BorderRadius.circular(10),
      );
    }

    InputBorder get defaultBorder {
      return OutlineInputBorder(
        borderSide: BorderSide(color: BrandColors.inputColor),
        borderRadius: BorderRadius.circular(10),
      );
    }

    EdgeInsets get contentPadding {
      return EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0);
    }



    @override
    Widget build(BuildContext context) {
      return TextFormField(
        onSaved: onSaved,
        controller: controller,
        validator: validator,
        textInputAction: TextInputAction.done,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 14
        ),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: defaultBorder,
          enabledBorder: defaultBorder,
          focusedBorder: defaultBorder,
          errorBorder: errorBorder,
          focusedErrorBorder: errorBorder,
          contentPadding: contentPadding,
          hintText: hint,
        ),
      );
    }

}