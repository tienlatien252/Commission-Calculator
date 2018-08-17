import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/employer.dart';
import '../logic/app_state.dart';
import '../models/commission.dart';

class _HistoryViewModel {
  _HistoryViewModel({this.currentUser, this.currentEmployer});
  final Employer currentEmployer;
  final FirebaseUser currentUser;
}

class HistoryView extends StatefulWidget {
  HistoryView({Key key}) : super(key: key);
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

enum ViewOption { day, week, month, year }

class _HistoryViewState extends State<HistoryView> {
  final DateTime date = DateTime.now();
  Commission commission =
      Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);
  ViewOption _selection = ViewOption.day;
  List<bool> _checked = [true, false, false, false];

  DateTime getDateOnly(DateTime dateAndTime) {
    return DateTime(dateAndTime.year, dateAndTime.month, dateAndTime.day);
  }

  @override
  Widget build(BuildContext context) {
    var popupEntry = <CheckedPopupMenuItem<ViewOption>>[
      CheckedPopupMenuItem<ViewOption>(
        checked: _checked[ViewOption.day.index],
        value: ViewOption.day,
        child: const Text('Day', style: TextStyle(fontSize: 20.0)),
      ),
      CheckedPopupMenuItem<ViewOption>(
        checked: _checked[ViewOption.week.index],
        value: ViewOption.week,
        child: const Text('Week', style: TextStyle(fontSize: 20.0)),
      ),
      CheckedPopupMenuItem<ViewOption>(
        checked: _checked[ViewOption.month.index],
        value: ViewOption.month,
        child: const Text('Month', style: TextStyle(fontSize: 20.0)),
      ),
      CheckedPopupMenuItem<ViewOption>(
        checked: _checked[ViewOption.year.index],
        value: ViewOption.year,
        child: const Text('Year', style: TextStyle(fontSize: 20.0)),
      ),
    ];

    List<Widget> rangeType = [
      Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Day',
            style: TextStyle(fontSize: 20.0),
          )),
      Container(
          padding: EdgeInsets.all(10.0),
          child: Text('Week', style: TextStyle(fontSize: 20.0))),
      Container(
          padding: EdgeInsets.all(10.0),
          child: Text('Month', style: TextStyle(fontSize: 20.0))),
      Container(
          padding: EdgeInsets.all(10.0),
          child: Text('Year', style: TextStyle(fontSize: 20.0))),
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
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      viewModel.currentEmployer.name,
                      style: TextStyle(fontSize: 30.0),
                    ),
                    new PopupMenuButton<ViewOption>(
                      initialValue: ViewOption.day,
                      onSelected: (ViewOption result) {
                        setState(() {
                          _selection = result;
                          _checked = [false, false, false, false];
                          _checked[_selection.index] = true;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.date_range),
                          rangeType[_selection.index],
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                      itemBuilder: (BuildContext context) => popupEntry,
                    )
                  ],
                )),
          ],
        );
      },
    );
  }
}
