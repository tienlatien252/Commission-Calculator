import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import '../models/employer.dart';
import '../logic/app_state.dart';
import '../commission_views/commission_data_view.dart';
import '../models/commission.dart';
import '../date_time_view.dart';

class _HistoryDayModeViewModel {
  _HistoryDayModeViewModel({this.currentUser, this.currentEmployer});

  final Employer currentEmployer;
  final FirebaseUser currentUser;
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
    return StoreConnector<AppState, _HistoryDayModeViewModel>(
        converter: (store) {
      return _HistoryDayModeViewModel(
          currentEmployer: store.state.currentEmployer);
    }, builder: (BuildContext context, _HistoryDayModeViewModel viewModel) {
      return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                      bottomLeft: const Radius.circular(10.0),
                      bottomRight: const Radius.circular(10.0))),
              color: Theme.of(context).primaryColorDark,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: Color.fromARGB(255, 76, 183, 219),
                onPressed: () => onPressCalender(context),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.calendar_today,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text("Date:"),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: OneDayView(
                        date: date,
                        textColor: Colors.white,
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
                )),
          ))
        ],
      );
    });
  }
}
