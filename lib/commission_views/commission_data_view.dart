import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import '../models/commission.dart';
import 'edit_data_dialog.dart';
import 'package:Calmission/common/employer_service.dart';
import 'package:Calmission/services/employer_service.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class CommissionView extends StatefulWidget {
  CommissionView(
      {Key key,
      @required this.commission,
      this.stringFontSize,
      this.numberFontSize})
      : super(key: key);
  final Commission commission;
  final double stringFontSize;
  final double numberFontSize;

  @override
  _CommissionViewState createState() => _CommissionViewState();
}

DateTime getDateOnly(DateTime dateAndTime) {
  return DateTime(dateAndTime.year, dateAndTime.month, dateAndTime.day);
}

class _CommissionViewState extends State<CommissionView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double numberFontSize =
        widget.numberFontSize != null ? widget.numberFontSize : 40.0;
    double stringFontSize =
        widget.stringFontSize != null ? widget.stringFontSize : 25.0;
    Commission commission = widget.commission;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Raw',
                          style: TextStyle(
                              fontSize: stringFontSize, color: Colors.black54),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: Text("\$" + commission.raw.toStringAsFixed(2),
                              style: TextStyle(fontSize: numberFontSize)))
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    children: <Widget>[
                      Text('Commission',
                          style: TextStyle(
                              fontSize: stringFontSize, color: Colors.black54)),
                      Container(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: Text(
                            "\$" + commission.commission.toStringAsFixed(2),
                            style: TextStyle(fontSize: numberFontSize),
                            //maxLines: 2,
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    children: <Widget>[
                      Text('Tip',
                          style: TextStyle(
                              fontSize: stringFontSize, color: Colors.black54)),
                      Container(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: Text("\$" + commission.tip.toStringAsFixed(2),
                              style: TextStyle(fontSize: numberFontSize)))
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    children: <Widget>[
                      Text('Total',
                          style: TextStyle(
                              fontSize: stringFontSize, color: Colors.black54)),
                      Container(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: Text(
                              "\$" + commission.total.toStringAsFixed(2),
                              style: TextStyle(fontSize: numberFontSize)))
                    ],
                  ),
                ),
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

  Future _getCommission() async {
    FirebaseUser _currentUser = await _auth.currentUser();
    Employer currentEmployer = await getCurrentEmployer();
    String currentEmployerId = currentEmployer != null ? currentEmployer.employerId : 'abc';
    String pathString = 'users/' +
        _currentUser.uid +
        '/employers/' +
        currentEmployerId +
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

  Future<Null> _openEditCommissionDialog() async {
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return EditDataView(
                title: "Edit Comission",
                date: getDateOnly(widget.date),
                commission: commission,
              );
            },
            fullscreenDialog: true));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCommission(),
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
                      heroTag: null,
                      onPressed: () => _openEditCommissionDialog(),
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
  }
}
