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

class __HistoryYearModeViewModel {
  __HistoryYearModeViewModel({this.currentUser, this.currentEmployer});

  final FirebaseUser currentUser;
  final Employer currentEmployer;
}

class HistoryYearModeView extends StatefulWidget {
  HistoryYearModeView({Key key}) : super(key: key);
  @override
  _HistoryYearModeViewState createState() => _HistoryYearModeViewState();
}

class _HistoryYearModeViewState extends State<HistoryYearModeView> {
  DateTime date = DateTime.now();
  Commission commission =
      Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);

  Future<Null> onPressCalender(BuildContext context) async {
    final datePicked = await showDatePicker(
      initialDatePickerMode: DatePickerMode.year,
        context: context,
        initialDate: date,
        lastDate: DateTime.now(),
        firstDate: DateTime(date.year -5));

    if (datePicked != null && datePicked != date) {
      setState(() {
        date = datePicked;
      });
    }
  }

  onPressBackButton() {
    setState(() {
      date = DateTime(date.year -1);
    });
  }

  onPressNextButton() {
    setState(() {
      date = DateTime(date.year +1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, __HistoryYearModeViewModel>(
        converter: (store) {
      return __HistoryYearModeViewModel(
          currentEmployer: store.state.currentEmployer);
    }, builder: (BuildContext context, __HistoryYearModeViewModel viewModel) {
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
                      child: YearStringView(
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
              child: YearDataView(
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

class YearDataView extends StatefulWidget {
  YearDataView(
      {Key key, this.date, this.commission, this.nextButton, this.backButton})
      : super(key: key);
  final DateTime date;
  final Commission commission;
  final Widget nextButton;
  final Widget backButton;

  @override
  _YearDataViewState createState() => _YearDataViewState();
}

class _YearDataViewState extends State<YearDataView> {
  Commission commission;

  Future _getCommission(__HistoryYearModeViewModel viewModel) {
    String id = viewModel.currentUser.uid;
    DateTime beginYear = getDateOnly(beginOfYear(widget.date));
    DateTime endYear = getDateOnly(endOfYear(widget.date));

    String pathString = 'users/' +
        id +
        '/employers/' +
        viewModel.currentEmployer.employerId +
        '/commission';

    return Firestore.instance
        .collection(pathString)
        .where('date', isGreaterThanOrEqualTo: beginYear)
        .where('date', isLessThanOrEqualTo: endYear)
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, __HistoryYearModeViewModel>(
        converter: (store) {
      return __HistoryYearModeViewModel(
          currentUser: store.state.currentUser,
          currentEmployer: store.state.currentEmployer);
    }, builder: (BuildContext context, __HistoryYearModeViewModel viewModel) {
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