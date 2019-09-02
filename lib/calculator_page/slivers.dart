import 'package:flutter/material.dart';

import 'calculator_page.dart';
import 'small_commisison_widget.dart';
import 'time_range_picker_widget.dart';
import 'package:Calmission/common_widgets/custom_commission_data_view.dart';


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