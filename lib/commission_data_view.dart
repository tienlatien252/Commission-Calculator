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
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'raw:',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Text("\$"+ commission.raw.toString(),
                          style: TextStyle(fontSize: 30.0)))
                ],
              ),
              Row(
                children: <Widget>[
                  Text('commission:', style: TextStyle(fontSize: 20.0)),
                  Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Text("\$"+commission.commission.toString(),
                          style: TextStyle(fontSize: 30.0)))
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('tip:', style: TextStyle(fontSize: 20.0)),
                  Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Text("\$"+commission.tip.toString(),
                          style: TextStyle(fontSize: 30.0)))
                ],
              ),
              Row(
                children: <Widget>[
                  Text('total:',  style: TextStyle(fontSize: 20.0)),
                  Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Text("\$"+commission.total.toString(),
                          style: TextStyle(fontSize: 30.0)))
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
