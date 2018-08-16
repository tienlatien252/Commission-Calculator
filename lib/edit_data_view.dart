import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'dart:async';
import 'logic/app_state.dart';
import 'models/employer.dart';

class _EditDataViewModel {
  final FirebaseUser currentUser;
  final Employer currentEmployer;

  _EditDataViewModel({this.currentUser, this.currentEmployer});
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

  // _saveNewEmployer(Function() callback, FirebaseUser user) async {
  //   if (_nameController.text.length != 0) {
  //     String id = user.uid;
  //     String pathString = 'users/' + id + '/employers';
  //     Map<String, dynamic> data = {
  //         'name': _nameController.text,
  //         'commission_rate': _comissionRate.round() / 100,
  //         'isDeleted': false
  //     };
  //     Future future;
  //     if (widget.employer == null) {
  //       future =  Firestore.instance.collection(pathString).document().setData(data);
  //     } else {
  //       future = Firestore.instance.collection(pathString).document(widget.employer.employerId).setData(data);
  //     }

  //     future.whenComplete((){
  //       callback();
  //     }).catchError((e) => print(e));
  //   }

  //   Navigator.pop(context);
  // }


  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title),
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
          children: <Widget>[
            TextFormField()
          ],
        ),)
      ],
    );
  }
}
