import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OneDayView extends StatelessWidget {
  OneDayView({Key key, this.title, this.date}) : super(key: key);
  final String title;
  final DateTime date;
  final formatter = new DateFormat.yMMMMEEEEd();

  @override
  Widget build(BuildContext context) {
    String formatted = formatter.format(date);
    return Text(formatted, style: TextStyle(fontSize: 20.0));
  }
}

DateTime beginOfWeek(DateTime date) {
  return date.subtract(Duration(days: date.weekday - 1));
}

DateTime endOfWeek(DateTime date) {
  return date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
}

DateTime secondEndOfWeek(DateTime date) {
  final formatter = new DateFormat.yMMMMEEEEd();
  DateTime endOfWeek = DateTime.now();
  String dateString = formatter.format(beginOfWeek(date));
  String todayString = formatter.format(beginOfWeek(DateTime.now()));
  if (dateString != todayString) {
    endOfWeek = date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
  }
  return endOfWeek;
}

class WeekStringView extends StatelessWidget {
  WeekStringView({Key key, this.title, this.date}) : super(key: key);
  final formatter = new DateFormat.MMMMd();
  final String title;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    //String formatted = formatter.format(date);
    return Row(
      children: <Widget>[
        Text(formatter.format(beginOfWeek(date)),
            style: TextStyle(fontSize: 20.0)),
        Text("-"),
        Text(formatter.format(endOfWeek(date)),
            style: TextStyle(fontSize: 20.0)),
      ],
    );
  }
}
