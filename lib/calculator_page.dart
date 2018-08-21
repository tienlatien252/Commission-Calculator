import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'models/employer.dart';
import 'logic/app_state.dart';
import 'commission_data_view.dart';
import 'models/commission.dart';
import 'date_time_view.dart';

class __CalculatorPageViewModel {
  __CalculatorPageViewModel({this.currentUser, this.currentEmployer});

  final FirebaseUser currentUser;
  final Employer currentEmployer;
}

class CalculatorPage extends StatefulWidget {
  CalculatorPage({Key key}) : super(key: key);
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  Commission commission =
      Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);

  Future<Null> onPickStartDate(BuildContext context) async {
    final datePicked = await showDatePicker(
        context: context,
        initialDate: startDate,
        lastDate: DateTime.now(),
        firstDate: DateTime(startDate.year - 5));

    if (datePicked != null && datePicked != startDate) {
      setState(() {
        startDate = datePicked;
      });
    }
  }

  Future<Null> onPickEndDate(BuildContext context) async {
    final datePicked = await showDatePicker(
        context: context,
        initialDate: endDate,
        lastDate: DateTime.now(),
        firstDate: DateTime(endDate.year - 5));

    if (datePicked != null && datePicked != endDate) {
      setState(() {
        endDate = datePicked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, __CalculatorPageViewModel>(
        converter: (store) {
      return __CalculatorPageViewModel(
          currentEmployer: store.state.currentEmployer);
    }, builder: (BuildContext context, __CalculatorPageViewModel viewModel) {
      return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverPersistentHeader(
                  floating: false,
                  delegate: _SliverTopBarDelegate(
                      TimeRangePickerView(
                        onPickEndDate: () => onPickEndDate(context),
                        onPickStartDate: () => onPickStartDate(context),
                        startDate: startDate,
                        endDate: endDate,
                      ),
                      viewModel: viewModel)),
            ];
          },
          body: //Text('sample')
              CustomDataView(
            startDate: startDate,
            endDate: endDate,
          ));
    });
  }
}

class TimeRangePickerView extends StatefulWidget {
  TimeRangePickerView(
      {Key key,
      @required this.onPickStartDate,
      @required this.onPickEndDate,
      @required this.startDate,
      @required this.endDate})
      : super(key: key);
  final Function onPickStartDate;
  final Function onPickEndDate;
  final DateTime startDate;
  final DateTime endDate;

  @override
  _TimeRangePickerViewState createState() => _TimeRangePickerViewState();
}

class _TimeRangePickerViewState extends State<TimeRangePickerView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Start Date:"),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ShorterOneDayView(
                date: widget.startDate,
              ),
            ),
            IconButton(
              icon: Icon(Icons.calendar_today),
              color: Colors.red,
              onPressed: () => widget.onPickStartDate(),
            ),
          ],
        )),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("End Date:"),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ShorterOneDayView(
                date: widget.endDate,
              ),
            ),
            IconButton(
              icon: Icon(Icons.calendar_today),
              color: Colors.red,
              onPressed: () => widget.onPickEndDate(),
            ),
          ],
        )),
      ],
    );
  }
}

class CustomDataView extends StatefulWidget {
  CustomDataView({Key key, this.startDate, this.endDate}) : super(key: key);
  final DateTime startDate;
  final DateTime endDate;

  @override
  _CustomDataViewState createState() => _CustomDataViewState();
}

class _CustomDataViewState extends State<CustomDataView> {
  Commission totalCommission;
  List<Commission> listCommissions;

  Future _getCommission(__CalculatorPageViewModel viewModel) {
    String id = viewModel.currentUser.uid;
    DateTime formatedStartDate = getDateOnly(widget.startDate);
    DateTime formatedEndDate = getDateOnly(widget.endDate);

    String pathString = 'users/' +
        id +
        '/employers/' +
        viewModel.currentEmployer.employerId +
        '/commission';

    return Firestore.instance
        .collection(pathString)
        .where('date', isGreaterThanOrEqualTo: formatedStartDate)
        .where('date', isLessThanOrEqualTo: formatedEndDate)
        .getDocuments();
  }

