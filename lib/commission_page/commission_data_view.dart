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
          employerService.currentEmployer, widget.date),
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
                      color: Colors.white,
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
                      currentEmployer: employerService.currentEmployer,
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
  HistoryCardView(
      {Key key,
      this.commission,
      this.date,
      this.onTapHistory,
      this.currentEmployer})
      : super(key: key);
  final Commission commission;
  final DateTime date;
  final Function onTapHistory;
  final Employer currentEmployer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(7.0)),
      height: 300,
      child: Column(
        children: <Widget>[
          HistoryButton(onTap: onTapHistory),
          SmallDayHistoryView(
            currentEmployer: currentEmployer,
            date: minusToday(1),
          ),
          SmallDayHistoryView(
            currentEmployer: currentEmployer,
            date: minusToday(2),
          ),
          SmallDayHistoryView(
            currentEmployer: currentEmployer,
            date: minusToday(3),
          ),
          Expanded(
            child: Container(
              alignment: AlignmentDirectional.center,
              child: CustomInlineButton(
                onTap: onTapHistory,
                text: 'View History',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryButton extends StatelessWidget {
  HistoryButton({Key key, this.onTap}) : super(key: key);
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: onTap,
          child: Container(
              margin: EdgeInsets.all(10.0),
              height: 30.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('History',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 20.0)),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColorDark,
                  )
                ],
              )),
        ),
        Divider(
          height: 10.0,
          endIndent: 20.0,
          indent: 10.0,
        ),
      ],
    );
  }
}

class SmallDayHistoryView extends StatelessWidget {
  SmallDayHistoryView({Key key, this.date, this.currentEmployer})
      : super(key: key);
  final DateTime date;
  final Employer currentEmployer;

  final CommissionService commissionService = CommissionService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: commissionService.getCommission(currentEmployer, date),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              Commission commission = snapshot.data;
              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(10.0),
                          height: 20.0,
                          child: SmallItalicOneDayView(
                            //textColor: Theme.of(context).primaryColorDark,
                            date: date,
                          )),
                      SmallAmountView(
                        amount: commission.total,
                      )
                    ],
                  ),
                  Divider(
                    endIndent: 20.0,
                    indent: 10.0,
                  )
                ],
              );
            case ConnectionState.waiting:
              return Center(child: PlatformLoadingIndicator());
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return Text('Result: ${snapshot.data}');
          }
        });
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



class FlexibleSummaryView extends StatelessWidget {
  FlexibleSummaryView({Key key, this.commission, this.date, this.onTapEdit})
      : super(key: key);
  final Commission commission;
  final DateTime date;
  final Function onTapEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(7.0)),
      child: Column(
        children: <Widget>[
          Divider(
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

class SmallAmountView extends StatelessWidget {
  SmallAmountView({Key key, this.amount}) : super(key: key);
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '\$ ',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10.0),
              ),
              Text(
                amount.toInt().toString(),
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
              ),
              Container(
                  alignment: AlignmentDirectional.topEnd,
                  child: Text(
                    (amount % 1 * 10).toInt().toString().padLeft(2, '0'),
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 10.0),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class TotalView extends StatelessWidget {
  TotalView({Key key, this.commission, this.text, this.color}) : super(key: key);
  final Commission commission;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Total', style: TextStyle(color: color)),
        Container(
          margin: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '\$ ',
                style: TextStyle(color: color, fontSize: 20.0),
              ),
              Text(
                commission.total.toInt().toString(),
                style: TextStyle(color: color, fontSize: 40.0),
              ),
              Container(
                  alignment: AlignmentDirectional.topEnd,
                  child: Text(
                    (commission.total % 1 * 10)
                        .toInt()
                        .toString()
                        .padLeft(2, '0'),
                    textAlign: TextAlign.start,
                    style: TextStyle(color: color, fontSize: 20.0),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
