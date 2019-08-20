import 'package:Calmission/history_page/history_view.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import 'package:Calmission/commission_page/edit_data_dialog.dart';
import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';
import 'package:Calmission/common_widgets/CustomButton.dart';
import 'package:Calmission/common_widgets/comission_chart.dart';
import 'package:Calmission/common_widgets/date_time_widgets.dart';
import 'package:Calmission/employer_page/employerSetup.dart';

DateTime getDateOnly(DateTime dateAndTime) {
  return DateTime(dateAndTime.year, dateAndTime.month, dateAndTime.day);
}

class DayScrollView extends StatefulWidget {
  DayScrollView(
      {Key key, this.date, this.commission, this.nextButton, this.backButton})
      : super(key: key);
  final DateTime date;
  final Commission commission;
  final Widget nextButton;
  final Widget backButton;

  @override
  _DayScrollViewState createState() => _DayScrollViewState();
}

class _DayScrollViewState extends State<DayScrollView> {
  Commission commission;
  final CommissionService commissionService = CommissionService();

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
  }

  Future<Null> _openHistoryDialog() async {
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return HistoryView();
            },
            fullscreenDialog: true));
  }

  Widget _buildDataAndButtion(Commission commission) {
    Widget dataAndButton = widget.backButton != null
        ? Expanded(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              widget.backButton,
              CommissionChart(
                commission: commission,
                animate: true,
                color: Theme.of(context).accentColor,
              ),
              widget.nextButton
            ],
          ))
        : CommissionChart(
            commission: commission,
            animate: true,
          );
    return dataAndButton;
  }

  _openEmployersSetting(BuildContext context) {
    print("openEmployersSetting");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EmployerSetup(
              title: 'Manage Employers', isInitialSetting: false)),
    );
  }

  @override
  Widget build(BuildContext context) {
    EmployerService employerService =
        Provider.of<EmployerService>(context, listen: false);
    return FutureBuilder(
      future: commissionService.getCommission(
          employerService.currentEmployer, widget.commission, widget.date),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            commission = snapshot.data;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 0.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TotalView(
                      commission: commission,
                    ),
                    CustomInlineButton(
                      onTap: () => _openEmployersSetting(context),
                      text: 'View Employer Informations',
                    ),
                    SummaryView(
                      commission: commission,
                      onTapEdit: _openEditCommissionDialog,
                      date: widget.date,
                    ),
                    HistoryCardView(
                      commission: commission,
                      date: widget.date,
                      onTapHistory: () => _openHistoryDialog(),
                    ),
                  ],
                ),
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

class HistoryCardView extends StatelessWidget {
  HistoryCardView({Key key, this.commission, this.date, this.onTapHistory})
      : super(key: key);
  final Commission commission;
  final DateTime date;
  final Function onTapHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(7.0)),
      height: 300,
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(10.0),
              height: 30.0,
              child: Row(
                children: <Widget>[
                  Text('History',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 20.0)),
                ],
              )),
          Divider(
            height: 10.0,
            endIndent: 20.0,
            indent: 10.0,
          ),
          Expanded(
            child: CustomInlineButton(
              onTap: onTapHistory,
              text: 'View History',
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryView extends StatelessWidget {
  SummaryView({Key key, this.commission, this.date, this.onTapEdit})
      : super(key: key);
  final Commission commission;
  final DateTime date;
  final Function onTapEdit;

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
              margin: EdgeInsets.all(10.0),
              height: 30.0,
              child: OneDayView(
                textColor: Theme.of(context).primaryColorDark,
                date: date,
              )),
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
          CustomButtonBar(
            onTap: onTapEdit,
            text: 'Edit',
          ),
        ],
      ),
    );
  }
}

class SmallDetailsView extends StatelessWidget {
  SmallDetailsView({Key key, this.amount, this.type}) : super(key: key);
  final String type;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(type,
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 10.0)),
        Container(
          margin: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '\$ ',
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark, fontSize: 10.0),
              ),
              Text(
                amount.toInt().toString(),
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark, fontSize: 20.0),
              ),
              Container(
                  alignment: AlignmentDirectional.topEnd,
                  child: Text(
                    (amount % 1 * 10).toInt().toString().padLeft(2, '0'),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 10.0),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class TotalView extends StatelessWidget {
  TotalView({Key key, this.commission, this.text}) : super(key: key);
  final Commission commission;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Total', style: TextStyle(color: Colors.white)),
        Container(
          margin: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '\$ ',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              Text(
                commission.total.toInt().toString(),
                style: TextStyle(color: Colors.white, fontSize: 40.0),
              ),
              Container(
                  alignment: AlignmentDirectional.topEnd,
                  child: Text(
                    (commission.total % 1 * 10)
                        .toInt()
                        .toString()
                        .padLeft(2, '0'),
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
