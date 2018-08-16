import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'dart:async';
import 'logic/app_state.dart';
import 'models/employer.dart';

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
  _saveNewEmployer(Function() callback, FirebaseUser user) async {
    if (_nameController.text.length != 0) {
      String id = user.uid;
      String pathString = 'users/' + id + '/employers';
      Map<String, dynamic> data = {
          'name': _nameController.text,
          'commission_rate': _comissionRate.round() / 100,
          'isDeleted': false
      };
      Future future;
      if (widget.employer == null) {
        future =  Firestore.instance.collection(pathString).document().setData(data);
      } else {
        future = Firestore.instance.collection(pathString).document(widget.employer.employerId).setData(data);
      }

      future.whenComplete((){
        callback();
      }).catchError((e) => print(e));
    }

    Navigator.pop(context);
  }

  double _comissionRate = 60.0;
  void _onChange(double value) {
    setState(() {
      _comissionRate = value;
    });
  }

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _comissionRate = widget.employer != null
        ? widget.employer.commissionRate * 100
        : _comissionRate;

    _nameController.text= widget.employer != null ? widget.employer.name : null;
  }

  @override
  Widget build(BuildContext context) {

    return SimpleDialog(
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
        StoreConnector<AppState, _AddNewEmployerViewModel>(converter: (store) {
          return _AddNewEmployerViewModel(
              onChangeEmployers: () => store.dispatch(InitEmployersAction()),
              user: store.state.currentUser);
        }, builder: (context, viewModel) {
          return RaisedButton(
              child: Text("Save"),
              onPressed: () {
                _saveNewEmployer(viewModel.onChangeEmployers, viewModel.user);
              });
        })
      ],
    );
  }
}
