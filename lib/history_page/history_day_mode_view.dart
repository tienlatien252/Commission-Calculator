import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:Calmission/commission_page/commission_data_view.dart';
import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/common_widgets/date_time_widgets.dart';

class HistoryDayModeView extends StatefulWidget {
  HistoryDayModeView({Key key}) : super(key: key);
  @override
  _HistoryDayModeViewState createState() => _HistoryDayModeViewState();
}

class _HistoryDayModeViewState extends State<HistoryDayModeView> {
  DateTime date = DateTime.now();
  Commission commission =
      Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);

  Future<Null> onPressCalender(BuildContext context) async {
    final datePicked = await showDatePicker(
        context: context,
        initialDate: date,
        lastDate: DateTime.now(),
        firstDate: DateTime(date.year - 5));

    if (datePicked != null && datePicked != date) {
      setState(() {
        date = datePicked;
      });
    }
  }

  onPressBackButton() {
    setState(() {
      date = date.subtract(Duration(days: 1));
    });
  }

  onPressNextButton() {
    setState(() {
      date = date.add(Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    bottomLeft: const Radius.circular(15.0),
                    bottomRight: const Radius.circular(15.0))),
            color: Theme.of(context).primaryColor,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              //color: Color.fromARGB(255, 76, 183, 219),
              color: Theme.of(context).buttonColor,
              onPressed: () => onPressCalender(context),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.calendar_today,
                    color: Colors.black54,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Date:",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: ShortOneDayView(
                      date: date,
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
            child: Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
          child: DayScrollView(
              date: date,
              commission: commission,
              nextButton: IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: onPressNextButton,
              ),
              backButton: IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.arrow_back_ios),
                onPressed: onPressBackButton,
              )),
        ))
      ],
    );
  }
}
