import 'package:flutter/material.dart';

import 'package:Calmission/services/commission_service.dart';


class CommissionView extends StatefulWidget {
  CommissionView(
      {Key key,
      @required this.commission,
      this.stringFontSize,
      this.numberFontSize})
      : super(key: key);
  final Commission commission;
  final double stringFontSize;
  final double numberFontSize;

  @override
  _CommissionViewState createState() => _CommissionViewState();
}

DateTime getDateOnly(DateTime dateAndTime) {
  return DateTime(dateAndTime.year, dateAndTime.month, dateAndTime.day);
}

class _CommissionViewState extends State<CommissionView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double numberFontSize =
        widget.numberFontSize != null ? widget.numberFontSize : 40.0;
    double stringFontSize =
        widget.stringFontSize != null ? widget.stringFontSize : 25.0;
    Commission commission = widget.commission;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Raw',
                          style: TextStyle(
                              fontSize: stringFontSize, color: Colors.black54),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: Text("\$" + commission.raw.toStringAsFixed(2),
                              style: TextStyle(fontSize: numberFontSize)))
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    children: <Widget>[
                      Text('Commission',
                          style: TextStyle(
                              fontSize: stringFontSize, color: Colors.black54)),
                      Container(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: Text(
                            "\$" + commission.commission.toStringAsFixed(2),
                            style: TextStyle(fontSize: numberFontSize),
                            //maxLines: 2,
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    children: <Widget>[
                      Text('Tip',
                          style: TextStyle(
                              fontSize: stringFontSize, color: Colors.black54)),
                      Container(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: Text("\$" + commission.tip.toStringAsFixed(2),
                              style: TextStyle(fontSize: numberFontSize)))
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    children: <Widget>[
                      Text('Total',
                          style: TextStyle(
                              fontSize: stringFontSize, color: Colors.black54)),
                      Container(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: Text(
                              "\$" + commission.total.toStringAsFixed(2),
                              style: TextStyle(fontSize: numberFontSize)))
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
