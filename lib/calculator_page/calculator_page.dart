import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/calculator_page/slivers.dart';
import 'package:Calmission/calculator_page/small_commisison_widget.dart';
import 'package:Calmission/calculator_page/all_commission_view.dart';
import 'package:Calmission/calculator_page/time_range_picker_widget.dart';
import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';
import 'package:Calmission/common_widgets/custom_commission_data_view.dart';
import 'package:Calmission/commission_page/commission_data_view.dart';
import 'package:Calmission/common_widgets/date_time_widgets.dart';
import 'package:Calmission/common_widgets/comission_chart.dart';

class CalculatorPage extends StatefulWidget {
  CalculatorPage({Key key}) : super(key: key);
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  Commission totalCommission =
      Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);
  List<Commission> listCommissions;

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
    EmployerService employerService =
        Provider.of<EmployerService>(context, listen: false);
    return FutureBuilder(
      future: getRangeCommission(
          employerService.currentEmployer, startDate, endDate),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            Map map = snapshot.data;
            listCommissions = map['listCommissions'];
            totalCommission = map['totalCommission'];
            return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverPersistentHeader(
                      delegate: SliverTopBarDelegate(
                    TimeRangePickerView(
                      onPickEndDate: () => onPickEndDate(context),
                      onPickStartDate: () => onPickStartDate(context),
                      startDate: startDate,
                      endDate: endDate,
                    ),
                  )),
                ];
              },
              body: //Text('sample') //TotalView(
                  //  commission: totalCommission,
                  //),
                  ListView(
                children: <Widget>[
                  TotalView(
                    commission: totalCommission,
                  ),
                  AllCommissionsView(
                    listCommissions: listCommissions,
                  ),
                ],
              ),
            );
          case ConnectionState.waiting:
            return Center(child: PlatformLoadingIndicator());
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

class TotalView extends StatelessWidget {
  TotalView({Key key, this.commission}) : super(key: key);
  final Commission commission;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(7.0)),
      height: 400,
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(10.0), height: 30.0, child: Text('total')),
          Divider(
            height: 10.0,
            endIndent: 20.0,
            indent: 10.0,
          ),
          Expanded(
            child: CommissionPieChart(
              commission: commission,
              animate: true,
              color: Theme.of(context).accentColor,
            ),
          ),
          Container(
            //alignment: AlignmentDirectional.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SmallDetailsView(type: 'Raw', amount: commission.raw),
                SmallDetailsView(
                    type: 'Commission', amount: commission.commission),
                SmallDetailsView(type: 'Tip', amount: commission.tip),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
