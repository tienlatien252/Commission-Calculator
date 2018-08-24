import 'package:flutter/material.dart';

import 'calculator_page.dart';
import 'small_commisison_widget.dart';
import 'time_range_picker_widget.dart';

class SliverTopBarDelegate extends SliverPersistentHeaderDelegate {
  SliverTopBarDelegate(this._timeRangePicker, {this.viewModel});
  final TimeRangePickerView _timeRangePicker;
  final CalculatorPageViewModel viewModel;

  @override
  double get minExtent => 165.0;
  @override
  double get maxExtent => 165.0;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                bottomLeft: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0))),
        color: Theme.of(context).primaryColorDark,
      ),
      child: Column(children: <Widget>[
        Container(
            alignment: AlignmentDirectional.centerStart,
            padding: EdgeInsets.fromLTRB(10.0, 17.0, 10.0, 17.0),
            child: Text(
              viewModel.currentEmployer.name,
              style: TextStyle(fontSize: 30.0),
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
  double get minExtent => 130.0;
  @override
  double get maxExtent => 130.0;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        children: <Widget>[
          Text(
            'Result',
            style: TextStyle(fontSize: 25.0),
          ),
          resultCommission,
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
