import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import 'package:Calmission/common_widgets/date_time_widgets.dart';
import 'package:Calmission/common_widgets/employer_panel.dart';
import 'package:Calmission/common_widgets/CustomButton.dart';
import 'package:Calmission/commission_page/edit_data_dialog.dart';
import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/history_page/history_view.dart';
import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';
import 'package:Calmission/employer_page/employerSetup.dart';
import 'package:Calmission/commission_page/history_card.dart';
import 'package:Calmission/commission_page/summary_card.dart';
import 'package:Calmission/common_widgets/custom_commission_data_view.dart';


class TodayView extends StatefulWidget {
  TodayView({Key key}) : super(key: key);
  @override
  _TodayViewState createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> with AutomaticKeepAliveClientMixin {
  final DateTime date = DateTime.now();

  @override
  bool get wantKeepAlive => true;

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



class DayScrollView extends StatefulWidget {
  DayScrollView(
      {Key key, this.date, this.commission, this.nextButton, this.backButton})
      : super(key: key);
  final DateTime date;
  final Commission commission;
  final Widget nextButton;
  final Widget backButton;

  @override
  _DayScrollViewState createState() => _DayScrollViewState();
}

class _DayScrollViewState extends State<DayScrollView> {
  Commission commission;

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

  Future<Null> _openHistoryDialog() async {
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return HistoryView();
            },
            fullscreenDialog: true));
  }

  _openEmployersSetting(BuildContext context) {
    print("openEmployersSetting");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EmployerSetup(
              title: 'Manage Employers', isInitialSetting: false)),
    );
  }

  @override
  Widget build(BuildContext context) {
    EmployerService employerService =
        Provider.of<EmployerService>(context, listen: false);
    return FutureBuilder(
      future: getDayCommission(
          employerService.currentEmployer, widget.date),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            commission = snapshot.data;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 0.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TotalView(
                      commission: commission,
                      color: Colors.white,
                    ),
                    CustomInlineButton(
                      onTap: () => _openEmployersSetting(context),
                      text: 'View Employer Informations',
                    ),
                    SummaryView(
                      commission: commission,
                      onTapEdit: _openEditCommissionDialog,
                      date: widget.date,
                    ),
                    HistoryCardView(
                      currentEmployer: employerService.currentEmployer,
                      commission: commission,
                      date: widget.date,
                      onTapHistory: () => _openHistoryDialog(),
                    ),
                  ],
                ),
              ),
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