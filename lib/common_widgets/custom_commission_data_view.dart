
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/commission_page/commission_data_view.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';
import 'package:Calmission/common_widgets/CustomButton.dart';
import 'package:Calmission/common_widgets/comission_chart.dart';
import 'package:Calmission/commission_page/edit_data_dialog.dart';



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
  final CommissionService commissionService = CommissionService();

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