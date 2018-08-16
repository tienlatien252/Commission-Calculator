import 'package:flutter/material.dart';

import 'models/commission.dart';


class CommissionView extends StatefulWidget {
  CommissionView({Key key, this.commission}) : super(key: key);
  final Commission commission;

  @override
  _CommissionViewState createState() => _CommissionViewState();
}

DateTime getDateOnly(DateTime dateAndTime) {
  return DateTime(dateAndTime.year, dateAndTime.month, dateAndTime.day);
}

class _CommissionViewState extends State<CommissionView> {

  @override
  Widget build(BuildContext context) {
    Commission commission = widget.commission;
     return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('raw: ' + commission.raw.toString()),
              Text('commission: ' + commission.commission.toString())
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('tip: ' + commission.tip.toString()),
              Text('total: ' + commission.total.toString())
            ],
          ),
        ],
      ),
    );
  }
}
