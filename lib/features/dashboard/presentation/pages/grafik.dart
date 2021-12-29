import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40),
  ];

  final List<ChartData> chartData = [
    ChartData('John', 10),
    ChartData('David', 9),
    ChartData('Brit', 10),
  ];

  final List<ChartData> chartData2 = [
    ChartData('Anto', 11),
    ChartData('Peter', 12),
    ChartData('Parker', 8),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Testing Chart"),
        ),
        body: Center(
            child: Container(
                height: 500,
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                        // Axis will be rendered based on the index values
                        arrangeByIndex: true),
                    series: <ChartSeries<ChartData, String>>[
                      ColumnSeries<ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (ChartData sales, _) => sales.x,
                        yValueMapper: (ChartData sales, _) => sales.y,
                      ),
                      ColumnSeries<ChartData, String>(
                        dataSource: chartData2,
                        xValueMapper: (ChartData sales, _) => sales.x,
                        yValueMapper: (ChartData sales, _) => sales.y,
                      )
                    ]))));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class SalesData {
  SalesData(this.year, this.sales);
  final double year;
  final double sales;
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
