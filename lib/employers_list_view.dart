import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'dart:async';
import 'logic/app_state.dart';
import 'models/employer.dart';
import 'add_new_employer_dialog.dart';

class _EmployersViewModel {
  _EmployersViewModel(
      {this.employers,
      this.onGetCurrentEmployer,
      this.currentUser,
      this.onGetEmployers});
  final List<Employer> employers;
  final Function() onGetCurrentEmployer;
  final Function(List<Employer>) onGetEmployers;
  final FirebaseUser currentUser;
}

class EmployersListView extends StatefulWidget {
  EmployersListView({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _EmployersListViewState createState() => new _EmployersListViewState();
}

class _EmployersListViewState extends State<EmployersListView> {
  deleteEmployer(Employer employer) {
    print("delete");
  }

  Future<Null> _openEditEmployerDialog(Employer employer) async {
    // TODO implement the dialog
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AddEmployerView(
              title: "Edit Employer", employer: employer);
        });
  }

  Widget employerBuilder(BuildContext context, DocumentSnapshot document) {
    Employer employer = Employer(
        name: document.data['name'],
        commissionRate: document.data['commission_rate'],
        employerId: document.documentID);
    return Card(
      child: Column(
        children: <Widget>[
          new ListTile(
            leading: const Icon(Icons.store),
            subtitle: Text((employer.commissionRate * 100).toString() + "%"),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(employer.name),
                  Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _openEditEmployerDialog(employer);
                          }),
                      IconButton(
                          icon: new Icon(Icons.delete),
                          onPressed: () {
                            deleteEmployer(employer);
                          })
                    ],
                  ),
                ]),
            // children: <Widget>[
            //   new Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: <Widget>[
            //       IconButton(
            //           icon: Icon(Icons.edit),
            //           onPressed: () {
            //             _openEditEmployerDialog(employer);
            //           }),
            //       IconButton(
            //           icon: new Icon(Icons.delete),
            //           onPressed: () {
            //             deleteEmployer(employer);
            //           })
            //     ],
            //   )
            // ],
          ),
        ],
      ),
    );
  }

  Stream<dynamic> _getEmployers(_EmployersViewModel viewModel) {
    if (viewModel.currentUser != null) {
      String id = viewModel.currentUser.uid;
      String pathString = 'users/' + id + '/employers';
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
    return new StoreConnector<AppState, _EmployersViewModel>(
        converter: (store) {
      return _EmployersViewModel(
          employers: store.state.employers,
          currentUser: store.state.currentUser,
          onGetEmployers: (List<Employer> employers) =>
              store.dispatch(new GetEmployersAction(employers)));
    }, builder: (context, viewModel) {
      return StreamBuilder(
          stream: _getEmployers(viewModel),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: new CircularProgressIndicator());
            if (snapshot.data.documents.isEmpty) return Text('No Employer');
            //List<Employer> employers = getListEmployersFromSnapshot(snapshot.data.documents);
            //viewModel.onGetEmployers(employers);
            return new ListView.builder(
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
