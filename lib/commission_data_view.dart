import 'package:flutter/material.dart';
import 'dart:async';
import 'Employer.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'logic/middleware.dart';
import 'logic/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class _CommisionViewModel {
  _CommisionViewModel(
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

class _Comission {
  _Comission({this.raw, this.commission, this.tip, this.total});
  final double raw;
  final double commission;
  final double tip;
  final double total;
}

class ComissionView extends StatefulWidget {
  ComissionView({Key key, this.date}) : super(key: key);
  final DateTime date;

  @override
  _ComissionViewState createState() => new _ComissionViewState();
}

DateTime getDateOnly(DateTime dateAndTime) {
  return DateTime(dateAndTime.year, dateAndTime.month, dateAndTime.day);
}

class _ComissionViewState extends State<ComissionView> {
  Future _getCommission(_CommisionViewModel viewModel) {
    String id = viewModel.currentUser.uid;
    String pathString = 'users/' +
        id +
        '/employers/' +
        viewModel.currentEmployer.employerId +
        '/commission';
    return Firestore.instance
        .collection(pathString)
        .where('date', isEqualTo: getDateOnly(widget.date))
        .getDocuments();
  }

  Widget _getCommissionWidget(AsyncSnapshot snapshot) {
     _Comission commission =
              _Comission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);
    if (snapshot.data.documents.length != 0) {
      Map<String, dynamic> retunredCommission = snapshot.data.documents[0].data;
      commission =_Comission(
        raw: retunredCommission['raw'].toDouble(), 
        commission: retunredCommission['commission'].toDouble(),
        tip: retunredCommission['tip'].toDouble(), 
        total: retunredCommission['total'].toDouble()
      );
    }
    return new Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('raw: ' + commission.raw.toString()),
              Text('commission: ' + commission.commission.toString())
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('tip: ' + commission.tip.toString()),
              Text('total: ' + commission.total.toString())
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _CommisionViewModel>(converter: (store) {
      return _CommisionViewModel(
          currentUser: store.state.currentUser,
          currentEmployer: store.state.currentEmployer);
    }, builder: (BuildContext context, _CommisionViewModel viewModel) {
      return FutureBuilder(
        future: _getCommission(viewModel),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return _getCommissionWidget(snapshot);
            case ConnectionState.waiting:
              return new CircularProgressIndicator();
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return new Text('Result: ${snapshot.data}');
          }
        },
      );
    });
  }
}
