import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'dart:async';
import '../logic/app_state.dart';
import '../models/employer.dart';
import 'add_new_employer_dialog.dart';
import 'delete_employer_dialog.dart';

class _EmployersViewModel {
  _EmployersViewModel(
      {this.employers,
      this.onGetCurrentEmployer,
      this.currentUser,
      this.onGetEmployers,
      this.currentEmployer});
  final List<Employer> employers;
  final Employer currentEmployer;
  final Function(Employer) onGetCurrentEmployer;
  final Function(List<Employer>) onGetEmployers;
  final FirebaseUser currentUser;
}

class EmployersListView extends StatefulWidget {
  EmployersListView({Key key, this.user, this.isDrawer}) : super(key: key);
  final FirebaseUser user;
  final bool isDrawer;

  @override
  _EmployersListViewState createState() => _EmployersListViewState();
}

class _EmployersListViewState extends State<EmployersListView> {
  Future<Null> _openEditEmployerDialog(Employer employer) async {
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return AddEmployerView(
                  title: "Edit Employer", employer: employer);
            },
            fullscreenDialog: true));

    setState(() {});
  }

  Future<Null> _openDeleteEmployerDialog(Employer employer) async {
    // TODO implement the dialog
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteEmployerDialogView(employer: employer);
        });
  }

  selectEmployer(_EmployersViewModel viewModel, Employer employer) {
    viewModel.onGetCurrentEmployer(employer);
    if (widget.isDrawer) {
      Navigator.pop(context);
    }
  }

  Widget employerBuilder(BuildContext context, DocumentSnapshot document,
      _EmployersViewModel viewModel) {
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

    bool isCurrentEmployer = viewModel.currentEmployer != null
        ? employer.employerId == viewModel.currentEmployer.employerId
        : false;
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
            onTap: () => selectEmployer(viewModel, employer),
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
          onTap: () => selectEmployer(viewModel, employer),
          selected: isCurrentEmployer,
          leading: const Icon(Icons.store),
          subtitle: Text((employer.commissionRate * 100).toString() + "%"),
          title: employersList,
        ),
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
    return StoreConnector<AppState, _EmployersViewModel>(converter: (store) {
      return _EmployersViewModel(
          employers: store.state.employers,
          currentUser: store.state.currentUser,
          currentEmployer: store.state.currentEmployer,
          onGetCurrentEmployer: (Employer employer) =>
              store.dispatch(new ChangeCurrentEmployerAction(employer)),
          onGetEmployers: (List<Employer> employers) =>
              store.dispatch(new GetEmployersAction(employers)));
    }, builder: (context, viewModel) {
      return StreamBuilder(
          stream: _getEmployers(viewModel),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            if (snapshot.data.documents.isEmpty) return Text('No Employer');
            //List<Employer> employers = getListEmployersFromSnapshot(snapshot.data.documents);
            //viewModel.onGetEmployers(employers);
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot employerSnapshot =
                      snapshot.data.documents[index];
                  return employerBuilder(context, employerSnapshot, viewModel);
                });
          });
    });
  }
}
