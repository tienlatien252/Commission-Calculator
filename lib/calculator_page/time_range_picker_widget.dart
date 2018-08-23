
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
