import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime beginOfWeek(DateTime date) {
  return date.subtract(Duration(days: date.weekday - 1));
}

DateTime endOfWeek(DateTime date) {
  return date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
}

DateTime beginOfMonth(DateTime date) {
  return DateTime(date.year, date.month);
}

DateTime endOfMonth(DateTime date) {
  return DateTime(date.year, date.month + 1).subtract(Duration(days: 1));
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

class OneDayView extends StatelessWidget {
  OneDayView({Key key, this.date}) : super(key: key);
  final DateTime date;
  final formatter = new DateFormat.yMMMMEEEEd();

  @override
  Widget build(BuildContext context) {
    String formatted = formatter.format(date);
    return Text(formatted, style: TextStyle(fontSize: 20.0));
  }
}

class WeekStringView extends StatelessWidget {
  WeekStringView({Key key, this.date}) : super(key: key);
  final formatter = new DateFormat.MMMMd();
  final DateTime date;

  @override
  Widget build(BuildContext context) {
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

class MonthStringView extends StatelessWidget {
  MonthStringView({Key key, this.date}) : super(key: key);
  final formatter = new DateFormat.yMMMM();
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    String string = formatter.format(date);
    return Text(formatter.format(date), style: TextStyle(fontSize: 20.0));
  }
}
