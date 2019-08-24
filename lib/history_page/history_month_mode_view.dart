import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_picker/flutter_picker.dart';

import 'package:Calmission/common_widgets/date_time_widgets.dart';
import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/common_widgets/custom_commission_data_view.dart';

class HistoryMonthModeView extends StatefulWidget {
  HistoryMonthModeView({Key key}) : super(key: key);
  @override
  _HistoryMonthModeViewState createState() => _HistoryMonthModeViewState();
}

class _HistoryMonthModeViewState extends State<HistoryMonthModeView> {
  DateTime date = DateTime.now();
  Commission commission =
      Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);

  showPickerDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(
            value: date,
            type: PickerDateTimeType.kYM,
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

  showPickerDateCustom(BuildContext context) {
    new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(
          customColumnType: [2, 1, 0, 3, 4],
        ),
        title: new Text("Select Data"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
        }).showDialog(context);
  }

  Future<Null> onPressCalender(BuildContext context) async {
    final datePicked = await showDatePicker(
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
      date = DateTime(date.year, date.month - 1);
    });
  }

  onPressNextButton() {
    setState(() {
      date = DateTime(date.year, date.month + 1);
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
                  child: MonthStringView(
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
                )))
      ],
    );
  }
}