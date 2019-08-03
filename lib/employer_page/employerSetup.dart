import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import '../models/employer.dart';
import '../models/user.dart';
import 'add_new_employer_dialog.dart';
import 'employers_list_view.dart';

class EmployerSetup extends StatefulWidget {
  EmployerSetup({Key key, this.title, this.isInitialSetting, this.seenSetup})
      : super(key: key);
  final String title;
  final bool isInitialSetting;
  final VoidCallback seenSetup;

  @override
  _EmployerSetupState createState() => _EmployerSetupState();
}

class _EmployerSetupState extends State<EmployerSetup> {
  Future<Null> _openAddEmployerDialog() async {
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return AddEmployerView(title: "Add Employer");
            },
            fullscreenDialog: true));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      onPressed: _openAddEmployerDialog,
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
        floatingActionButton: NextButton(
          title: widget.title,
          isInitialSetting: widget.isInitialSetting,
          seenSetup: widget.seenSetup,
        ));
  }
}

class NextButton extends StatefulWidget {
  NextButton({Key key, this.isInitialSetting, this.title, this.seenSetup})
      : super(key: key);
  final String title;
  final bool isInitialSetting;
  final VoidCallback seenSetup;

  @override
  _NextButtonState createState() => _NextButtonState();
}

List<Employer> getListEmployersFromSnapshot(List<DocumentSnapshot> documents) {
  return documents.map((document) {
    return Employer(
        name: document.data['name'],
        commissionRate: document.data['commission_rate'],
        employerId: document.documentID);
  }).toList();
}

class _NextButtonState extends State<NextButton> {
  _saveEmployersAndGoNext() async {
    var user = Provider.of<UserModel>(context).user;
    var employersModel = Provider.of<EmployersModel>(context);

    String pathString = 'users/' + user.uid + '/employers';

    final QuerySnapshot result = await Firestore.instance
        .collection(pathString)
        .where('isDeleted', isEqualTo: false)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    Employer firstEmployer = Employer(
        name: documents[0].data['name'],
        commissionRate: documents[0].data['commission_rate'],
        employerId: documents[0].documentID);

    if (documents.length == 0) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Please add at least one employer"),
      ));
      return;
    }
    if(employersModel.currentEmployer==null){
      employersModel.choose(employer: firstEmployer);
    }
    if (widget.isInitialSetting) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('seen', true);
      widget.seenSetup();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _saveEmployersAndGoNext(),
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
    );
  }
}
