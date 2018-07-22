import 'package:flutter/material.dart';
import 'dart:async';
import 'welcome_page.dart';
import 'home_page.dart';
import 'logic/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'Employer.dart';

class _EmployerViewModel {
  final Function(Employer) onAddNewEmployer;

  _EmployerViewModel({this.onAddNewEmployer});
}

class AddEmployerView extends StatefulWidget {
  AddEmployerView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddEmployerViewState createState() => new _AddEmployerViewState();
}

class _AddEmployerViewState extends State<AddEmployerView> {
  _saveNewEmployer(Function(Employer) callback) {
    if (_nameController.text.length != 0) {
      Employer newEmployer = Employer(
        name: _nameController.text, commissionRate: _comissionRate.round() / 100);
      callback(newEmployer);
    }

    Navigator.pop(context);
  }

  double _comissionRate = 60.0;
  void _onChange(double value) {
    setState(() {
      _comissionRate = value;
    });
  }

  final TextEditingController _nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      contentPadding: EdgeInsets.all(20.0),
      title: Text(widget.title),
      children: <Widget>[
        Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
              child: Column(
                children: <Widget>[
                  Text("Comission Rate is: " +
                      _comissionRate.round().toString() +
                      "%"),
                  Slider(
                      label: "Commission",
                      min: 0.0,
                      max: 100.0,
                      value: _comissionRate,
                      onChanged: (double value) {
                        _onChange(value);
                      })
                ],
              ),
            )
          ],
        ),
        StoreConnector<AppState, _EmployerViewModel>(
          converter: (store) {
            return new _EmployerViewModel(
              onAddNewEmployer: (employer) => store.dispatch(AddNewEmployerAction(employer))
            );
          },
          builder: (context, viewModel) {
            return RaisedButton(
            child: Text("Save"),
            onPressed: () {
              _saveNewEmployer(viewModel.onAddNewEmployer);
            }
          );
          }
        )
      ],
    );
  }
}
