import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:async';

import '../logic/app_state.dart';
import '../models/employer.dart';

class _DeleteEmployerViewModel {
  final Function() onChangeEmployers;
  final FirebaseUser user;

  _DeleteEmployerViewModel({this.onChangeEmployers, this.user});
}

class DeleteEmployerDialogView extends StatefulWidget {
  DeleteEmployerDialogView({Key key, this.employer}) : super(key: key);
  final Employer employer;

  @override
  _DeleteEmployerDialogViewState createState() =>
      _DeleteEmployerDialogViewState();
}

class _DeleteEmployerDialogViewState extends State<DeleteEmployerDialogView> {
  _deleteEmployer(Function() callback, FirebaseUser user) async {
    String id = user.uid;
    String pathString = 'users/' + id + '/employers';
    Map<String, dynamic> data = {
          'name': widget.employer.name,
          'commission_rate': widget.employer.commissionRate,
          'isDeleted': true
    };
    Firestore.instance
        .collection(pathString)
        .document(widget.employer.employerId)
        .setData(data).whenComplete(() {
      callback();
    }).catchError((e) => print(e));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are You Sure?'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('All the employer\'s data will be deleted.'),
            Text('and will NOT be able to recover.'),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        StoreConnector<AppState, _DeleteEmployerViewModel>(converter: (store) {
          return _DeleteEmployerViewModel(
              onChangeEmployers: () => store.dispatch(InitEmployersAction(getCurrentEmployer: true)),
              user: store.state.currentUser);
        }, builder: (context, viewModel) {
          return FlatButton(
            textColor: Colors.red,
            child: Text('Yes'),
            onPressed: () => _deleteEmployer(viewModel.onChangeEmployers, viewModel.user)
          );
        }),
      ],
    );
  }
}
