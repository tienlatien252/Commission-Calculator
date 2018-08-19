import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import '../models/employer.dart';
import '../logic/app_state.dart';
import '../commission_data_view.dart';
import '../models/commission.dart';
import '../date_time_view.dart';
import '../edit_data_view.dart';

class __HistoryWeekModeViewModel {
  __HistoryWeekModeViewModel({this.currentUser, this.currentEmployer});

  final FirebaseUser currentUser;
  final Employer currentEmployer;
}

class HistoryWeekModeView extends StatefulWidget {
  HistoryWeekModeView({Key key}) : super(key: key);
  @override
  _HistoryWeekModeViewState createState() => _HistoryWeekModeViewState();
}

class _HistoryWeekModeViewState extends State<HistoryWeekModeView> {
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

  onPressBackButton() {
    setState(() {
      date = date.subtract(Duration(days: DateTime.daysPerWeek));
    });
  }

  onPressNextButton() {
    setState(() {
      date = date.add(Duration(days: DateTime.daysPerWeek));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, __HistoryWeekModeViewModel>(
        converter: (store) {
      return __HistoryWeekModeViewModel(
          currentEmployer: store.state.currentEmployer);
    }, builder: (BuildContext context, __HistoryWeekModeViewModel viewModel) {
      return Column(
        children: <Widget>[
          Container(
              color: Colors.greenAccent,
              //padding: EdgeInsets.all(10.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: WeekStringView(
                        date: date,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      color: Colors.red,
                      onPressed: () => onPressCalender(context),
                    ),
                  ],
                ),
              )),
          Expanded(
              child: WeekDataView(
                  date: date,
                  commission: commission,
                  nextButton: IconButton(
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: onPressNextButton,
                  ),
                  backButton: IconButton(
                    icon: Icon(Icons.keyboard_arrow_left),
                    onPressed: onPressBackButton,
                  )))
        ],
      );
    });
  }
}

class WeekDataView extends StatefulWidget {
  WeekDataView(
      {Key key, this.date, this.commission, this.nextButton, this.backButton})
      : super(key: key);
  final DateTime date;
  final Commission commission;
  final Widget nextButton;
  final Widget backButton;

  @override
  _WeekDataViewState createState() => _WeekDataViewState();
}

class _WeekDataViewState extends State<WeekDataView> {
  Commission commission;

  Future _getCommission(__HistoryWeekModeViewModel viewModel) {
    String id = viewModel.currentUser.uid;
    DateTime beginWeek = getDateOnly(beginOfWeek(widget.date));
    DateTime endWeek = getDateOnly(endOfWeek(widget.date));

    String pathString = 'users/' +
        id +
        '/employers/' +
        viewModel.currentEmployer.employerId +
        '/commission';

    return Firestore.instance
        .collection(pathString)
        .where('date', isGreaterThanOrEqualTo: beginWeek)
        .where('date', isLessThanOrEqualTo: endWeek)
        .getDocuments();
  }

  Commission _getCommissionData(AsyncSnapshot snapshot) {
    if (snapshot.data.documents.length != 0) {
      commission = Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);
      List<DocumentSnapshot> retunredCommissions = snapshot.data.documents;

      retunredCommissions.forEach((commissionData) {
        commission.raw += commissionData.data['raw'].toDouble();
        commission.commission += commissionData.data['commission'].toDouble();
        commission.tip += commissionData.data['tip'].toDouble();
        commission.total += commissionData.data['total'].toDouble();
        commission.id == commissionData.documentID;
      });

      return commission;
    }
    return Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);
  }

  Future<Null> _openEditCommissionDialog(Employer employer) async {
    // TODO implement the dialog
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return EditDataView(
            title: "Edit Comission",
            date: getDateOnly(widget.date),
            commission: commission,
          );
        });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, __HistoryWeekModeViewModel>(
        converter: (store) {
      return __HistoryWeekModeViewModel(
          currentUser: store.state.currentUser,
          currentEmployer: store.state.currentEmployer);
    }, builder: (BuildContext context, __HistoryWeekModeViewModel viewModel) {
      return FutureBuilder(
        future: _getCommission(viewModel),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              commission = _getCommissionData(snapshot);
              Widget dataAndButton = widget.backButton != null
                  ? Expanded(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        widget.backButton,
                        CommissionView(commission: commission),
                        widget.nextButton
                      ],
                    ))
                  : CommissionView(commission: commission);
              return Column(
                children: <Widget>[
                  dataAndButton,
                  // Container(
                  //   alignment: AlignmentDirectional.bottomEnd,
                  //   padding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                  //   child: FloatingActionButton(
                  //       onPressed: () => _openEditCommissionDialog(null),
                  //       child: Icon(Icons.edit)),
                  // )
                ],
              );
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return Text('Result: ${snapshot.data}');
          }
        },
      );
    });
  }
}