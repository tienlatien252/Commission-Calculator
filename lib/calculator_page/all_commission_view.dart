
import 'package:flutter/material.dart';

import '../models/commission.dart';
import '../date_time_view.dart';
import 'small_commisison_widget.dart';

class AllCommissionsView extends StatefulWidget {
  AllCommissionsView({Key key, this.listCommissions, this.totalCommission})
      : super(key: key);
  final Commission totalCommission;
  final List<Commission> listCommissions;

  @override
  _AllCommissionsViewState createState() => _AllCommissionsViewState();
}

DateTime getDateOnly(DateTime dateAndTime) {
  return DateTime(dateAndTime.year, dateAndTime.month, dateAndTime.day);
}

class _AllCommissionsViewState extends State<AllCommissionsView> {
  Widget dataBuilder(BuildContext context, int index) {
    return ExpansionTile(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ShorterOneDayView(date: widget.listCommissions[index].date),
            Text('Details')
          ]),
      children: <Widget>[
        SmallCommissionsView(commission: widget.listCommissions[index])
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.listCommissions.length,
      itemBuilder: dataBuilder,
    );
  }
}
