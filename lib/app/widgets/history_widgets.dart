import 'package:flutter/material.dart';
import 'package:babysteps/app/pages/tracking/history_streams.dart';
import 'package:babysteps/app/pages/tracking/all_time_history_streams.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Pair<T1, T2> {
  final T1 x;
  final T2 y;

  Pair(this.x, this.y);
}

class ChartData {
  ChartData({this.x, this.yValue});

  final DateTime? x;
  final double? yValue;
}


class HistoryDropdown extends StatelessWidget {
  HistoryDropdown(this.trackingPage, {super.key});

  var trackingPage;

  var recentStream;
  var allTimeStream;


  @override
  Widget build(BuildContext context) {
    switch (trackingPage) {
    case 'diaper':
      recentStream = DiaperHistoryStream();
      allTimeStream = DiaperAllTimeStream();
      break;
    case 'bottle':
      recentStream = BottleHistoryStream();
      allTimeStream = BottleFeedingAllTimeStream();
      break;
    case 'breastfeeding':
      recentStream = BreastfeedingHistoryStream();
      allTimeStream = BreastfeedingAllTimeStream();
      break;
    case 'sleep':
      recentStream = SleepHistoryStream();
      allTimeStream = SleepAllTimeStream();
      break;
    case 'temperature':
      recentStream = TemperatureHistoryStream();
      allTimeStream = TemperatureAllTimeStream();
      break;
    case 'weight':
      recentStream = WeightHistoryStream();
      allTimeStream = WeightAllTimeStream();
      break;
  }
    return Padding(
              padding: const EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: Theme.of(context).colorScheme.surface,
                collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
                title: Text('History',
                      style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold)),
                initiallyExpanded: false,
                children: <Widget>[
                  SizedBox(
                    height: 400, // TODO edit this to be sized based on space, not set value
                    child: HistoryTabs(recentStream, allTimeStream)
                  ),
                ],
              ),
            );
  }
}


// sources: https://docs.flutter.dev/cookbook/design/tabs
// https://www.flutterbeads.com/change-tab-bar-color-in-flutter/
class HistoryTabs extends StatelessWidget {
  HistoryTabs(this.recentStream, this.allTimeStream, {super.key});

  var recentStream;
  var allTimeStream;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2, // Number of tabs 
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize( // Need this to let us set colors for some reason 
              preferredSize: Size.fromHeight(0), // Size 0 gets rid of the gap between the top and the tabs
              child: Material(
                color: Theme.of(context).colorScheme.primary, 
                
                // Tab bar
                child: TabBar(
                  indicatorColor: Theme.of(context).colorScheme.secondary, // Color of selected tab
                  labelColor: Theme.of(context).colorScheme.onPrimary,
                  tabs: [
                    Tab(text: 'Recent'),
                    Tab(text: 'All-time'),
                  ],
                ),
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),

          // The stuff displayed when the tab is selected
          body: TabBarView( 
            children: [
              // Goes in order - first goes with first tab, second with second
              recentStream,
              allTimeStream,
            ],
          ),
        ),
      ),
    );
  }
}


class TimeSeriesWidget extends StatelessWidget {
  TimeSeriesWidget(this.entries, this.chartTitle, this.yAxisTitle, {super.key});

  Map<DateTime, double> entries;
  String chartTitle;
  String yAxisTitle;

  List<ChartData> chartData = <ChartData>[];

  @override
  Widget build(BuildContext context) {

    entries.keys.forEach((date) {
      double? value = entries[date];
      chartData.add(ChartData(x: date, yValue: value));
      }
    );

    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Syncfusion Flutter chart'),
        // ),
        body: Center(
          //Initialize the chart widget
          child: Container(
              padding: const EdgeInsets.all(25),
              child: SfCartesianChart(
                title: ChartTitle(
                  text: chartTitle,
                ),
                // zoomPanBehavior: _zoomPanBehavior, // TODO
                backgroundColor: Colors.white,
                primaryXAxis: DateTimeAxis(
                  title: AxisTitle(text: 'Date'),
                  majorGridLines: MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  intervalType: DateTimeIntervalType.days),
                primaryYAxis: NumericAxis(title: AxisTitle(text: yAxisTitle),),
                series:<CartesianSeries>[
                  LineSeries<ChartData, DateTime>(
                    dataSource: chartData,
                    color: Color(0xFF0D4B5F),
                    markerSettings: MarkerSettings(isVisible: true, ),
                    xValueMapper: (ChartData entries, _) => entries.x,
                    yValueMapper: (ChartData entries, _) => entries.yValue,
                    name: 'Entries',
                  )
                ]
                )),
        ));
  }
}

class StackedTimeSeriesWidget extends StatelessWidget {
  StackedTimeSeriesWidget(this.entries1, this.entries2, this.chartTitle, this.yAxis1, this.yAxis2, {super.key});

  Map<DateTime, double> entries1;
  Map<DateTime, double> entries2;
  String chartTitle;
  String yAxis1;
  String yAxis2;


  List<ChartData> chartData1 = <ChartData>[];
  List<ChartData> chartData2 = <ChartData>[];

  @override
  Widget build(BuildContext context) {

    entries1.keys.forEach((date) {
      double? value = entries1[date];
      chartData1.add(ChartData(x: date, yValue: value));
      }
    );
    entries2.keys.forEach((date) {
      double? value = entries2[date];
      chartData2.add(ChartData(x: date, yValue: value));
      }
    );

    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Syncfusion Flutter chart'),
        // ),
        body: Center(
          //Initialize the chart widget
          child: Container(
              padding: const EdgeInsets.all(25),
              child: SfCartesianChart(
                title: ChartTitle(
                  text: chartTitle,
                ),
                // zoomPanBehavior: _zoomPanBehavior, // TODO
                backgroundColor: Colors.white,
                primaryXAxis: DateTimeAxis(
                  majorGridLines: MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  intervalType: DateTimeIntervalType.days),
                primaryYAxis: NumericAxis(),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  toggleSeriesVisibility: true, // Toggles the series visibility on tapping the legend item
                  // Note: When you remove one series, the axes adjust to fit the remaining series better
                  ),
                series: <CartesianSeries>[
                  LineSeries<ChartData, DateTime>(
                    dataSource: chartData1,
                    color: Color(0xFF0D4B5F),
                    markerSettings: MarkerSettings(isVisible: true, ),
                    xValueMapper: (ChartData entries, _) => entries.x,
                    yValueMapper: (ChartData entries, _) => entries.yValue,
                    name: yAxis1,
                  ),
                  LineSeries<ChartData, DateTime>(
                    dataSource: chartData2,
                    color: Color(0xFFF2BB9B),
                    markerSettings: MarkerSettings(isVisible: true, ),
                    xValueMapper: (ChartData entries, _) => entries.x,
                    yValueMapper: (ChartData entries, _) => entries.yValue,
                    name: yAxis2,
                  )
                ]
                )),
        ));
  }
}