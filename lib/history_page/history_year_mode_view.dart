import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter_picker/flutter_picker.dart';

import 'package:Calmission/common_widgets/date_time_widgets.dart';
import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/commission_page/commission_data_view.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';
import 'package:Calmission/common_widgets/custom_commission_data_view.dart';


class HistoryYearModeView extends StatefulWidget {
  HistoryYearModeView({Key key}) : super(key: key);
  @override
  _HistoryYearModeViewState createState() => _HistoryYearModeViewState();
}

class _HistoryYearModeViewState extends State<HistoryYearModeView> {
  DateTime date = DateTime.now();
  Commission commission =
      Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);

  
  showPickerDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(
            value: date,customColumnType: [0],
            maxValue: DateTime.now()),
        title: Text("Select Date"),
        selectedTextStyle: TextStyle(color: Theme.of(context).primaryColorDark),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
          setState(() {
            date = (picker.adapter as DateTimePickerAdapter).value;
          });
        }).showDialog(context);
  }

  Future<Null> onPressCalender(BuildContext context) async {
    final datePicked = await showDatePicker(
        initialDatePickerMode: DatePickerMode.year,
        context: context,
        initialDate: date,
        lastDate: DateTime.now(),
        firstDate: DateTime(date.year - 5));

    if (datePicked != null && datePicked != date) {
      setState(() {
        date = datePicked;
      });
    }
  }

  onPressBackButton() {
    setState(() {
      date = DateTime(date.year - 1);
    });
  }

  onPressNextButton() {
    setState(() {
      date = DateTime(date.year + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final CommissionService commissionService = CommissionService();

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(7.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.arrow_back_ios),
                onPressed: onPressBackButton,
              ),
              FlatButton(
                onPressed: () => showPickerDate(context),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: YearStringView(
                    date: date,
                    textColor: Colors.black,
                  ),
                ),
              ),
              IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: onPressNextButton,
              ),
            ],
          ),
        ),
        Expanded(
            child: Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child: CustomCommissionView(
                  date: date,
                  commission: commission,
                  hasEditButton: false,
                  getCommissionFunction: commissionService.getMonthCommission,
                ) /*YearWithButtonsView(
              date: date,
              commission: commission,
              nextButton: IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: onPressNextButton,
              ),
              backButton: IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.arrow_back_ios),
                onPressed: onPressBackButton,
              )),*/
                ))
      ],
    );
  }
}

class YearWithButtonsView extends StatefulWidget {
  YearWithButtonsView(
      {Key key, this.date, this.commission, this.nextButton, this.backButton})
      : super(key: key);
  final DateTime date;
  final Commission commission;
  final Widget nextButton;
  final Widget backButton;

  @override
  _YearWithButtonsViewState createState() => _YearWithButtonsViewState();
}

class _YearWithButtonsViewState extends State<YearWithButtonsView> {
  Commission commission;
  final CommissionService commissionService = CommissionService();

  Widget _buildDataAndButtion(Commission commission) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: <Widget>[
            widget.backButton,
            Flexible(
              flex: 1,
              child: TotalView(
                commission: commission,
                color: Colors.black,
              ),
            ),
            widget.nextButton
          ],
        ),
        Flexible(
          flex: 6,
          child: FlexibleSummaryView(
            commission: commission,
            date: widget.date,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    EmployerService employerService =
        Provider.of<EmployerService>(context, listen: false);
    return FutureBuilder(
      future: commissionService.getYearCommission(
          employerService.currentEmployer, widget.date),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            commission = snapshot.data;
            return _buildDataAndButtion(commission);
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
