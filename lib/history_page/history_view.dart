import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/common_widgets/employer_panel.dart';
//import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/history_page/history_day_mode_view.dart';
import 'package:Calmission/history_page/history_week_mode_view.dart';
import 'package:Calmission/history_page/history_month_mode_view.dart';
import 'package:Calmission/history_page/history_year_mode_view.dart';

class HistoryView extends StatefulWidget {
  HistoryView({Key key}) : super(key: key);
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final DateTime date = DateTime.now();
  Commission commission =
      Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);

  String _value;
  final List<String> _values = ["Day", "Week", "Month", "Year"];

  @override
  void initState() {
    super.initState();
    _value = _values.elementAt(0);
  }

  DateTime getDateOnly(DateTime dateAndTime) {
    return DateTime(dateAndTime.year, dateAndTime.month, dateAndTime.day);
  }

  _onChange(String value) {
    setState(() {
      _value = value;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    List<Widget> historyModeViewsArray = [
      Container(child: HistoryDayModeView()),
      Container(child: HistoryWeekModeView()),
      Container(child: HistoryMonthModeView()),
      Container(child: HistoryYearModeView()),
    ];

    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop()),
          elevation: 0.0,
          title: Text(
            "History",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            DropdownButton(
              value: _value,
              items: _values.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.date_range),
                      Container(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: Text(value))
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String value) {
                _onChange(value);
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: historyModeViewsArray[_values.indexOf(_value)],
            )
          ],
        ));
  }
}
