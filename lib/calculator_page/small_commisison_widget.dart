import 'package:flutter/material.dart';
import 'package:Calmission/services/commission_service.dart';

class SmallCommissionsView extends StatelessWidget {
  SmallCommissionsView({Key key, this.commission, this.numberColor, this.stringColor}) : super(key: key);
  final Commission commission;
  final Color numberColor;
  final Color stringColor;

  @override
  Widget build(BuildContext context) {
    Color trueNumberColor = numberColor != null ? numberColor : Colors.black;
    Color trueStringColor = stringColor != null ? stringColor : Colors.black;
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text('Raw', style: TextStyle(fontSize: 12.0, color: trueStringColor)),
                    Text("\$" + commission.raw.toStringAsFixed(2),
                        style: TextStyle(fontSize: 20.0, color: trueNumberColor)),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text('Commission', style: TextStyle(fontSize: 12.0, color: trueStringColor)),
                    Text("\$" + commission.commission.toStringAsFixed(2),
                        style: TextStyle(fontSize: 20.0, color: trueNumberColor)),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text('Tip', style: TextStyle(fontSize: 12.0, color: trueStringColor)),
                    Text("\$" + commission.tip.toStringAsFixed(2),
                        style: TextStyle(fontSize: 20.0, color: trueNumberColor)),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text('Total', style: TextStyle(fontSize: 12.0, color: trueStringColor)),
                    Text("\$" + commission.total.toStringAsFixed(2),
                        style: TextStyle(fontSize: 20.0, color: trueNumberColor)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
