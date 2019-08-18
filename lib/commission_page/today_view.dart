import 'package:flutter/material.dart';

import 'package:Calmission/commission_page/commission_data_view.dart';
import 'package:Calmission/common_widgets/date_time_widgets.dart';
import 'package:Calmission/common_widgets/employer_panel.dart';

class TodayView extends StatefulWidget {
  TodayView({Key key}) : super(key: key);
  @override
  _TodayViewState createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  final DateTime date = DateTime.now();
  // Commission commission =
  //     Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
            flex: 2,
            child: EmployerPanel(
                date: OneDayView(
              date: date,
            ))),
        Flexible(
          flex: 5,
          child: Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0)),
              child: DayEditView(date: date)),
        )
      ],
    );
  }
}
