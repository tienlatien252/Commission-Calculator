import 'package:flutter/material.dart';
import 'package:Calmission/localization/localization.dart';

String validateEmail(BuildContext context, String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return FFULocalizations.of(context).emailNotValidMessage;
  else
    return null;
}

String validateName(BuildContext context, String value) {
  if (value.length < 3)
    return FFULocalizations.of(context).nameLengthMessage;
  else
    return null;
}

String validatePassword(BuildContext context, String value) {
  Pattern numberPattern = r'[0-9]';
  RegExp numberRegex = new RegExp(numberPattern);
  Pattern lowerCasePattern = r'[a-z]';
  RegExp lowerCasRegex = new RegExp(lowerCasePattern);
  Pattern upperCasePattern = r'[A-Z]';
  RegExp upperCasRegex = new RegExp(upperCasePattern);
  if (value.length < 6) {
    return FFULocalizations.of(context).passwordLengthMessage;
  }
  if (!numberRegex.hasMatch(value)) {
    return FFULocalizations.of(context).passwordDigitMessage;
  }
  if (!lowerCasRegex.hasMatch(value) && !upperCasRegex.hasMatch(value)) {
    return 'Password must contain at least one letter';
  } else
    return null;
}



  String validateNameString(BuildContext context, String value) {
    if (value.length == 0) {
      return 'The name field must not be empty';
    }
    return null;
  }