import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/common_widgets/date_time_widgets.dart';

class EmployerName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
          child: Container(
          alignment: AlignmentDirectional.centerStart,
          padding: EdgeInsets.fromLTRB(20.0, 17.0, 10.0, 17.0),
          child: Consumer<EmployerService>(builder:
              (BuildContext context, EmployerService employerService, __) {
            Employer employer = employerService.currentEmployer;
            String employerName = '';
            if (employer != null) {
              employerName = employer.name;
            }
            return Text(
              employerName,
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            );
          })),
    );
  }
}

class EmployerPanel extends StatelessWidget {
  final Widget date;
  final Widget selector;

  EmployerPanel({this.date, this.selector});

  BorderRadiusGeometry _getDecoration() {
    if (selector == null) {
      return BorderRadius.circular(15.0);
    }
    return BorderRadius.only(
        topLeft: const Radius.circular(15.0),
        topRight: const Radius.circular(15.0));
  }

  EdgeInsetsGeometry _getEdgeInsets() {
    if (selector == null) {
      return EdgeInsets.all(10.0);
    }
    return EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(child: EmployerName()),
              selector != null ? selector : Container(height: 0)
            ],
          ),
          date != null
              ? Container(
                  alignment: AlignmentDirectional.centerStart,
                  padding: EdgeInsets.fromLTRB(20.0, 13.0, 10.0, 13.0),
                  child: date)
              : Container(height: 0),
        ],
      ),
    );
  }
}

class EmployerPanelWithSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
          alignment: AlignmentDirectional.centerStart,
          padding: EdgeInsets.fromLTRB(20.0, 17.0, 10.0, 17.0),
          child: Consumer<EmployerService>(builder:
              (BuildContext context, EmployerService employerService, __) {
            Employer employer = employerService.currentEmployer;
            String employerName = '';
            if (employer != null) {
              employerName = employer.name;
            }
            return Text(
              employerName,
              style: TextStyle(fontSize: 40.0, color: Colors.white),
            );
          })),
    );
  }
}
