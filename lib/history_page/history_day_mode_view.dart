import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import 'package:Calmission/commission_page/commission_data_view.dart';
import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/common_widgets/date_time_widgets.dart';
import 'package:Calmission/commission_page/edit_data_dialog.dart';
import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';
import 'package:Calmission/common_widgets/CustomButton.dart';
import 'package:Calmission/common_widgets/comission_chart.dart';

class HistoryDayModeView extends StatefulWidget {
  HistoryDayModeView({Key key}) : super(key: key);
  @override
  _HistoryDayModeViewState createState() => _HistoryDayModeViewState();
}

class _HistoryDayModeViewState extends State<HistoryDayModeView> {
  DateTime date = DateTime.now();
  Commission commission =
      Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);

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
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0)),
            //color: Color.fromARGB(255, 76, 183, 219),
            color: Theme.of(context).accentColor,
            onPressed: () => onPressCalender(context),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                  color: Colors.black54,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Date:",
                  style: TextStyle(color: Colors.black54),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: ShortOneDayView(
                    date: date,
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
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
              child: DayWithButtonsView(
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
                  )),
            ),
          ),
        )
      ],
    );
  }
}

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

  Widget _buildDataAndButtion(Commission commission) {
    return Row(
      //mainAxisSize: MainAxisSize.min,
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        widget.backButton,
        Flexible(
          child: Column(
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
          ),
        ),
        widget.nextButton
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
