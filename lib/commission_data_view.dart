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

DateTime getDateOnly (DateTime dateAndTime){
  return DateTime( dateAndTime.year, dateAndTime.month, dateAndTime.day);
}

class _ComissionViewState extends State<ComissionView> {
  _Comission commission =
      _Comission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);

  void _getCommission(_CommisionViewModel viewModel) {
    String id = viewModel.currentUser.uid;
    String pathString = 'users/' +
        id +
        '/employers/' +
        viewModel.currentEmployer.employerId +
        '/commission';
    Firestore.instance
        .collection(pathString)
        .where('date', isEqualTo: getDateOnly(widget.date))
        .getDocuments()
        .then((stream) {
      if (stream.documents.length != 0) {
        
        Map<String, dynamic> data = stream.documents[0].data;
        setState(() {
          commission = _Comission(
              raw: data['raw'].toDouble(),
              commission: data['commission'].toDouble(),
              tip: data['tip'].toDouble(),
              total: data['total'].toDouble());
        });
      } else {
        Firestore.instance
        .collection(pathString).document().setData({
            'raw': 200,
            'commission': 140,
            'tip': 40,
            'total': 180,
            'day': getDateOnly(DateTime.now())
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _CommisionViewModel>(
      converter: (store) {
        return _CommisionViewModel(
            currentUser: store.state.currentUser,
            currentEmployer: store.state.currentEmployer);
      },
      builder: (BuildContext context, _CommisionViewModel viewModel) {
        _getCommission(viewModel);
        return new Card(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('commission: ' + commission.commission.toString())
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
