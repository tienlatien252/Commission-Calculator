import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../services/employer_service.dart';
import 'add_new_employer_dialog.dart';
import 'delete_employer_dialog.dart';

class EmployersListView extends StatelessWidget {
  EmployersListView({Key key, this.user, this.isDrawer}) : super(key: key);
  final FirebaseUser user;
  final bool isDrawer;

  Future<Null> _openEditEmployerDialog(
      BuildContext context, Employer employer) async {
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return AddEmployerView(
                  title: "Edit Employer", employer: employer);
            },
            fullscreenDialog: true));
  }

  Future<Null> _openDeleteEmployerDialog(
      BuildContext context, Employer employer) async {
    // TODO implement the dialog
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteEmployerDialogView(employer: employer);
        });
  }

  Future<Null> selectEmployer(BuildContext context, EmployerService employerService, Employer employer) async {
    await employerService.setCurrentEmployer(employer);
    if (isDrawer) {
      Navigator.pop(context);
    }
  }

  Widget employerBuilder(BuildContext context, EmployerService employerService,
      Employer employer, String currentEmployerID) {
    /*Employer employer = Employer(
        name: document.data['name'],
        commissionRate: document.data['commission_rate'],
        employerId: document.documentID);
*/
    Widget employersList;
    if (!isDrawer) {
      employersList = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(employer.name),
            Row(children: <Widget>[
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _openEditEmployerDialog(context, employer);
                  }),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _openDeleteEmployerDialog(context, employer);
                  })
            ])
          ]);
    } else {
      employersList = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text(employer.name)]);
    }

    bool isCurrentEmployer = employer.employerId == currentEmployerID;
    if (isDrawer) {
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
            onTap: () => selectEmployer(context, employerService, employer),
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
          onTap: () => selectEmployer(context, employerService, employer),
          selected: isCurrentEmployer,
          leading: const Icon(Icons.store),
          subtitle: Text((employer.commissionRate * 100).toString() + "%"),
          title: employersList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    EmployerService employerService = Provider.of<EmployerService>(context);
    return FutureBuilder<List<Employer>>(
        future: employerService.getListEmployers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data.isEmpty) return Text('No Employer');

          Employer currentEmployer = employerService.currentEmployer;

          String currentEmployerID = currentEmployer != null
              ? currentEmployer.employerId
              : snapshot.data[0].employerId;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Employer employer = snapshot.data[index];
                return employerBuilder(
                    context, employerService, employer, currentEmployerID);
              });
        });
  }
}
