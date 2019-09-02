import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../services/employer_service.dart';
import 'add_new_employer_dialog.dart';
import 'employers_list_view.dart';
import 'package:Calmission/common_widgets/CustomButton.dart';

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
          title: Text(
            "Employer\'s setup",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 100.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CustomTextButton(onTap: () => _openAddEmployerDialog(context), label: "Add",),
                    /*FloatingActionButton(
                      heroTag: null,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.add),
                      onPressed: () => _openAddEmployerDialog(context),
                    ),*/
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
  NextButton({Key key, this.isInitialSetting}) : super(key: key);
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
    employerService.finishSetup(seen: true);
    if (!isInitialSetting) {
      Navigator.pop(context);
    }
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
        child: CustomTextButton(
          onTap: () => _saveEmployersAndGoNext(context, employerService),
          label: "Done",
          alignment: AlignmentDirectional.bottomEnd,
        ));
  }
}
