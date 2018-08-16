import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'models/employer.dart';
import 'logic/app_state.dart';
import 'commission_data_view.dart';
import 'models/commission.dart';


class _TodayViewModel {
  _TodayViewModel(
      {this.employers,
      this.onGetCurrentEmployer,
      this.currentUser,
      this.onLogout,
      this.currentEmployer});
  final List<Employer> employers;
  final Employer currentEmployer;
  final Function() onGetCurrentEmployer;
  final FirebaseUser currentUser;
  final Function() onLogout;
}

class TodayView extends StatefulWidget {
  TodayView({Key key}) : super(key: key);

  @override
  _TodayViewState createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  final DateTime date = DateTime.now();

  Future _getCommission(_TodayViewModel viewModel) {
    String id = viewModel.currentUser.uid;
    if (viewModel.currentEmployer == null){
      viewModel.onGetCurrentEmployer();
    }

    String pathString = 'users/' +
        id +
        '/employers/' +
        viewModel.currentEmployer.employerId +
        '/commission';
    return Firestore.instance
        .collection(pathString)
        .where('date', isEqualTo: getDateOnly(date))
        .getDocuments();
  }

  DateTime getDateOnly(DateTime dateAndTime) {
    return DateTime(dateAndTime.year, dateAndTime.month, dateAndTime.day);
  }

  Commission _getCommissionData(AsyncSnapshot snapshot) {
    Commission commission =
        Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);
    if (snapshot.data.documents.length != 0) {
      Map<String, dynamic> retunredCommission = snapshot.data.documents[0].data;
      commission = Commission(
          raw: retunredCommission['raw'].toDouble(),
          commission: retunredCommission['commission'].toDouble(),
          tip: retunredCommission['tip'].toDouble(),
          total: retunredCommission['total'].toDouble());
    }
    return commission;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _TodayViewModel>(converter: (store) {
      return _TodayViewModel(
          currentUser: store.state.currentUser,
          currentEmployer: store.state.currentEmployer,
          onGetCurrentEmployer: () => store.dispatch(ChangeCurrentEmployerAction(store.state.employers[0])));
    }, builder: (BuildContext context, _TodayViewModel viewModel) {
      return FutureBuilder(
        future: _getCommission(viewModel),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return CommissionView(commission: _getCommissionData(snapshot));
            case ConnectionState.waiting:
              return Center (child:CircularProgressIndicator());
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
