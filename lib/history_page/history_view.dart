import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/commission.dart';
import 'history_day_mode_view.dart';
import 'history_week_mode_view.dart';
import 'history_month_mode_view.dart';
import 'history_year_mode_view.dart';

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
  Widget build(BuildContext context) {
    List<Widget> historyModeViewsArray = [
      Container(child: HistoryDayModeView()),
      Container(child: HistoryWeekModeView()),
      Container(child: HistoryMonthModeView()),
      Container(child: HistoryYearModeView()),
    ];

    return StoreConnector<AppState, _HistoryViewModel>(
      converter: (store) {
        return _HistoryViewModel(
            currentUser: store.state.currentUser,
            currentEmployer: store.state.currentEmployer);
      },
      builder: (BuildContext context, _HistoryViewModel viewModel) {
        return Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(15.0),
                        topRight: const Radius.circular(15.0))
                    //borderRadius: BorderRadius.circular(15.0)
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: Text(
                            viewModel.currentEmployer.name,
                            style:
                                TextStyle(fontSize: 40.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          //color: Colors.white,
                          color: Theme.of(context).primaryColorLight),
                      child: DropdownButton(
                        value: _value,
                        items: _values.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.date_range),
                                Container(
                                    padding: EdgeInsets.fromLTRB(
                                        10.0, 0.0, 10.0, 0.0),
                                    child: Text(value))
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          _onChange(value);
                        },
                      ),
                    )
                  ],
                )),
            Expanded(
              child: historyModeViewsArray[_values.indexOf(_value)],
            )
          ],
        );
      },
    );
  }
}
