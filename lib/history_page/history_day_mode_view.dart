import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:async';

import '../models/employer.dart';
import '../logic/app_state.dart';
import '../commission_data_view.dart';
import '../models/commission.dart';
import '../date_time_view.dart';

class _HistoryDayModeViewModel {
  _HistoryDayModeViewModel({this.currentEmployer});

  final Employer currentEmployer;
}

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
        firstDate: DateTime(2016));

    if (datePicked != null && datePicked != date) {
      setState(() {
        date = datePicked;
      });
    }
  }

  onPressBackButton(){
    setState(() {
          date = date.subtract(Duration(days: 1));
        });
  }
  onPressNextButton(){
    setState(() {
          date = date.add(Duration(days: 1));
        });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _HistoryDayModeViewModel>(
        converter: (store) {
      return _HistoryDayModeViewModel(
          currentEmployer: store.state.currentEmployer);
    }, builder: (BuildContext context, _HistoryDayModeViewModel viewModel) {
      return Column(
        children: <Widget>[
          Container(
              color: Colors.greenAccent,
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                        child: Column(
                          children: <Widget>[
                            Text("Select Date"),
                            Icon(Icons.calendar_today, color: Colors.red,)
                          ],
                        ),
                        onPressed: () => onPressCalender(context)),
                    // IconButton(
                    //   icon: Icon(Icons.calendar_today),
                    //   color: Colors.red,
                    //   onPressed: () => onPressCalender(context),
                    // ),
                    OneDayView(
                      date: date,
                    ),
                  ],
                ),
              )),
          Expanded(
              child: DayEditView(
            date: date,
            commission: commission,
            nextButton: IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: onPressNextButton,
            ),
            backButton: IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: onPressBackButton,
            )
          ))
        ],
      );
    });
  }
}
