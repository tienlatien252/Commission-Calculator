import 'package:flutter/material.dart';

import 'package:Calmission/common_widgets/date_time_widgets.dart';
import 'small_commisison_widget.dart';
import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/common_widgets/comission_chart.dart';
import 'package:Calmission/history_page/history_view.dart';
import 'package:Calmission/calculator_page/calculator_page.dart';


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
    if(index == 0){
      return SummaryView(commission: widget.listCommissions[0],);
    }
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
              ShorterOneDayView(date: widget.listCommissions[index].date, textColor: Theme.of(context).textSelectionColor,),
              Text('Details')
            ]),
        children: <Widget>[
          SmallCommissionsView(commission: widget.listCommissions[index], stringColor: Colors.black87,)
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
