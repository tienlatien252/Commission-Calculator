import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import '../models/employer.dart';
import '../logic/app_state.dart';
import '../models/commission.dart';
import 'slivers.dart';
import 'small_commisison_widget.dart';
import 'all_commission_view.dart';
import 'time_range_picker_widget.dart';
import '../commission_views/commission_data_view.dart';

class CalculatorPageViewModel {
  CalculatorPageViewModel({this.currentUser, this.currentEmployer});

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
  Commission totalCommission =
      Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);
  List<Commission> listCommissions;

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

  Future _getCommission(CalculatorPageViewModel viewModel) {
    String id = viewModel.currentUser.uid;
    DateTime formatedStartDate = getDateOnly(startDate);
    DateTime formatedEndDate = getDateOnly(endDate);

    String pathString = 'users/' +
        id +
        '/employers/' +
        viewModel.currentEmployer.employerId +
        '/commission';
    return Firestore.instance
        .collection(pathString)
        .where('date', isGreaterThanOrEqualTo: formatedStartDate)
        .where('date', isLessThanOrEqualTo: formatedEndDate)
        .getDocuments();
  }

  Map<String, dynamic> _getAllCommissionsData(AsyncSnapshot snapshot) {
    totalCommission =
        Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);
    listCommissions = List<Commission>();
    if (snapshot.data.documents.length != 0) {
      List<DocumentSnapshot> retunredCommissions = snapshot.data.documents;

      retunredCommissions.forEach((commissionData) {
        listCommissions.add(Commission(
            commission: commissionData.data['commission'].toDouble(),
            raw: commissionData.data['raw'].toDouble(),
            tip: commissionData.data['tip'].toDouble(),
            total: commissionData.data['total'].toDouble(),
            date: commissionData.data['date'],
            id: commissionData.documentID));
        totalCommission.raw += commissionData.data['raw'].toDouble();
        totalCommission.commission +=
            commissionData.data['commission'].toDouble();
        totalCommission.tip += commissionData.data['tip'].toDouble();
        totalCommission.total += commissionData.data['total'].toDouble();
        totalCommission.id == commissionData.documentID;
      });
    }

    listCommissions = listCommissions.reversed.toList();
    return {
      'listCommissions': listCommissions,
      'totalCommission': totalCommission
    };
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CalculatorPageViewModel>(
        converter: (store) {
      return CalculatorPageViewModel(
        currentUser: store.state.currentUser,
          currentEmployer: store.state.currentEmployer);
    }, builder: (BuildContext context, CalculatorPageViewModel viewModel) {
      return FutureBuilder(
        future: _getCommission(viewModel),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              Map map = _getAllCommissionsData(snapshot);
              listCommissions = map['listCommissions'];
              totalCommission = map['totalCommission'];
              return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverPersistentHeader(
                          delegate: SliverTopBarDelegate(
                              TimeRangePickerView(
                                onPickEndDate: () => onPickEndDate(context),
                                onPickStartDate: () => onPickStartDate(context),
                                startDate: startDate,
                                endDate: endDate,
                              ),
                              viewModel: viewModel)),
                      SliverPersistentHeader(
                          pinned: true,
                          floating: false,
                          delegate: SliverResultDelegate(SmallCommissionsView(
                            numberColor: Colors.black,
                            //numberColor: Theme.of(context).primaryColorDark,
                            stringColor: Colors.black87,
                            commission: totalCommission,
                          ))),
                    ];
                  },
                  body: //Text('sample')
                  AllCommissionsView(listCommissions: listCommissions,
                  ));
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
