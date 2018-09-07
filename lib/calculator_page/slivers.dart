import 'package:flutter/material.dart';

import 'calculator_page.dart';
import 'small_commisison_widget.dart';
import 'time_range_picker_widget.dart';

class SliverTopBarDelegate extends SliverPersistentHeaderDelegate {
  SliverTopBarDelegate(this._timeRangePicker, {this.viewModel});
  final TimeRangePickerView _timeRangePicker;
  final CalculatorPageViewModel viewModel;

  @override
  double get minExtent => 200.0;
  @override
  double get maxExtent => 200.0;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)
            // borderRadius: new BorderRadius.only(
            //     bottomLeft: const Radius.circular(10.0),
            //     bottomRight: const Radius.circular(10.0))
            ),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(children: <Widget>[
        Container(
            alignment: AlignmentDirectional.centerStart,
            padding: EdgeInsets.fromLTRB(20.0, 7.0, 10.0, 8.0),
            child: Text(
              viewModel.currentEmployer.name,
              style: TextStyle(fontSize: 40.0, color: Colors.white),
            )),
        _timeRangePicker
      ]),
    );
  }

  @override
  bool shouldRebuild(SliverTopBarDelegate oldDelegate) {
    return false;
  }
}

class SliverResultDelegate extends SliverPersistentHeaderDelegate {
  SliverResultDelegate(this.resultCommission);
  final SmallCommissionsView resultCommission;

  @override
  double get minExtent => 150.0;
  @override
  double get maxExtent => 150.0;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          //border: Border.all(color: Theme.of(context).primaryColorLight, width: 0.5),
          // boxShadow: [
          //   BoxShadow(
          //     //color: Colors.grey,
          //     color: Theme.of(context).primaryColorDark,
          //     blurRadius: 5.0
          //   )
          // ],
          color: Colors.white,
          //color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        children: <Widget>[
          Text(
            'Result',
            style: TextStyle(
                fontSize: 30.0,
                color: Theme.of(context)
                    .textSelectionColor //color: Theme.of(context).primaryColorDark
                ),
          ),
          Container(child: resultCommission),
          //Text('Detail', style: TextStyle(fontSize: 25.0))
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(SliverResultDelegate oldDelegate) {
    return false;
  }
}
