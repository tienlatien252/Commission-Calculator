import 'package:flutter/material.dart';
import 'dart:async';
import 'welcome_page.dart';
import 'app_state/AppState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'Employer.dart';

class EmployersView {
  EmployersView({this.employers});
  final List<Employer> employers;
}

class EmployerSetup extends StatefulWidget {
  EmployerSetup({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EmployerSetupState createState() => new _EmployerSetupState();
}

class _EmployerSetupState extends State<EmployerSetup> {
  Future<WelcomePage> _saveEmployersAndGoNext() async {
    await FirebaseAuth.instance.signOut();
    return new WelcomePage();
  }

  Future<WelcomePage> _openAddEmployerDialog() async {
    // TODO implement the dialog
    print("Add new Employer");
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
            new EmployersListView(),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _saveEmployersAndGoNext,
        tooltip: 'go to home',
        child: new Text("Next"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class EmployersListView extends StatefulWidget {
  EmployersListView({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _EmployersListViewState createState() => new _EmployersListViewState();
}

class _EmployersListViewState extends State<EmployersListView> {
  deleteEmployer(int index) {
    print("object");
  }

  Widget employerBuilder(
      BuildContext context, List<Employer> employers, int index) {
    return new ExpansionTile(
        leading: const Icon(Icons.store),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(employers[index].name),
              IconButton(
                icon: new Icon(Icons.delete),
                onPressed: deleteEmployer(index),
              )
            ]),
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Comission Rate: "),
              Text(employers[index].commissionRate.toString()),
            ],
          )
        ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, List<Employer>>(converter: (store) {
      Employer employer1 =
          new Employer(name: "Star Nails", commissionRate: 0.6);
      Employer employer2 = new Employer(name: "Sun Nails", commissionRate: 0.7);
      return store.state.employers;
    }, builder: (context, employers) {
      if(employers != null){
              return ListView.builder(
          shrinkWrap: true,
          //padding: new EdgeInsets.all(15.0),
          //itemExtent: 20.0,
          itemCount: employers.length,
          itemBuilder: (BuildContext context, int index) {
            return employerBuilder(context, employers, index);
          });
      } else{
        return Text('empty');
      }
    });
  }
}
