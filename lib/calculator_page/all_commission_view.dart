import 'package:flutter/material.dart';

import '../models/commission.dart';
import '../date_time_view.dart';
import 'small_commisison_widget.dart';
import '../commission_views/commission_data_view.dart';

class AllCommissionsView extends StatefulWidget {
  AllCommissionsView({Key key, this.listCommissions, this.totalCommission})
      : super(key: key);
  final Commission totalCommission;
  final List<Commission> listCommissions;

  @override
  _AllCommissionsViewState createState() => _AllCommissionsViewState();
}

class _AllCommissionsViewState extends State<AllCommissionsView> {
  Widget dataBuilder(BuildContext context, int index) {
    return Container(
      decoration: ShapeDecoration(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Colors.white,
      ),
      margin: EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 6.0),
      //padding: EdgeInsets.all(10.0),
      child: ExpansionTile(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ShorterOneDayView(date: widget.listCommissions[index].date),
              Text('Details')
            ]),
        children: <Widget>[
          SmallCommissionsView(commission: widget.listCommissions[index], numberColor: Theme.of(context).primaryColorDark,)
        ],
      ),
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
