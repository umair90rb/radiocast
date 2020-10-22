import 'package:flutter/material.dart';

Widget formInputField(hint, controller, {Pattern pat = '.', bool isPassword = false, bool isEnabled = false, String helperText = null, bool validation = true, var icon = null, Function onChanged}){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 4),
    child: TextFormField(
      onChanged: onChanged,
      obscureText: isPassword,
      controller: controller,
      showCursor: true,
      decoration: InputDecoration(
        prefixIcon: icon,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        isDense: true,
        border: OutlineInputBorder(),
        hintText: hint,
        helperText: helperText
      ),
      validator: (value) {
        if(validation == false) return null;
        if (value.isEmpty) {
          return hint+' is required';
        }

        Pattern pattern = pat;

        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value))
          return 'Enter valid '+hint;
        else
          return null;
      },
    ),
  );
}