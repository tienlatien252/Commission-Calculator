import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter_picker/flutter_picker.dart';

import 'package:Calmission/commission_page/commission_data_view.dart';
import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/common_widgets/date_time_widgets.dart';
import 'package:Calmission/commission_page/edit_data_dialog.dart';
import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';
import 'package:Calmission/common_widgets/CustomButton.dart';
import 'package:Calmission/common_widgets/comission_chart.dart';
import 'package:Calmission/common_widgets/custom_commission_data_view.dart';

class HistoryDayModeView extends StatefulWidget {
  HistoryDayModeView({Key key}) : super(key: key);
  @override
  _HistoryDayModeViewState createState() => _HistoryDayModeViewState();
}

class _HistoryDayModeViewState extends State<HistoryDayModeView> {
  DateTime date = DateTime.now();
  Commission commission =
      Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);

  showPickerDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(value: date, maxValue: DateTime.now()),
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
      date = date.subtract(Duration(days: 1));
    });
  }

  onPressNextButton() {
    setState(() {
      date = date.add(Duration(days: 1));
    });
  }

  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity == 0)
      return; // user have just tapped on screen (no dragging)

    if (details.primaryVelocity.compareTo(0) == -1) {
      setState(() {
        date = date.add(Duration(days: 1));
      });
    } else {
      setState(() {
        date = date.subtract(Duration(days: 1));
      });
    }
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
                  child: ShortOneDayView(
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
          child: GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) =>
                _onHorizontalDrag(details),
            child: Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7.0)),
              child: CustomCommissionView(
                date: date,
                commission: commission,
                hasEditButton: true,
                getCommissionFunction: commissionService.getCommission,
              ),
            ),
          ),
        )
      ],
    );
  }
}
/*
class DayWithButtonsView extends StatefulWidget {
  DayWithButtonsView(
      {Key key, this.date, this.commission, this.nextButton, this.backButton})
      : super(key: key);
  final DateTime date;
  final Commission commission;
  final Widget nextButton;
  final Widget backButton;

  @override
  _DayWithButtonsViewState createState() => _DayWithButtonsViewState();
}

class _DayWithButtonsViewState extends State<DayWithButtonsView> {
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

  Widget _buildDataView(Commission commission) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: TotalView(
            commission: commission,
            color: Colors.black,
          ),
        ),
        Flexible(
          flex: 6,
          child: FlexibleSummaryView(
            commission: commission,
            onTapEdit: _openEditCommissionDialog,
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
      future: commissionService.getCommission(
          employerService.currentEmployer, widget.date),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            commission = snapshot.data;
            return _buildDataView(commission);
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
