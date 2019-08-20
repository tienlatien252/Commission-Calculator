import 'package:flutter/material.dart';

import 'package:Calmission/commission_page/commission_data_view.dart';
import 'package:Calmission/common_widgets/date_time_widgets.dart';
import 'package:Calmission/common_widgets/employer_panel.dart';
import 'package:Calmission/common_widgets/CustomButton.dart';
import 'package:Calmission/commission_page/edit_data_dialog.dart';
import 'package:Calmission/services/commission_service.dart';

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
        AppBar(
          elevation: 0.1,
          title: Row(children: <Widget>[
            Image.asset('assets/icon-reverse-retangle.png'),
            EmployerName(),
          ]),
        ),
        Expanded(
          child: DayScrollView(date: date),
        )
      ],
    );
  }
}
