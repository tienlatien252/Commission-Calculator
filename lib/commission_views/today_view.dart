import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/employer.dart';
import '../logic/app_state.dart';
import '../commission_views/commission_data_view.dart';
import '../date_time_view.dart';

class _TodayViewModel {
  _TodayViewModel({this.currentEmployer});

  final Employer currentEmployer;
}

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
    return StoreConnector<AppState, _TodayViewModel>(converter: (store) {
      return _TodayViewModel(currentEmployer: store.state.currentEmployer);
    }, builder: (BuildContext context, _TodayViewModel viewModel) {
      return Column(
        children: <Widget>[
          Container(
             margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              children: <Widget>[
                Container(
                    alignment: AlignmentDirectional.centerStart,
                    padding: EdgeInsets.fromLTRB(10.0, 17.0, 10.0, 17.0),
                    child: Text(
                      viewModel.currentEmployer.name,
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    )),
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  padding: EdgeInsets.fromLTRB(10.0, 13.0, 10.0, 13.0),
                  child: OneDayView(
                    date: date,
                  ),
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
                  child: DayEditView(date: date)))
        ],
      );
    });
  }
}
