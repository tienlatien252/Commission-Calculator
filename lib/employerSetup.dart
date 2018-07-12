import 'package:flutter/material.dart';
import 'dart:async';
import 'welcome_page.dart';
import 'AppState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';


class EmployersView{
  EmployersView({this.employers});
  final List<Employer> employers;
}

class Employer{
  const Employer({this.name, this.commissionRate});
  final String name;
  final double commissionRate;
}

class EmployerSetup extends StatefulWidget {
  EmployerSetup({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EmployerSetupState createState() => new _EmployerSetupState();
}

class _EmployerSetupState extends State<EmployerSetup> {

  Future <WelcomePage> _saveEmployersAndGoNext()  async{
    await FirebaseAuth.instance.signOut();
    return new WelcomePage();
  }

  Future <WelcomePage> _openAddEmployerDialog()  async{
    // TODO implement the dialog
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Center(
        child: new Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // new Container(
              //   height: 100.0,
              //   child: new Column(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: <Widget>[
              //       new Text('Employer\'s setup'),
              //       new RaisedButton(
              //         child: new Text('Add A New Employer'),
              //         onPressed: _openAddEmployerDialog,
              //       ),
              //     ],
              //   ),
              // ),
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

class EmployersListView extends StatefulWidget{
  EmployersListView ({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _EmployersListViewState createState() => new _EmployersListViewState();
}

class _EmployersListViewState extends State<EmployersListView> {

    @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, List<Employer>>(
      converter: (store)  {
        Employer employer = new Employer(name: "an", commissionRate: 1.2);
        return [employer];
      }, 
      builder: (context, employers) {
        return ListView(
          //shrinkWrap: true,

          children: employers.map( (employer) {
            return Text(employer.name);
          }).toList()
        );
      }
    );
  }
}