import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Utility{

  /// function to format date in the given format
  static getDateFormatter(String pattern, DateTime dateTime){
    var formatter = DateFormat(pattern);
    return formatter.format(dateTime);
  }

  /// function to show toast message
  static showToast(String message){
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black87,
        fontSize: 12.0,
    );
  }

}