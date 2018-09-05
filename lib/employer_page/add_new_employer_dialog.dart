import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:numberpicker/numberpicker.dart';

import 'dart:async';
import '../logic/app_state.dart';
import '../models/employer.dart';

class _AddNewEmployerViewModel {
  final Function() onChangeEmployers;
  final FirebaseUser user;

  _AddNewEmployerViewModel({this.onChangeEmployers, this.user});
}

class AddEmployerView extends StatefulWidget {
  AddEmployerView({Key key, this.title, this.employer}) : super(key: key);
  final String title;
  final Employer employer;

  @override
  _AddEmployerViewState createState() => _AddEmployerViewState();
}

class _AddEmployerViewState extends State<AddEmployerView> {
  double _comissionRate = 60.0;
  String employerName = "";

  final _formKey = GlobalKey<FormState>();

  _saveNewEmployer(Function() callback, FirebaseUser user) async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      String id = user.uid;
      String pathString = 'users/' + id + '/employers';
      Map<String, dynamic> data = {
        'name': employerName,
        'commission_rate': _comissionRate.round() / 100,
        'isDeleted': false
      };
      Future future;
      if (widget.employer == null) {
        future =
            Firestore.instance.collection(pathString).document().setData(data);
      } else {
        future = Firestore.instance
            .collection(pathString)
            .document(widget.employer.employerId)
            .setData(data);
      }

      future.whenComplete(() {
        FocusScope.of(context).detach();
        callback();
        Navigator.pop(context);
      }).catchError((e) => print(e));
    }
  }

  @override
  void initState() {
    super.initState();
    _comissionRate = widget.employer != null
        ? widget.employer.commissionRate * 100
        : _comissionRate;
  }

  onPresscancel() {
    FocusScope.of(context).detach();
    Navigator.pop(context);
  }

  String _validateNameString(String value) {
    if (value.length == 0) {
      return 'The name field must not be empty';
    }
    return null;
  }

  _showRatePicker(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.decimal(
            minValue: 1,
            maxValue: 100,
            initialDoubleValue: _comissionRate,
            title: new Text("Enter Commmission Rate"),
          );
        }).then((value) {
      if (value != null) {
        setState(() => _comissionRate = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String initName = widget.employer != null ? widget.employer.name : "";
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.store_mall_directory),
                  title: Form(
                    key: _formKey,
                    child: TextFormField(
                        autofocus: true,
                        style: TextStyle(fontSize: 25.0, color: Colors.black),
                        initialValue: initName,
                        decoration: new InputDecoration(labelText: 'Name'),
                        validator: _validateNameString,
                        onSaved: (String value) {
                          employerName = value;
                        }),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                ListTile(
                    leading: Icon(Icons.check_circle_outline),
                    title: Text("Commission Rate",
                        style:
                            TextStyle(fontSize: 25.0, color: Colors.black54)),
                    trailing: new Text(
                      "$_comissionRate %",
                      style: TextStyle(fontSize: 25.0, color: Colors.black),
                    ),
                    onTap: () => _showRatePicker(context))
              ],
            )),
        floatingActionButton:
            StoreConnector<AppState, _AddNewEmployerViewModel>(
                converter: (store) {
          return _AddNewEmployerViewModel(
              onChangeEmployers: () => store
                  .dispatch(InitEmployersAction(getCurrentEmployer: false)),
              user: store.state.currentUser);
        }, builder: (context, viewModel) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                onTap: onPresscancel,
                child: Container(
                    padding: EdgeInsets.all(15.0),
                    margin: EdgeInsets.all(10.0),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      color: Theme.of(context).accentColor.withAlpha(100),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    )),
              ),
              InkWell(
                onTap: () {
                  _saveNewEmployer(viewModel.onChangeEmployers, viewModel.user);
                },
                child: Container(
                    padding: EdgeInsets.all(15.0),
                    margin: EdgeInsets.all(10.0),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      color: Theme.of(context).accentColor,
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    )),
              ),
            ],
          );
        }));
  }
}
