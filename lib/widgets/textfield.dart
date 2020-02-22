import 'package:flutter/material.dart';

enum TextFieldType {
  filled,
  regular,
  search
}

class DefaultTextField extends StatelessWidget {

    final String hint;
    final String title;
    final bool obscureText;
    final bool showClearOption;
    final Function validator;
    final Function onSaved;
    final Function(String value) onSubmitted;
    final Function onChanged;
    final Function onEditingComplete;
    final TextCapitalization textCapitalization;
    final TextInputType textInputType;
    final TextEditingController controller;
    final FocusNode focusNode;
    final int maxLines;
    final TextFieldType textFieldType;
    final Key key;


    DefaultTextField ({ this.title, this.textFieldType = TextFieldType.regular, this.hint, this.obscureText = false, this.showClearOption = false, this.validator,
      this.onSaved, this.onSubmitted, this.onChanged, this.onEditingComplete, this.textCapitalization, this.textInputType, this.controller,
      this.focusNode, this.maxLines, this.key
    }) : super(key: key);

    InputBorder get errorBorder {
      return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      );
    }

    InputBorder get defaultBorder {
      return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black12),
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
        maxLines: maxLines,
        keyboardType: textInputType,
        focusNode: focusNode,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onSubmitted,
        obscureText: obscureText,
        onChanged: onChanged,

        style: TextStyle(
          fontSize: 14
        ),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: title,
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