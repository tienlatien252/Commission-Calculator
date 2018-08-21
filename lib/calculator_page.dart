import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'models/employer.dart';
import 'logic/app_state.dart';
import 'commission_data_view.dart';
import 'models/commission.dart';
import 'date_time_view.dart';

class __CalculatorPageViewModel {
  __CalculatorPageViewModel({this.currentUser, this.currentEmployer});

  final FirebaseUser currentUser;
  final Employer currentEmployer;
}

class CalculatorPage extends StatefulWidget {
  CalculatorPage({Key key}) : super(key: key);
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  Commission commission =
      Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);

  Future<Null> onPickStartDate(BuildContext context) async {
    final datePicked = await showDatePicker(
        context: context,
        initialDate: startDate,
        lastDate: DateTime.now(),
        firstDate: DateTime(startDate.year - 5));

    if (datePicked != null && datePicked != startDate) {
      setState(() {
        startDate = datePicked;
      });
    }
  }

  Future<Null> onPickEndDate(BuildContext context) async {
    final datePicked = await showDatePicker(
        context: context,
        initialDate: endDate,
        lastDate: DateTime.now(),
        firstDate: DateTime(endDate.year - 5));

    if (datePicked != null && datePicked != endDate) {
      setState(() {
        endDate = datePicked;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, __CalculatorPageViewModel>(
        converter: (store) {
      return __CalculatorPageViewModel(
          currentEmployer: store.state.currentEmployer);
    }, builder: (BuildContext context, __CalculatorPageViewModel viewModel) {
      return Column(
        children: <Widget>[
          Container(
              alignment: AlignmentDirectional.centerStart,
              padding: EdgeInsets.fromLTRB(10.0, 17.0, 10.0, 17.0),
              child: Text(
                viewModel.currentEmployer.name,
                style: TextStyle(fontSize: 30.0),
              )),
          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Start:"),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: ShortOneDayView(
                          date: startDate,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    color: Colors.red,
                    onPressed: () => onPickStartDate(context),
                  ),
                ],
              )),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("End:"),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: ShortOneDayView(
                          date: endDate,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    color: Colors.red,
                    onPressed: () => onPickEndDate(context),
                  ),
                ],
              )),
          // Expanded(
          //     child: CustomDataView(
          //         date: date,
          //         commission: commission,
          //         nextButton: IconButton(
          //           icon: Icon(Icons.keyboard_arrow_right),
          //           onPressed: onPressNextButton,
          //         ),
          //         backButton: IconButton(
          //           icon: Icon(Icons.keyboard_arrow_left),
          //           onPressed: onPressBackButton,
          //         )))
        ],
      );
    });
  }
}

class CustomDataView extends StatefulWidget {
  CustomDataView(
      {Key key, this.date, this.commission, this.nextButton, this.backButton})
      : super(key: key);
  final DateTime date;
  final Commission commission;
  final Widget nextButton;
  final Widget backButton;

  @override
  _CustomDataViewState createState() => _CustomDataViewState();
}

class _CustomDataViewState extends State<CustomDataView> {
  Commission commission;

  Future _getCommission(__CalculatorPageViewModel viewModel) {
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
    return StoreConnector<AppState, __CalculatorPageViewModel>(
        converter: (store) {
      return __CalculatorPageViewModel(
          currentUser: store.state.currentUser,
          currentEmployer: store.state.currentEmployer);
    }, builder: (BuildContext context, __CalculatorPageViewModel viewModel) {
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
