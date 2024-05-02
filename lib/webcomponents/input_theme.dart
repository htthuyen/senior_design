
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyInputTheme{
  TextStyle _builtTextStyle(Color color, {double size = 30.0}) {
    return GoogleFonts.oswald(
      color: color,
      fontSize: size,
     
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(
        color: color,
        width: 1.0,
      ),
      
    );
  }

  InputDecorationTheme theme() => InputDecorationTheme(
    contentPadding: const EdgeInsets.all(25),
    floatingLabelBehavior: FloatingLabelBehavior.always,
  constraints: const BoxConstraints(maxWidth: 500),
    filled: true,
    fillColor: Color(0xFFD9D9D9),
    /// boders
    enabledBorder: _buildBorder(Color.fromRGBO(217, 217, 217, 1)),
    // Has error but not focus
    errorBorder: _buildBorder(Colors.red),
    // Has error and focus
    focusedErrorBorder: _buildBorder(Colors.blue),
    //enabled and focused
    focusedBorder: _buildBorder(Colors.blue),
    //disable border:
    disabledBorder: _buildBorder(Colors.grey[400]!),


    /// textStyle
    floatingLabelStyle: _builtTextStyle(Color(0xFF545454)),
    errorStyle:  _builtTextStyle(Colors.red, size: 12.0),
    labelStyle:  _builtTextStyle(Color(0xFF545454)),
    helperStyle: _builtTextStyle(Colors.black, size:12.0),
    isCollapsed: true,
  );
}