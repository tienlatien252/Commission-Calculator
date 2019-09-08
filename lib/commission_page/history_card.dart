import 'package:flutter/material.dart';

import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';
import 'package:Calmission/common_widgets/CustomButton.dart';
import 'package:Calmission/common_widgets/date_time_widgets.dart';

class HistoryCardView extends StatelessWidget {
  HistoryCardView(
      {Key key,
      this.commission,
      this.date,
      this.onTapHistory,
      this.currentEmployer})
      : super(key: key);
  final Commission commission;
  final DateTime date;
  final Function onTapHistory;
  final Employer currentEmployer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(7.0)),
      height: 300,
      child: Column(
        children: <Widget>[
          HistoryButton(onTap: onTapHistory),
          SmallDayHistoryView(
            currentEmployer: currentEmployer,
            date: minusToday(1),
          ),
          SmallDayHistoryView(
            currentEmployer: currentEmployer,
            date: minusToday(2),
          ),
          SmallDayHistoryView(
            currentEmployer: currentEmployer,
            date: minusToday(3),
          ),
          Expanded(
            child: Container(
              alignment: AlignmentDirectional.center,
              child: CustomInlineButton(
                onTap: onTapHistory,
                text: 'View History',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryButton extends StatelessWidget {
  HistoryButton({Key key, this.onTap}) : super(key: key);
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: onTap,
          child: Container(
              margin: EdgeInsets.all(10.0),
              height: 30.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('History',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 20.0)),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColorDark,
                  )
                ],
              )),
        ),
        Divider(
          height: 10.0,
          endIndent: 20.0,
          indent: 10.0,
        ),
      ],
    );
  }
}

class SmallDayHistoryView extends StatelessWidget {
  SmallDayHistoryView({Key key, this.date, this.currentEmployer})
      : super(key: key);
  final DateTime date;
  final Employer currentEmployer;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDayCommission(currentEmployer, date),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              Commission commission = snapshot.data;
              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(10.0),
                          height: 20.0,
                          child: SmallItalicOneDayView(
                            //textColor: Theme.of(context).primaryColorDark,
                            date: date,
                          )),
                      SmallAmountView(
                        amount: commission.total,
                      )
                    ],
                  ),
                  Divider(
                    endIndent: 20.0,
                    indent: 10.0,
                  )
                ],
              );
            case ConnectionState.waiting:
              return Center(child: PlatformLoadingIndicator());
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return Text('Result: ${snapshot.data}');
          }
        });
  }
}



class SmallAmountView extends StatelessWidget {
  SmallAmountView({Key key, this.amount}) : super(key: key);
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '\$ ',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10.0),
              ),
              Text(
                amount.toInt().toString(),
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
              ),
              Container(
                  alignment: AlignmentDirectional.topEnd,
                  child: Text(
                    (amount % 1 * 10).toInt().toString().padLeft(2, '0'),
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 10.0),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}