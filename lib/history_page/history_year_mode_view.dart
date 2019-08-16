import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import '../commission_views/commission_data_view.dart';
import '../models/commission.dart';
import 'package:Calmission/common_widgets/date_time_widgets.dart';

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
        firstDate: DateTime(date.year - 5));

    if (datePicked != null && datePicked != date) {
      setState(() {
        date = datePicked;
      });
    }
  }

  onPressBackButton() {
    setState(() {
      date = DateTime(date.year - 1);
    });
  }

  onPressNextButton() {
    setState(() {
      date = DateTime(date.year + 1);
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
                    borderRadius: BorderRadius.circular(30.0)),
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
                    Text("Year:", style: TextStyle(color: Colors.black54)),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: YearStringView(
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
            child: YearDataView(
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
                        CommissionView(
                            commission: commission,),
                        widget.nextButton
                      ],
                    ))
                  : Expanded(
                      child: CommissionView(
                      commission: commission,
                      numberFontSize: 30.0,
                      stringFontSize: 15.0,
                    ));
              return Column(
                children: <Widget>[
                  dataAndButton,
                ],
              );
            case ConnectionState.waiting:
              return Center(child: PlatformLoadingIndicator());
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
