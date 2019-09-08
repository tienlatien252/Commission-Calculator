import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_picker/flutter_picker.dart';

import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/calculator_page/small_commisison_widget.dart';
import 'package:Calmission/calculator_page/time_range_picker_widget.dart';
import 'package:Calmission/services/commission_service.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';
import 'package:Calmission/common_widgets/custom_commission_data_view.dart';
import 'package:Calmission/common_widgets/date_time_widgets.dart';
import 'package:Calmission/common_widgets/comission_chart.dart';

class SliverTopBarDelegate extends SliverPersistentHeaderDelegate {
  SliverTopBarDelegate(this._timeRangePicker);
  final TimeRangePickerView _timeRangePicker;

  @override
  double get minExtent => 130.0;
  @override
  double get maxExtent => 130.0;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.grey[200],child: _timeRangePicker);
  }

  @override
  bool shouldRebuild(SliverTopBarDelegate oldDelegate) {
    return true;
  }
}

class CalculatorPage extends StatefulWidget {
  CalculatorPage({Key key}) : super(key: key);
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  Commission totalCommission =
      Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);
  List<Commission> listCommissions;

  showPickerStartDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(value: startDate, maxValue: DateTime.now()),
        title: Text("Select Date"),
        selectedTextStyle: TextStyle(color: Theme.of(context).primaryColorDark),
        onConfirm: (Picker picker, List value) {
          DateTime datePicked = (picker.adapter as DateTimePickerAdapter).value;
          if (datePicked != null && datePicked != startDate) {
            setState(() {
              startDate = datePicked;
              if(endDate.compareTo(startDate) < 0){
                endDate = startDate;
              }
            });
          }
        }).showDialog(context);
  }

  showPickerEndDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(
            value: endDate, maxValue: DateTime.now()),
        title: Text("Select Date"),
        selectedTextStyle: TextStyle(color: Theme.of(context).primaryColorDark),
        onConfirm: (Picker picker, List value) {
          DateTime datePicked = (picker.adapter as DateTimePickerAdapter).value;
          if (datePicked != null && datePicked != endDate) {
            setState(() {
              endDate = datePicked;
              if(startDate.compareTo(endDate) > 0){
                startDate = endDate;
              }
            });
          }
        }).showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            "Calculator",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverTopBarDelegate(
                      TimeRangePickerView(
                        onPickStartDate: () => showPickerStartDate(context),
                        onPickEndDate: () => showPickerEndDate(context),
                        startDate: startDate,
                        endDate: endDate,
                      ),
                    )),
              ];
            },
            body: DataCalculatedView(
              startDate: startDate,
              endDate: endDate,
            )));
  }
}

class DataCalculatedView extends StatelessWidget {
  DataCalculatedView({Key key, this.startDate, this.endDate}) : super(key: key);
  final DateTime startDate;
  final DateTime endDate;

  Widget dataBuilder(
      BuildContext context, int index, List<Commission> listCommissions) {
    if (index == 0) {
      return SummaryView(
        commission: listCommissions[0],
      );
    }
    return Container(
      decoration: ShapeDecoration(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        color: Colors.white,
      ),
      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
      child: ExpansionTile(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ShorterOneDayView(
                date: listCommissions[index].date,
                textColor: Colors.black//Theme.of(context).primaryColorDark,
              ),
            ]),
        children: <Widget>[
          SmallCommissionsView(
            commission: listCommissions[index],
            stringColor: Colors.black87,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Commission> listCommissions;
    EmployerService employerService =
        Provider.of<EmployerService>(context, listen: false);
    return FutureBuilder(
      future: getRangeCommission(
          employerService.currentEmployer, startDate, endDate),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            Map map = snapshot.data;
            listCommissions = map['listCommissions'];
            return ListView.builder(
              shrinkWrap: true,
              itemCount: listCommissions.length,
              itemBuilder: (BuildContext context, int index) =>
                  dataBuilder(context, index, listCommissions),
            );

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

class SummaryView extends StatelessWidget {
  SummaryView({Key key, this.commission}) : super(key: key);
  final Commission commission;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(7.0)),
      height: 400,
      child: Column(
        children: <Widget>[
         TotalView(
            commission: commission,
            color: Colors.black,
          ),
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
        ],
      ),
    );
  }
}
