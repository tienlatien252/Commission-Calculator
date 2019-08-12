import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../services/employer_service.dart';
import 'add_new_employer_dialog.dart';
import 'employers_list_view.dart';


class EmployerSetup extends StatelessWidget {
  EmployerSetup({Key key, this.title, this.isInitialSetting, this.seenSetup})
      : super(key: key);
  final String title;
  final bool isInitialSetting;
  final VoidCallback seenSetup;

  Future<Null> _openAddEmployerDialog(BuildContext context) async {
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return AddEmployerView(title: "Add Employer");
            },
            fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Employer\'s setup"),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 100.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: null,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.add),
                      onPressed: () => _openAddEmployerDialog(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: EmployersListView(
                  isDrawer: false,
                ),
              )
            ],
          ),
        ),
        floatingActionButton: NextButton(isInitialSetting: isInitialSetting));
  }
}

class NextButton extends StatelessWidget {
  NextButton({Key key, this.isInitialSetting})
      : super(key: key);
  final bool isInitialSetting;

  _saveEmployersAndGoNext(
      BuildContext context, EmployerService employerService) async {
    final List<Employer> employers = await employerService.getListEmployers();

    if (employers.length == 0) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Please add at least one employer"),
      ));
      return;
    }
    Employer currentEmployer = employerService.currentEmployer;
    if (currentEmployer == null) {
      employerService.setCurrentEmployer(employers[0]);
    }
    //if (employerService.seenSetup) {
    employerService.finishSetup(seen: true);
    // } else {
    if (!isInitialSetting){
      Navigator.pop(context);
    }
    // }
  }

  Future<bool> _willPop(
      BuildContext context, EmployerService employerService) async {
    final List<Employer> employerDocuments =
        await employerService.getListEmployers();

    if (employerDocuments.length == 0) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Please add at least one employer"),
      ));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    EmployerService employerService = Provider.of<EmployerService>(context);
    return WillPopScope(
        onWillPop: () => _willPop(context, employerService),
        child: InkWell(
          onTap: () => _saveEmployersAndGoNext(context, employerService),
          child: Container(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              margin: EdgeInsets.all(10.0),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                color: Theme.of(context).accentColor,
              ),
              child: Text(
                "Done",
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              )),
        ));
  }
}
