import 'package:flutter/material.dart';

import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/common_widgets/CustomButton.dart';
import 'package:Calmission/common_widgets/comission_chart.dart';
import 'package:Calmission/common_widgets/date_time_widgets.dart';
import 'package:Calmission/common_widgets/custom_commission_data_view.dart';

class SummaryView extends StatelessWidget {
  SummaryView({Key key, this.commission, this.date, this.onTapEdit})
      : super(key: key);
  final Commission commission;
  final DateTime date;
  final Function onTapEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(7.0)),
      height: 400,
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(10.0),
              height: 30.0,
              child: OneDayView(
                textColor: Theme.of(context).primaryColorDark,
                date: date,
              )),
          Divider(
            height: 10.0,
            endIndent: 20.0,
            indent: 10.0,
          ),
          Expanded(
            child: CommissionPieChart(
              commission: commission,
              animate: true,
              color: Theme.of(context).accentColor,
            ),
          ),
          Container(
            //alignment: AlignmentDirectional.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SmallDetailsView(type: 'Raw', amount: commission.raw),
                SmallDetailsView(
                    type: 'Commission', amount: commission.commission),
                SmallDetailsView(type: 'Tip', amount: commission.tip),
              ],
            ),
          ),
          CustomButtonBar(
            onTap: onTapEdit,
            text: 'Edit',
          ),
        ],
      ),
    );
  }
}



class FlexibleSummaryView extends StatelessWidget {
  FlexibleSummaryView({Key key, this.commission, this.date, this.onTapEdit})
      : super(key: key);
  final Commission commission;
  final DateTime date;
  final Function onTapEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(7.0)),
      child: Column(
        children: <Widget>[
          Divider(
            endIndent: 20.0,
            indent: 10.0,
          ),
          Expanded(
            child: CommissionPieChart(
              commission: commission,
              animate: true,
              color: Theme.of(context).accentColor,
            ),
          ),
          Container(
            //alignment: AlignmentDirectional.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SmallDetailsView(type: 'Raw', amount: commission.raw),
                SmallDetailsView(
                    type: 'Commission', amount: commission.commission),
                SmallDetailsView(type: 'Tip', amount: commission.tip),
              ],
            ),
          ),
          CustomButtonBar(
            onTap: onTapEdit,
            text: 'Edit',
          ),
        ],
      ),
    );
  }
}