import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../models/employer.dart';
import 'add_new_employer_dialog.dart';
import 'package:Calmission/models/user.dart';
import 'delete_employer_dialog.dart';

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
              return AddEmployerView(title: "Edit Employer", employer: employer);
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

  selectEmployer(Employer employer) {
    var employers = Provider.of<EmployersModel>(context);
    employers.choose(employer: employer);
    if (widget.isDrawer) {
      Navigator.pop(context);
    }
  }

  Widget employerBuilder(BuildContext context, DocumentSnapshot document) {
    return Consumer<EmployersModel>(
      builder: (context, employers, child) {
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

        bool isCurrentEmployer = employers.currentEmployer != null
            ? employer.employerId == employers.currentEmployer.employerId
            : false;
        if (widget.isDrawer) {
          return Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: Colors.white,
            ),
            margin: EdgeInsets.fromLTRB(1.0, 6.0, 1.0, 6.0),
            child: ListTileTheme(
              selectedColor: Theme.of(context).textSelectionColor,
              child: ListTile(
                onTap: () => selectEmployer(employer),
                selected: isCurrentEmployer,
                leading: const Icon(Icons.store),
                subtitle:
                    Text((employer.commissionRate * 100).toString() + "%"),
                title: employersList,
              ),
            ),
          );
        }
        return Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
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
      },
    );
  }

  Stream<dynamic> _getEmployers(UserModel user) {
    if (user.user.uid != null) {
      String id = user.user.uid;
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

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, user, child) {
      return StreamBuilder(
          stream: _getEmployers(user),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            if (snapshot.data.documents.isEmpty) return Text('No Employer');
            /*List<Employer> employers =
                getListEmployersFromSnapshot(snapshot.data.documents);
            var employersModel = Provider.of<EmployersModel>(context);
            employersModel.load(employers);*/

            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot employerSnapshot =
                      snapshot.data.documents[index];
                  return employerBuilder(context, employerSnapshot);
                });
          });
    });
  }
}
