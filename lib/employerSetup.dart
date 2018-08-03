import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux/redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'dart:async';
import 'home_page.dart';
import 'logic/app_state.dart';
import 'models/employer.dart';
import 'add_new_employer_dialog.dart';

class EmployerViewModel {
  EmployerViewModel(
      {this.employers, this.onGetCurrentEmployer, this.currentUser, this.onChangeEmployers});
  final List<Employer> employers;
  final Function() onGetCurrentEmployer;
  final FirebaseUser currentUser;
    final Function() onChangeEmployers;
}

class EmployerSetup extends StatefulWidget {
  EmployerSetup({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EmployerSetupState createState() => new _EmployerSetupState();
}

class _EmployerSetupState extends State<EmployerSetup> {
  Future<Null> _openAddEmployerDialog() async {
    // TODO implement the dialog
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AddEmployerView(title: "Add New Employer");
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Employer\'s setup"),
        ),
        body: Center(
          child: new Column(
            children: <Widget>[
              new Container(
                height: 100.0,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new RaisedButton(
                      child: new Text('Add A New Employer'),
                      onPressed: _openAddEmployerDialog,
                    ),
                  ],
                ),
              ),
              new Expanded(
                child: EmployersListView(),
              )
            ],
          ),
        ),
        floatingActionButton: new NextButton(title: widget.title));
  }
}

class EmployersListView extends StatefulWidget {
  EmployersListView({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _EmployersListViewState createState() => new _EmployersListViewState();
}

class _EmployersListViewState extends State<EmployersListView> {
  deleteEmployer(Employer employer) {
    print("object");
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

  Widget employerBuilder(
      BuildContext context, EmployerViewModel viewModel, int index) {
        List<Employer> employers = viewModel.employers;
    return new ExpansionTile(
      leading: const Icon(Icons.store),
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(employers[index].name),
            Text((employers[index].commissionRate * 100).toString() + "%"),
          ]),
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _openEditEmployerDialog(employers[index]);
                }),
            IconButton(
                icon: new Icon(Icons.delete),
                onPressed: () {
                  deleteEmployer(employers[index]);
                })
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, EmployerViewModel>(converter: (store) {
      return EmployerViewModel(
        employers: store.state.employers,
        currentUser: store.state.currentUser
      );
    }, builder: (context, viewModel) {
      if (viewModel.employers != null) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: viewModel.employers.length,
            itemBuilder: (BuildContext context, int index) {
              return employerBuilder(context, viewModel, index);
            });
      } else {
        return Text('No Employer');
      }
    });
  }
}

class NextButton extends StatefulWidget {
  NextButton({Key key, this.user, this.title}) : super(key: key);
  final FirebaseUser user;
  final String title;

  @override
  _NextButtonState createState() => new _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  _saveEmployersAndGoNext(EmployerViewModel viewModel) {
    if (viewModel.employers == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Please add at least one employer"),
          ));
      return;
    }
    viewModel.onGetCurrentEmployer();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(title: widget.title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EmployerViewModel>(converter: (store) {
      return EmployerViewModel(
          onGetCurrentEmployer: () => store.dispatch(
              new ChangeCurrentEmployerAction(store.state.employers[0])),
          employers: store.state.employers,
          currentUser: store.state.currentUser);
    }, builder: (BuildContext context, EmployerViewModel viewModel) {
      return new RaisedButton(
        onPressed: () => _saveEmployersAndGoNext(viewModel),
        child: new Text("Next"),
      );
    }); // This trailing c
  }
}
