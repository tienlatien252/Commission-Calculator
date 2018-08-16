import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'dart:async';
import 'logic/app_state.dart';
import 'models/employer.dart';

class _EditDataViewModel {
  final FirebaseUser currentUser;
  final Employer currentEmployer;

  _EditDataViewModel({this.currentUser, this.currentEmployer});
}

class _ComissionData {
  double raw;
  double commission;
  double tip;
  double total;
}

class EditDataView extends StatefulWidget {
  EditDataView({Key key, this.title, this.date}) : super(key: key);
  final String title;
  final DateTime date;
  @override
  _EditDataViewState createState() => _EditDataViewState();
}

class _EditDataViewState extends State<EditDataView> {
  final _formKey = GlobalKey<FormState>();
  _ComissionData _comissionData = _ComissionData();

  onPresscancel() {
    Navigator.pop(context);
  }

  void submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  String _validateNumber(String value) {
    try {
      double.parse(value);
    } catch (e) {
      return 'The field must be a number.';
    }
  
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _EditDataViewModel>(
      converter: (Store<AppState> store) {
        return _EditDataViewModel(
            currentEmployer: store.state.currentEmployer,
            currentUser: store.state.currentUser);
      },
      builder: (BuildContext context, _EditDataViewModel viewModel) {
        return SimpleDialog(
          title: Text(widget.title),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(labelText: 'Raw'),
                        validator: _validateNumber,
                        onSaved: (String value) {
                          _comissionData.raw = double.parse(value);
                        }),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(labelText: 'Tip'),
                        validator: _validateNumber,
                        onSaved: (String value) {
                          _comissionData.tip = double.parse(value);
                        }),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  onPressed: onPresscancel,
                  child: Text("Cancel"),
                ),
                RaisedButton(
                  onPressed: submit,
                  child: Text("Summit"),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
