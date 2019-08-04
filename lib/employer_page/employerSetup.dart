import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import '../models/employer.dart';
import 'add_new_employer_dialog.dart';
import 'employers_list_view.dart';
import 'package:Calmission/common/employer_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<bool> willPop() async {
    final List<DocumentSnapshot> employerDocuments =
        await getEmployersDocument();

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
    return new Scaffold(
        appBar: AppBar(
          title: Text("Employer\'s setup"),
          backgroundColor: Colors.white,
        ),
        body:  Center(
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

Future<List<DocumentSnapshot>> getEmployersDocument() async {
  FirebaseUser _currentUser = await _auth.currentUser();
  String pathString = 'users/' + _currentUser.uid + '/employers';
  final QuerySnapshot result = await Firestore.instance
      .collection(pathString)
      .where('isDeleted', isEqualTo: false)
      .getDocuments();
  return result.documents;
}

class _NextButtonState extends State<NextButton> {
  _saveEmployersAndGoNext() async {
    final List<DocumentSnapshot> employerDocuments =
        await getEmployersDocument();

    if (employerDocuments.length == 0) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Please add at least one employer"),
      ));
      return;
    }
    Employer currentEmployer = await getCurrentEmployer();
    if (currentEmployer == null) {
      Employer employer = Employer(
          name: employerDocuments[0]['name'],
          commissionRate: employerDocuments[0]['commission_rate'],
          employerId: employerDocuments[0].documentID);
      await setCurrentEmployer(employer);
    }
    if (widget.isInitialSetting) {
      await seenFirstSetup(seen: true);
      widget.seenSetup();
    } else {
      Navigator.pop(context);
    }
  }

  Future<bool> willPop() async {
    final List<DocumentSnapshot> employerDocuments =
        await getEmployersDocument();

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
    return new WillPopScope(
            onWillPop: () => willPop(),
            child:InkWell(
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
    ));
  }
}