  List<Commission> _getAllCommissionsData(AsyncSnapshot snapshot) {
    totalCommission =
        Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);
    listCommissions = List<Commission>();
    if (snapshot.data.documents.length != 0) {
      List<DocumentSnapshot> retunredCommissions = snapshot.data.documents;

      retunredCommissions.forEach((commissionData) {
        listCommissions.add(Commission(
            commission: commissionData.data['raw'].toDouble(),
            raw: commissionData.data['commission'].toDouble(),
            tip: commissionData.data['tip'].toDouble(),
            total: commissionData.data['total'].toDouble(),
            date: commissionData.data['date'],
            id: commissionData.documentID));
        totalCommission.raw += commissionData.data['raw'].toDouble();
        totalCommission.commission +=
            commissionData.data['commission'].toDouble();
        totalCommission.tip += commissionData.data['tip'].toDouble();
        totalCommission.total += commissionData.data['total'].toDouble();
        totalCommission.id == commissionData.documentID;
      });
    }

    listCommissions.add(totalCommission);
    listCommissions = listCommissions.reversed.toList();
    return listCommissions;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, __CalculatorPageViewModel>(
        converter: (store) {
      return __CalculatorPageViewModel(
          currentUser: store.state.currentUser,
          currentEmployer: store.state.currentEmployer);
    }, builder: (BuildContext context, __CalculatorPageViewModel viewModel) {
      return FutureBuilder(
        future: _getCommission(viewModel),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              listCommissions = _getAllCommissionsData(snapshot);
              return AllCommissionsView(
                listCommissions: listCommissions,
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

class AllCommissionsView extends StatefulWidget {
  AllCommissionsView({Key key, this.listCommissions}) : super(key: key);
  final List<Commission> listCommissions;

  @override
  _AllCommissionsViewState createState() => _AllCommissionsViewState();
}

DateTime getDateOnly(DateTime dateAndTime) {
  return DateTime(dateAndTime.year, dateAndTime.month, dateAndTime.day);
}

class _AllCommissionsViewState extends State<AllCommissionsView> {
  Widget dataBuilder(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        child: Column(
          children: <Widget>[
            Text(
              'Result:',
              style: TextStyle(fontSize: 25.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('Commission', style: TextStyle(fontSize: 12.0)),
                    Text(
                        widget.listCommissions[index].commission
                            .toStringAsFixed(2),
                        style: TextStyle(fontSize: 20.0)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Total', style: TextStyle(fontSize: 12.0)),
                    Text(widget.listCommissions[index].total.toStringAsFixed(2),
                        style: TextStyle(fontSize: 20.0)),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('Commission', style: TextStyle(fontSize: 12.0)),
                    Text(
                        widget.listCommissions[index].commission
                            .toStringAsFixed(2),
                        style: TextStyle(fontSize: 20.0)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Total', style: TextStyle(fontSize: 12.0)),
                    Text(widget.listCommissions[index].total.toStringAsFixed(2),
                        style: TextStyle(fontSize: 20.0)),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    return ExpansionTile(
      leading: ShorterOneDayView(date: widget.listCommissions[index].date),
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(widget.listCommissions[index].total.toStringAsFixed(2))
          ]),
      children: <Widget>[Text('place holder')],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.listCommissions.length,
      itemBuilder: dataBuilder,
    );
  }
}

class _SliverTopBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTopBarDelegate(this._timeRangePicker, {this.viewModel});
  final TimeRangePickerView _timeRangePicker;
  final __CalculatorPageViewModel viewModel;

  @override
  double get minExtent => 170.0;
  @override
  double get maxExtent => 170.0;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(children: <Widget>[
      Container(
          alignment: AlignmentDirectional.centerStart,
          padding: EdgeInsets.fromLTRB(10.0, 17.0, 10.0, 17.0),
          child: Text(
            viewModel.currentEmployer.name,
            style: TextStyle(fontSize: 30.0),
          )),
      _timeRangePicker
    ]);
  }

  @override
  bool shouldRebuild(_SliverTopBarDelegate oldDelegate) {
    return false;
  }
}
