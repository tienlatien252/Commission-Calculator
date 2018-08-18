import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'models/commission.dart';
import 'models/employer.dart';
import 'logic/app_state.dart';
import 'edit_data_view.dart';

class _DayEditViewModel {
  _DayEditViewModel({this.currentUser, this.currentEmployer});

  final Employer currentEmployer;
  final FirebaseUser currentUser;
}

class CommissionView extends StatefulWidget {
  CommissionView({Key key, this.commission}) : super(key: key);
  final Commission commission;

  @override
  _CommissionViewState createState() => _CommissionViewState();
}

DateTime getDateOnly(DateTime dateAndTime) {
  return DateTime(dateAndTime.year, dateAndTime.month, dateAndTime.day);
}

class _CommissionViewState extends State<CommissionView> {
  @override
  Widget build(BuildContext context) {
    Commission commission = widget.commission;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'raw:',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Text("\$" + commission.raw.toString(),
                          style: TextStyle(fontSize: 20.0)))
                ],
              ),
              Column(
                children: <Widget>[
                  Text('commission:', style: TextStyle(fontSize: 20.0)),
                  Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Text("\$" + commission.commission.toString(),
                          style: TextStyle(fontSize: 20.0)))
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('tip:', style: TextStyle(fontSize: 20.0)),
                  Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Text("\$" + commission.tip.toString(),
                          style: TextStyle(fontSize: 20.0)))
                ],
              ),
              Column(
                children: <Widget>[
                  Text('total:', style: TextStyle(fontSize: 20.0)),
                  Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Text("\$" + commission.total.toString(),
                          style: TextStyle(fontSize: 20.0)))
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class DayEditView extends StatefulWidget {
  DayEditView(
      {Key key, this.date, this.commission, this.nextButton, this.backButton})
      : super(key: key);
  final DateTime date;
  final Commission commission;
  final Widget nextButton;
  final Widget backButton;

  @override
  _DayEditViewState createState() => _DayEditViewState();
}

class _DayEditViewState extends State<DayEditView> {
  Commission commission;

  Future _getCommission(_DayEditViewModel viewModel) {
    String id = viewModel.currentUser.uid;

    String pathString = 'users/' +
        id +
        '/employers/' +
        viewModel.currentEmployer.employerId +
        '/commission';

    DateTime dateOnly = getDateOnly(widget.date);
    return Firestore.instance
        .collection(pathString)
        .where('date', isEqualTo: dateOnly)
        .getDocuments();
  }

  Commission _getCommissionData(AsyncSnapshot snapshot) {
    if (snapshot.data.documents.length != 0) {
      Map<String, dynamic> retunredCommission = snapshot.data.documents[0].data;
      commission = Commission(
          raw: retunredCommission['raw'].toDouble(),
          commission: retunredCommission['commission'].toDouble(),
          tip: retunredCommission['tip'].toDouble(),
          total: retunredCommission['total'].toDouble(),
          id: snapshot.data.documents[0].documentID);

      return commission;
    }
    return Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);
  }

  Future<Null> _openEditCommissionDialog(Employer employer) async {
    // TODO implement the dialog
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return EditDataView(
            title: "Edit Comission",
            date: getDateOnly(widget.date),
            commission: commission,
          );
        });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _DayEditViewModel>(converter: (store) {
      return _DayEditViewModel(
          currentUser: store.state.currentUser,
          currentEmployer: store.state.currentEmployer);
    }, builder: (BuildContext context, _DayEditViewModel viewModel) {
      return FutureBuilder(
        future: _getCommission(viewModel),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              commission = _getCommissionData(snapshot);
              Widget dataAndButton = widget.backButton != null
                  ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        widget.backButton,
                        CommissionView(commission: commission),
                        widget.nextButton
                      ],
                    ))
                  : CommissionView(commission: commission);
              return Column(
                children: <Widget>[
                  dataAndButton,
                  Container(
                    alignment: AlignmentDirectional.bottomEnd,
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                    child: FloatingActionButton(
                        onPressed: () => _openEditCommissionDialog(null),
                        child: Icon(Icons.edit)),
                  )
                ],
              );
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return Text('Result: ${snapshot.data}');
          }
        },
      );
    });
  }
}
