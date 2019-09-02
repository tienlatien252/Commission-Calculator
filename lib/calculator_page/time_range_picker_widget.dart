import 'package:flutter/material.dart';

import 'package:Calmission/common_widgets/date_time_widgets.dart';

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
          margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
          //padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: FlatButton(
            splashColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0)),
            color: Theme.of(context).accentColor,
            onPressed: () => widget.onPickStartDate(),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text("Start Date:", style: TextStyle(color: Colors.black54)),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: ShorterOneDayView(
                    date: widget.startDate,
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        //SizedBox(height: 5.0),
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          //padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0)),
            color: Theme.of(context).accentColor,
            onPressed: () => widget.onPickEndDate(),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text("End Date:", style: TextStyle(color: Colors.black54)),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: ShorterOneDayView(
                    date: widget.endDate,
                    textColor: Colors.black,
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
