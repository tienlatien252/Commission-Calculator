import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import 'package:Calmission/commission_page/edit_data_dialog.dart';
import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';
import 'package:Calmission/common_widgets/CustomButton.dart';
import 'package:Calmission/common_widgets/comission_chart.dart';

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
        : CommissionChart(commission: commission, animate: true,);
    return dataAndButton;
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
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildDataAndButtion(commission),
                CustomTextButton(
                  label: "Edit",
                  onTap: _openEditCommissionDialog,
                  alignment: AlignmentDirectional.bottomEnd,
                ),
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
      },
    );
  }
}

/*
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
                CustomTextButton(
                  label: "Edit",
                  onTap: _openEditCommissionDialog,
                  alignment: AlignmentDirectional.bottomEnd,
                ),
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
      },
    );
  }
}
*/
