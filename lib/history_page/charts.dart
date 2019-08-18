/// Partial pie chart example, where the data does not cover a full revolution
/// in the chart.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/common_widgets/date_time_widgets.dart';
import 'package:Calmission/common_widgets/CustomButton.dart';

class TestView extends StatefulWidget {
  TestView({Key key}) : super(key: key);
  @override
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  final DateTime date = DateTime.now();
  // Commission commission =
  //     Commission(raw: 0.0, commission: 0.0, tip: 0.0, total: 0.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            children: <Widget>[
              Container(
                  alignment: AlignmentDirectional.centerStart,
                  padding: EdgeInsets.fromLTRB(20.0, 17.0, 10.0, 17.0),
                  child: Consumer<EmployerService>(builder:
                      (BuildContext context, EmployerService employerService,
                          __) {
                    Employer employer = employerService.currentEmployer;
                    String employerName = '';
                    if (employer != null) {
                      employerName = employer.name;
                    }
                    return Text(
                      employerName,
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    );
                  })),
              Container(
                alignment: AlignmentDirectional.centerStart,
                padding: EdgeInsets.fromLTRB(20.0, 13.0, 10.0, 13.0),
                child: OneDayView(
                  date: date,
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Expanded(
                      child:
                          HorizontalBarLabelCustomChart.createWithSampleData()),
                  Container(
                    alignment: AlignmentDirectional.bottomEnd,
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                    child: CustomTextButton(
                      label: 'Edit',
                    ),
                  )
                ])))
      ],
    );
  }
}

class HorizontalBarLabelCustomChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  HorizontalBarLabelCustomChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  static HorizontalBarLabelCustomChart createWithSampleData() {
    return new HorizontalBarLabelCustomChart(
      _createMySampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }

  // The [BarLabelDecorator] has settings to set the text style for all labels
  // for inside the bar and outside the bar. To be able to control each datum's
  // style, set the style accessor functions on the series.
  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      //domainAxis:
      //    new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
    );
  }

  static List<charts.Series<Money, String>> _createMySampleData() {
    final data = [
      new Money('Raw', 200),
      new Money('Commission', 120),
      new Money('Tip', 40),
      new Money('Total', 160),
    ];

    return [
      new charts.Series<Money, String>(
        id: 'Sales',
        domainFn: (Money sales, _) => sales.type,
        measureFn: (Money sales, _) => sales.amount,
        data: data,
        labelAccessorFn: (Money sales, _) => '\$${sales.amount.toString()}',
      ),
    ];
  }
}

class Money {
  final String type;
  final double amount;

  Money(this.type, this.amount);
}
