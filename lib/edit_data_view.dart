import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'dart:async';
import 'logic/app_state.dart';
import 'models/employer.dart';
import 'models/commission.dart';

class _EditDataViewModel {
  final FirebaseUser currentUser;
  final Employer currentEmployer;

  _EditDataViewModel({this.currentUser, this.currentEmployer});
}


class EditDataView extends StatefulWidget {
  EditDataView({Key key, this.title, this.date, this.commission}) : super(key: key);
  final String title;
  final DateTime date;
  final Commission commission;

  @override
  _EditDataViewState createState() => _EditDataViewState();
}

class _EditDataViewState extends State<EditDataView> {
  final _formKey = GlobalKey<FormState>();
  Commission _comissionData = Commission(raw: 0.0, tip: 0.0, commission: 0.0, total: 0.0);

  onPresscancel() {
    Navigator.pop(context);
  }

  void submit(_EditDataViewModel viewModel) {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      String id = viewModel.currentUser.uid;
      String employerId = viewModel.currentEmployer.employerId;
      String pathString = 'users/' + id + '/employers/' + employerId + '/commission';
      Map<String, dynamic> data = {
          'raw': _comissionData.raw,
          'tip': _comissionData.tip,
          'commission': _comissionData.commission,
          'total': _comissionData.total,
          'date': widget.date,
      };

      Future future;
      if (widget.commission.id == null) {
        future =  Firestore.instance.collection(pathString).document().setData(data);
      } else {
        future = Firestore.instance.collection(pathString).document(widget.commission.id).setData(data);
      }
      future.whenComplete(
        () {
          Navigator.pop(context);
        }
      );
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
    double initRaw = widget.commission.id != null ? widget.commission.raw : null;
    double initTip = widget.commission.id != null ? widget.commission.tip : null;

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
                      initialValue: initRaw.toString(),
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(labelText: 'Raw'),
                        validator: _validateNumber,
                        onSaved: (String value) {
                          _comissionData.raw = double.parse(value);
                          _comissionData.commission = (_comissionData.raw * viewModel.currentEmployer.commissionRate);
                          _comissionData.total += _comissionData.commission;
                        }),
                    TextFormField(
                        initialValue: initTip.toString(),
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(labelText: 'Tip'),
                        validator: _validateNumber,
                        onSaved: (String value) {
                          _comissionData.tip = double.parse(value);
                          _comissionData.total += _comissionData.tip;
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
                  onPressed: () => submit(viewModel),
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
