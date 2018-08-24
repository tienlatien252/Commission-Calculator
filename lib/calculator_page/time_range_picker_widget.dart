import 'package:flutter/material.dart';

import '../date_time_view.dart';

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
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: FlatButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            color: Color.fromARGB(255, 76,183,219),
            onPressed: () => widget.onPickStartDate(),
            child: Row(
              children: <Widget>[
            Icon(
              Icons.calendar_today,
            ),
            SizedBox(width: 10.0,),
            Text("Start Date:"),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ShorterOneDayView(
                date: widget.startDate,
                textColor: Colors.white,
              ),
            ),
              ],
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          padding: EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 0.0),
          child: FlatButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            color: Color.fromARGB(255, 76,183,219),
            onPressed: () => widget.onPickEndDate(),
            child: Row(
              children: <Widget>[
            Icon(
              Icons.calendar_today,
            ),
            SizedBox(width: 10.0,),
            Text(
              "End Date:",
              //style: TextStyle(color: Colors.white),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ShorterOneDayView(
                date: widget.endDate,
                textColor: Colors.white,
              ),
            ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
