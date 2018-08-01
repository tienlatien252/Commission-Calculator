import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'dart:async';
import 'models/employer.dart';
import 'logic/app_state.dart';
import 'models/commission.dart';

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

class CommissionView extends StatefulWidget {
  CommissionView({Key key, this.commission}) : super(key: key);
  final Commission commission;

  @override
  _CommissionViewState createState() => new _CommissionViewState();
}

DateTime getDateOnly(DateTime dateAndTime) {
  return DateTime(dateAndTime.year, dateAndTime.month, dateAndTime.day);
}

class _CommissionViewState extends State<CommissionView> {

  @override
  Widget build(BuildContext context) {
    Commission commission = widget.commission;
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
}
