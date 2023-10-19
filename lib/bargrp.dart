import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _PageGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(1, 35),
      ChartData(2, 23),
      ChartData(3, 34),
      ChartData(4, 25),
      ChartData(5, 40)
    ];
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
                    series: <ChartSeries>[
                      BarSeries<ChartData, double>(
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          // Width of the bars
                          width: 0.6,
                          // Spacing between the bars
                          spacing: 0.3
                      )
                    ]
                )
            )
        )
    );
  }
}

class ChartData {
  final double x;
  final double y;

  ChartData(this.x, this.y);
}
