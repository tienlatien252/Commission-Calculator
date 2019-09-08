
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';
import 'package:Calmission/common_widgets/CustomButton.dart';
import 'package:Calmission/common_widgets/comission_chart.dart';
import 'package:Calmission/commission_page/edit_data_dialog.dart';
import 'package:Calmission/common_widgets/date_time_widgets.dart';


class TotalView extends StatelessWidget {
  TotalView({Key key, this.commission, this.text, this.color}) : super(key: key);
  final Commission commission;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Total', style: TextStyle(color: color)),
        Container(
          margin: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '\$ ',
                style: TextStyle(color: color, fontSize: 20.0),
              ),
              Text(
                commission.total.toInt().toString(),
                style: TextStyle(color: color, fontSize: 40.0),
              ),
              Container(
                  alignment: AlignmentDirectional.topEnd,
                  child: Text(
                    (commission.total % 1 * 10)
                        .toInt()
                        .toString()
                        .padLeft(2, '0'),
                    textAlign: TextAlign.start,
                    style: TextStyle(color: color, fontSize: 20.0),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomCommissionView extends StatefulWidget {
  CustomCommissionView(
      {Key key, this.date, this.commission, this.getCommissionFunction, this.hasEditButton})
      : super(key: key);
  final DateTime date;
  final Commission commission;
  final Function getCommissionFunction;
  final bool hasEditButton;


  @override
  _CustomCommissionViewState createState() => _CustomCommissionViewState();
}

class _CustomCommissionViewState extends State<CustomCommissionView> {
  Commission commission;

  Future<Null> _openEditCommissionDialog() async {
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return EditDataView(
                title: "Edit Comission",
                date: getDateOnly(widget.date),
                commission: commission,
              );
            },
            fullscreenDialog: true));
  }

  Widget _buildDataView(Commission commission) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: TotalView(
            commission: commission,
            color: Colors.black,
          ),
        ),
        Flexible(
          flex: 6,
          child: CustomSummaryView(
            commission: commission,
            onTapEdit: widget.hasEditButton ? _openEditCommissionDialog : null,
            date: widget.date,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    EmployerService employerService =
        Provider.of<EmployerService>(context, listen: false);
    return FutureBuilder(
      future: widget.getCommissionFunction(
          employerService.currentEmployer, widget.date),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            commission = snapshot.data;
            return _buildDataView(commission);
          case ConnectionState.waiting:
            return Center(child: PlatformLoadingIndicator());
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              return Text('Result: ${snapshot.data}');
        }
      },
    );
  }
}


class CustomSummaryView extends StatelessWidget {
  CustomSummaryView({Key key, this.commission, this.date, this.onTapEdit})
      : super(key: key);
  final Commission commission;
  final DateTime date;
  final Function onTapEdit;

  Widget _buildEditButton(){
    if(onTapEdit == null){
      return Container(height: 0);
    }
    return CustomButtonBar(
            onTap: onTapEdit,
            text: 'Edit',
          );
  }

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
          _buildEditButton()
        ],
      ),
    );
  }
}


class SmallDetailsView extends StatelessWidget {
  SmallDetailsView({Key key, this.amount, this.type}) : super(key: key);
  final String type;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(type,
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 10.0)),
        Container(
          margin: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '\$ ',
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark, fontSize: 10.0),
              ),
              Text(
                amount.toInt().toString(),
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark, fontSize: 20.0),
              ),
              Container(
                  alignment: AlignmentDirectional.topEnd,
                  child: Text(
                    (amount % 1 * 10).toInt().toString().padLeft(2, '0'),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 10.0),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
