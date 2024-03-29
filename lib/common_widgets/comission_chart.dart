/// Partial pie chart example, where the data does not cover a full revolution
/// in the chart.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:Calmission/services/commission_service.dart';

class CommissionChart extends StatelessWidget {
  final Commission commission;
  final bool animate;
  final Color color;

  CommissionChart({this.animate, @required this.commission, this.color});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Money, String>> data = _createSeriesListFromCommission();
    return charts.BarChart(
      data,
      animate: animate,
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      //domainAxis:
      //    new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
    );
  }

  List<charts.Series<Money, String>> _createSeriesListFromCommission() {
    final data = [
      new Money('Raw', commission.raw),
      new Money('Commission', commission.commission),
      new Money('Tip', commission.tip),
      new Money('Total', commission.total),
    ];

    return [
      new charts.Series<Money, String>(
        id: 'Sales',
        domainFn: (Money sales, _) => sales.type,
        measureFn: (Money sales, _) => sales.amount,
        colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
        data: data,
        labelAccessorFn: (Money sales, _) => '\$${sales.amount.toString()}',
      ),
    ];
  }
}

class CommissionPieChart extends StatelessWidget {
  final Commission commission;
  final bool animate;
  final Color color;

  CommissionPieChart({this.animate, @required this.commission, this.color});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Money, String>> data = _createSeriesListFromCommission();
    if (commission.commission != 0 && commission.tip != 0) {
      return charts.PieChart(data,
          animate: animate,
          defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
            new charts.ArcLabelDecorator(
                labelPosition: charts.ArcLabelPosition.inside)
          ]));
    }
    data = _createEmptyListFromCommission();
    return charts.PieChart(data,
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.inside)
        ]));
  }

  charts.Color _getColor(Money money, int index) {
    if (money.type == 'Commission') {
      return charts.MaterialPalette.teal.shadeDefault;
    }
    //charts.Color
    return charts.MaterialPalette.teal.shadeDefault.lighter;
  }

  List<charts.Series<Money, String>> _createEmptyListFromCommission() {
    final data = [
      new Money('total', 2.0),
    ];

    return [
      new charts.Series<Money, String>(
        id: 'Sales',
        domainFn: (Money sales, _) => sales.type,
        measureFn: (Money sales, _) => sales.amount,
        colorFn: (Money sales, _) => charts.MaterialPalette.transparent,
        data: data,
        labelAccessorFn: (Money sales, _) => '\$ ${sales.amount.toString()}',
      ),
    ];
  }

  List<charts.Series<Money, String>> _createSeriesListFromCommission() {
    final data = [
      new Money('Commission', commission.commission),
      new Money('Tip', commission.tip),
    ];

    return [
      new charts.Series<Money, String>(
        id: 'Sales',
        domainFn: (Money sales, _) => sales.type,
        measureFn: (Money sales, _) => sales.amount,
        colorFn: _getColor,
        data: data,
        labelAccessorFn: (Money sales, _) => '\$ ${sales.amount.toString()}',
      ),
    ];
  }
}

class Money {
  final String type;
  final double amount;

  Money(this.type, this.amount);
}
