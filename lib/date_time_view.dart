import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OneDayView extends StatelessWidget {
  OneDayView({Key key, this.title, this.date}) : super(key: key);
  final String title;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat.yMMMMEEEEd();
    String formatted = formatter.format(date);
    return Text(formatted, style: TextStyle(fontSize: 20.0));
  }
}