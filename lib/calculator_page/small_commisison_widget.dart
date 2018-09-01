import 'package:flutter/material.dart';

import '../models/commission.dart';

class SmallCommissionsView extends StatelessWidget {
  SmallCommissionsView({Key key, this.commission}) : super(key: key);
  final Commission commission;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('Raw', style: TextStyle(fontSize: 12.0)),
                  Text("\$" + commission.raw.toStringAsFixed(2),
                      style: TextStyle(fontSize: 20.0)),
                ],
              ),
              Column(
                children: <Widget>[
                  Text('Commission', style: TextStyle(fontSize: 12.0)),
                  Text("\$" + commission.commission.toStringAsFixed(2),
                      style: TextStyle(fontSize: 20.0)),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('Tip', style: TextStyle(fontSize: 12.0)),
                  Text("\$" + commission.tip.toStringAsFixed(2),
                      style: TextStyle(fontSize: 20.0)),
                ],
              ),
              Column(
                children: <Widget>[
                  Text('Total', style: TextStyle(fontSize: 12.0)),
                  Text("\$" + commission.total.toStringAsFixed(2),
                      style: TextStyle(fontSize: 20.0)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}