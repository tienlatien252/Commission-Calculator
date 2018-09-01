import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import '../logic/app_state.dart';
import '../models/employer.dart';
import 'add_new_employer_dialog.dart';
import 'employers_list_view.dart';

class _EmployersViewModel {
  _EmployersViewModel(
      {this.employers,
      this.onGetCurrentEmployer,
      this.currentUser,
      this.onGetEmployers,
      this.currentEmployer});
  final List<Employer> employers;
  final Employer currentEmployer;
  final Function() onGetCurrentEmployer;
  final Function(List<Employer>) onGetEmployers;
  final FirebaseUser currentUser;
}

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
                      child: Icon(Icons.add),
                      onPressed: _openAddEmployerDialog,
                    ),
                    // InkWell(
                    //   onTap: _openAddEmployerDialog,
                    //   child: Container(
                    //       padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                    //       margin: EdgeInsets.all(10.0),
                    //       decoration: ShapeDecoration(
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(10.0)),
                    //         color: Theme
                    //             .of(context)
                    //             .primaryColorDark
                    //             .withAlpha(100),
                    //       ),
                    //       child: Text(
                    //         "Add A New Employer",
                    //         style:
                    //             TextStyle(fontSize: 20.0, color: Colors.white),
                    //       )),
                    // ),
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

class _NextButtonState extends State<NextButton> {
  _saveEmployersAndGoNext(_EmployersViewModel viewModel) async {
    if (viewModel.employers == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Please add at least one employer"),
          ));
      return;
    }
    if (viewModel.currentEmployer == null) {
      viewModel.onGetCurrentEmployer();
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
    return StoreConnector<AppState, _EmployersViewModel>(converter: (store) {
      return _EmployersViewModel(
          onGetCurrentEmployer: () => store
              .dispatch(ChangeCurrentEmployerAction(store.state.employers[0])),
          employers: store.state.employers,
          currentEmployer: store.state.currentEmployer,
          currentUser: store.state.currentUser);
    }, builder: (BuildContext context, _EmployersViewModel viewModel) {
      return InkWell(
        onTap: () => _saveEmployersAndGoNext(viewModel),
        child: Container(
            padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
            margin: EdgeInsets.all(10.0),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: Theme.of(context).primaryColorDark,
            ),
            child: Text(
              "Done",
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            )),
      );
    }); // This trailing c
  }
}
