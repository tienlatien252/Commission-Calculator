import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../models/employer.dart';
import 'add_new_employer_dialog.dart';
import 'delete_employer_dialog.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class EmployersListView extends StatefulWidget {
  EmployersListView({Key key, this.user, this.isDrawer}) : super(key: key);
  final FirebaseUser user;
  final bool isDrawer;

  @override
  _EmployersListViewState createState() => _EmployersListViewState();
}

class _EmployersListViewState extends State<EmployersListView> {
  @override
  void initState() {
    super.initState();
  }

  Future<Null> _openEditEmployerDialog(Employer employer) async {
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return AddEmployerView(
                  title: "Edit Employer", employer: employer);
            },
            fullscreenDialog: true));
  }

  Future<Null> _openDeleteEmployerDialog(Employer employer) async {
    // TODO implement the dialog
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteEmployerDialogView(employer: employer);
        });
  }

  Future<Null> selectEmployer(Employer employer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentEmployer', employer.employerId);
    if (widget.isDrawer) {
      Navigator.pop(context);
    }
    else{
      setState(() {});
    }
  }

  Widget employerBuilder(
      BuildContext context, DocumentSnapshot document, String employerId) {
    Employer employer = Employer(
        name: document.data['name'],
        commissionRate: document.data['commission_rate'],
        employerId: document.documentID);

    Widget employersList;
    if (!widget.isDrawer) {
      employersList = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(employer.name),
            Row(children: <Widget>[
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _openEditEmployerDialog(employer);
                  }),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _openDeleteEmployerDialog(employer);
                  })
            ])
          ]);
    } else {
      employersList = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text(employer.name)]);
    }

    bool isCurrentEmployer =
        employerId != null ? employer.employerId == employerId : false;
    if (widget.isDrawer) {
      return Container(
        decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.white,
        ),
        margin: EdgeInsets.fromLTRB(1.0, 6.0, 1.0, 6.0),
        child: ListTileTheme(
          selectedColor: Theme.of(context).textSelectionColor,
          child: ListTile(
            onTap: () => selectEmployer(employer),
            selected: isCurrentEmployer,
            leading: const Icon(Icons.store),
            subtitle: Text((employer.commissionRate * 100).toString() + "%"),
            title: employersList,
          ),
        ),
      );
    }
    return Container(
      decoration: ShapeDecoration(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.white,
      ),
      margin: EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 6.0),
      child: ListTileTheme(
        selectedColor: Theme.of(context).textSelectionColor,
        child: ListTile(
          onTap: () => selectEmployer(employer),
          selected: isCurrentEmployer,
          leading: const Icon(Icons.store),
          subtitle: Text((employer.commissionRate * 100).toString() + "%"),
          title: employersList,
        ),
      ),
    );
  }

  Stream<dynamic> _getEmployers(FirebaseUser currentUser) {
    if (currentUser.uid != null) {
      String id = currentUser.uid;
      String pathString = 'users/' + id + '/employers';
      print(pathString);
      Stream<dynamic> stream = Firestore.instance
          .collection(pathString)
          .where('isDeleted', isEqualTo: false)
          .snapshots();
      return stream;
    }
    return null;
  }

  List<Employer> getListEmployersFromSnapshot(
      List<DocumentSnapshot> documents) {
    return documents.map((document) {
      return Employer(
          name: document.data['name'],
          commissionRate: document.data['commission_rate'],
          employerId: document.documentID);
    }).toList();
  }

  Future<String> getCurrentEmployer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentEmployer');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              FirebaseUser currentUser = snapshot.data;
              return StreamBuilder(
                  stream: _getEmployers(currentUser),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());
                    if (snapshot.data.documents.isEmpty)
                      return Text('No Employer');

                    return FutureBuilder<String>(
                      future: getCurrentEmployer(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> currentEmployerSnapshot) {
                        String employerID = currentEmployerSnapshot.hasData
                            ? currentEmployerSnapshot.data
                            : snapshot.data.documents[0].documentID;
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot employerSnapshot =
                                  snapshot.data.documents[index];
                              return employerBuilder(
                                  context, employerSnapshot, employerID);
                            });
                      },
                    );
                  });
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return Text('Result: ${snapshot.data}');
          }
        });
  }
}
