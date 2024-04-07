import 'package:babysteps/app/pages/tracking/additional_streams.dart';
import 'package:babysteps/app/pages/tracking/diaper/diaper_database.dart';
import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:babysteps/app/pages/tracking/sleep/sleep_database.dart';
import 'package:babysteps/app/pages/tracking/temperature/temperature_database.dart';
import 'package:babysteps/app/pages/tracking/weight/weight_database.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/pages/tracking/history_streams.dart';
import 'package:babysteps/app/pages/tracking/all_time_history_streams.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:core';

// The history dropdown widget
class HistoryDropdown extends StatelessWidget {
  HistoryDropdown(this.trackingPage, {super.key});

  var trackingPage;

  var recentStream;
  var allTimeStream;
  var additionalStream = null; // Currently the only additional stream is diarrhea


  @override
  Widget build(BuildContext context) {
    switch (trackingPage) {
    case 'diaper':
      recentStream = const DiaperHistoryStream();
      allTimeStream = const DiaperAllTimeStream();
      additionalStream = const DiaperDiarrheaStream();
      break;
    case 'bottle':
      recentStream = const BottleHistoryStream();
      allTimeStream = const BottleFeedingAllTimeStream();
      break;
    case 'breastfeeding':
      recentStream = const BreastfeedingHistoryStream();
      allTimeStream = const BreastfeedingAllTimeStream();
      break;
    case 'sleep':
      recentStream = const SleepHistoryStream();
      allTimeStream = const SleepAllTimeStream();
      break;
    case 'temperature':
      recentStream = const TemperatureHistoryStream();
      allTimeStream = const TemperatureAllTimeStream();
      break;
    case 'weight':
      recentStream = const WeightHistoryStream();
      allTimeStream = const WeightAllTimeStream();
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
                    child: HistoryTabs(recentStream, allTimeStream, additionalStream)
                  ),
                ],
              ),
            );
  }
}

// The tab options inside history - recent and all-time, and optional additionalStream
// sources: https://docs.flutter.dev/cookbook/design/tabs
// https://www.flutterbeads.com/change-tab-bar-color-in-flutter/
class HistoryTabs extends StatelessWidget {
  HistoryTabs(this.recentStream, this.allTimeStream, this.additionalStream, {super.key});

  var recentStream;
  var allTimeStream;
  var additionalStream;

  @override
  Widget build(BuildContext context) {
    
    // Set up for an additional tab
    int numTabs = 2;
    List<Tab> tabs = const [
      Tab(text: 'Recent'),
      Tab(text: 'All-time'),
    ];
    List<Widget> tabBarView = [recentStream, allTimeStream];

    if (additionalStream != null) {
      numTabs = 3;
      tabs = const [
        Tab(text: 'Recent'),
        Tab(text: 'All-time'),
        Tab(text: 'Diarrhea'),
      ];
      tabBarView = [recentStream, allTimeStream, additionalStream];
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: numTabs, // Number of tabs 
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize( // Need this to let us set colors for some reason 
              preferredSize: const Size.fromHeight(0), // Size 0 gets rid of the gap between the top and the tabs
              child: Material(
                color: Theme.of(context).colorScheme.secondary, 
                
                // Tab bar
                child: TabBar(
                  indicatorColor: Theme.of(context).colorScheme.primary, // Color of selected tab
                  labelColor: Theme.of(context).colorScheme.onSecondary, 
                  tabs: tabs,
                ),
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),

          // The stuff displayed when the tab is selected
          body: TabBarView( 
            // Goes in order - first goes with first tab, second with second
            children: tabBarView,
          ),
        ),
      ),
    );
  }
}

// Represents an (x,y) pair for the TimeSeries widget for the all-time history
class ChartData {
  ChartData({this.x, this.yValue});

  final DateTime? x;
  final double? yValue;
}

// The graph for all-time history when there is one line 
class TimeSeriesWidget extends StatelessWidget {
  TimeSeriesWidget(this.entries, this.chartTitle, this.yAxisTitle, {super.key});

  Map<DateTime, double> entries;
  String chartTitle;
  String yAxisTitle;

  List<ChartData> chartData = <ChartData>[];

  @override
  Widget build(BuildContext context) {

    for (var date in entries.keys) {
      double? value = entries[date];
      chartData.add(ChartData(x: date, yValue: value));
      }

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
                  majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  intervalType: DateTimeIntervalType.days),
                primaryYAxis: NumericAxis(title: AxisTitle(text: yAxisTitle),),
                series:<CartesianSeries>[
                  LineSeries<ChartData, DateTime>(
                    dataSource: chartData,
                    color: const Color(0xFF0D4B5F),
                    markerSettings: const MarkerSettings(isVisible: true, ),
                    xValueMapper: (ChartData entries, _) => entries.x,
                    yValueMapper: (ChartData entries, _) => entries.yValue,
                    name: 'Entries',
                  )
                ]
                )),
        ));
  }
}

// The graph for all-time history when there are multiple lines
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

    for (var date in entries1.keys) {
      double? value = entries1[date];
      chartData1.add(ChartData(x: date, yValue: value));
      }
    for (var date in entries2.keys) {
      double? value = entries2[date];
      chartData2.add(ChartData(x: date, yValue: value));
      }

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
                  majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  intervalType: DateTimeIntervalType.days),
                primaryYAxis: NumericAxis(),
                legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  toggleSeriesVisibility: true, // Toggles the series visibility on tapping the legend item
                  // Note: When you remove one series, the axes adjust to fit the remaining series better
                  ),
                series: <CartesianSeries>[
                  LineSeries<ChartData, DateTime>(
                    dataSource: chartData1,
                    color: const Color(0xFF0D4B5F),
                    markerSettings: const MarkerSettings(isVisible: true, ),
                    xValueMapper: (ChartData entries, _) => entries.x,
                    yValueMapper: (ChartData entries, _) => entries.yValue,
                    name: yAxis1,
                  ),
                  LineSeries<ChartData, DateTime>(
                    dataSource: chartData2,
                    color: const Color(0xFFF2BB9B),
                    markerSettings: const MarkerSettings(isVisible: true, ),
                    xValueMapper: (ChartData entries, _) => entries.x,
                    yValueMapper: (ChartData entries, _) => entries.yValue,
                    name: yAxis2,
                  )
                ]
                )),
        ));
  }
}

// Recent history table with 3 columns, column titles, and rows of data filled in
class HistoryTable3Cols extends StatefulWidget {
  String dataType;
  var rows;
  String colName;

  HistoryTable3Cols(this.dataType, this.rows, this.colName, {super.key});

  @override
  State<HistoryTable3Cols> createState() => _HistoryTable3Cols();
}

class _HistoryTable3Cols extends State<HistoryTable3Cols> {

  /// Deletes a row of the 3 column table when the row is long pressed
  void deleteRow(String dataType, String docId) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: const Color(0xFFB3BEB6),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Do you want to delete this data entry?",
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 20,
                      ),
                    ),
                  ),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                          onPressed: () async {
                            if(dataType == "Sleep") {
                              await SleepDatabaseMethods().deleteSleep(
                                docId,
                                currentUser.value!.currentBaby.value!
                                    .collectionId);
                            } else if (dataType == "Weight") {
                              await WeightDatabaseMethods().deleteWeight(
                                docId,
                                currentUser.value!.currentBaby.value!
                                    .collectionId);
                            } else if (dataType == "Temperature") {
                              await TemperatureDatabaseMethods().deleteTemperature(
                                docId,
                                currentUser.value!.currentBaby.value!
                                    .collectionId);
                            } else {
                              print("Error: Trying to delete the wrong dataType.");
                            }
                            Navigator.of(context, rootNavigator: true).pop();
                          }, 
                          // style is hard-coded blue button style
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color(0xFF4F646F)),
                            foregroundColor: MaterialStateProperty.all(const Color(0xFFFFFAF1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color(0xFF4F646F)),
                          foregroundColor: MaterialStateProperty.all(const Color(0xFFFFFAF1)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ],)
            )
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    // Source: https://api.flutter.dev/flutter/material/DataTable-class.html
    return DataTable(
      columns: <DataColumn>[
        // Table column titles
        const DataColumn(
          label: Expanded(
            child: Text(
              'Date',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        const DataColumn(
          label: Expanded(
            child: Text(
              'Time',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              widget.colName,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      // Table rows - dynamic - For each row we collected data for, create a DataCell for it
      // TODO: Some sort of "no history yet" message if there are no entries
      rows: <DataRow>[
        for (var row in widget.rows)
          DataRow(
            cells: <DataCell>[
              DataCell(Text(row.day)),
              DataCell(Text(row.time)),
              DataCell(Text(row.data)),
            ],
            onLongPress: () {
              deleteRow(widget.dataType, row.docId);
            },
          ),
      ],
    );
  }
}

// Recent history table with 4 columns, column titles, and data filled in
class HistoryTable4Cols extends StatefulWidget {
  String dataType;
  var rows;
  String col1Name;
  String col2Name;

  HistoryTable4Cols(this.dataType, this.rows, this.col1Name, this.col2Name, {super.key});

  @override
  State<HistoryTable4Cols> createState() => _HistoryTable4Cols();
}

class _HistoryTable4Cols extends State<HistoryTable4Cols> {

  /// Deletes a row of the 4 column table when the row is long pressed
  void deleteRow(String dataType, String docId) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: const Color(0xFFB3BEB6),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Do you want to delete this data entry?",
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 20,
                      ),
                    ),
                  ),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                          onPressed: () async {
                            if(dataType == "Bottle") {
                              await FeedingDatabaseMethods().deleteFeeding(
                                docId,
                                currentUser.value!.currentBaby.value!
                                    .collectionId);
                            } else {
                              print("Error: Trying to delete the wrong dataType.");
                            }
                            Navigator.of(context, rootNavigator: true).pop();
                          }, 
                          // style is hard-coded blue button style
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color(0xFF4F646F)),
                            foregroundColor: MaterialStateProperty.all(const Color(0xFFFFFAF1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color(0xFF4F646F)),
                          foregroundColor: MaterialStateProperty.all(const Color(0xFFFFFAF1)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ],)
            )
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    // Source: https://api.flutter.dev/flutter/material/DataTable-class.html
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView( // shouldn't need to scroll but just in case of small screen
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          columns: <DataColumn>[
            // Table column titles
            const DataColumn(
              label: Expanded(
                child: Text(
                  'Date',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: Expanded(
                child: Text(
                  'Time',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  widget.col1Name,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  widget.col2Name,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
          // Table rows - dynamic - For each row we collected data for, create a DataCell for it
          // TODO: Some sort of "no history yet" message if there are no entries
          rows: <DataRow>[
            for (var row in widget.rows)
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(row.day)),
                  DataCell(Text(row.time)),
                  DataCell(Text(row.data1)),
                  DataCell(Text(row.data2))
                ],
                onLongPress: () {
                  deleteRow(widget.dataType, row.docId);
                },
              ),
          ],
        ),
      ),
    );
  }
}

// Recent history table with 4 columns, column titles, and data filled in
class HistoryTable5Cols extends StatefulWidget {
  String dataType;
  var rows;
  String col1Name;
  String col2Name;
  String col3Name;

  HistoryTable5Cols(this.dataType, this.rows, this.col1Name, this.col2Name, this.col3Name, {super.key});

  @override
  State<HistoryTable5Cols> createState() => _HistoryTable5Cols();
}

class _HistoryTable5Cols extends State<HistoryTable5Cols> {

  /// Deletes a row of the 5 column table when the row is long pressed
  void deleteRow(String dataType, String docId) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: const Color(0xFFB3BEB6),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Do you want to delete this data entry?",
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 20,
                      ),
                    ),
                  ),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                          onPressed: () async {
                            if(dataType == "Diaper") {
                              await DiaperDatabaseMethods().deleteDiaper(
                                docId,
                                currentUser.value!.currentBaby.value!
                                    .collectionId);
                            } else {
                              print("Error: Trying to delete the wrong dataType.");
                            }
                            Navigator.of(context, rootNavigator: true).pop();
                          }, 
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color(0xFF4F646F)),
                            foregroundColor: MaterialStateProperty.all(const Color(0xFFFFFAF1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),                      
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color(0xFF4F646F)),
                          foregroundColor: MaterialStateProperty.all(const Color(0xFFFFFAF1)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ],)
            )
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    // Source: https://api.flutter.dev/flutter/material/DataTable-class.html
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView( // shouldn't need to scroll but just in case of small screen
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          columns: <DataColumn>[
            // Table column titles
            const DataColumn(
              label: Expanded(
                child: Text(
                  'Date',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: Expanded(
                child: Text(
                  'Time',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  widget.col1Name,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  widget.col2Name,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  widget.col3Name,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
          // Table rows - dynamic - For each row we collected data for, create a DataCell for it
          // TODO: Some sort of "no history yet" message if there are no entries
          rows: <DataRow>[
            for (var row in widget.rows)
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(row.day)),
                  DataCell(Text(row.time)),
                  DataCell(Text(row.data1)),
                  DataCell(Text(row.data2)),
                  DataCell(Text(row.data3)),
                ],
                onLongPress: () {
                  deleteRow(widget.dataType, row.docId);
                },
              ),
          ],
        ),
      ),
    );
  }
}


// Recent history table with 6 columns, column titles, and data filled in
class HistoryTable6Cols extends StatefulWidget {
  String dataType;
  var rows;
  String col1Name;
  String col2Name;
  String col3Name;
  String col4Name;

  HistoryTable6Cols(this.dataType, this.rows, this.col1Name, this.col2Name, this.col3Name, this.col4Name, {super.key});

  @override
  State<HistoryTable6Cols> createState() => _HistoryTable6Cols();
}

class _HistoryTable6Cols extends State<HistoryTable6Cols> {

  final ScrollController _controller = ScrollController();

  /// Deletes a row of the 6 column table when the row is long pressed
  void deleteRow(String dataType, String docId) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: const Color(0xFFB3BEB6),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Do you want to delete this data entry?",
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 20,
                      ),
                    ),
                  ),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                          onPressed: () async {
                            if(dataType == "Breastfeed") {
                              await FeedingDatabaseMethods().deleteFeeding(
                                docId,
                                currentUser.value!.currentBaby.value!
                                    .collectionId);
                            } else {
                              print("Error: Trying to delete the wrong dataType.");
                            }
                            Navigator.of(context, rootNavigator: true).pop();
                          }, 
                          // style is hard-coded blue button style
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color(0xFF4F646F)),
                            foregroundColor: MaterialStateProperty.all(const Color(0xFFFFFAF1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color(0xFF4F646F)),
                          foregroundColor: MaterialStateProperty.all(const Color(0xFFFFFAF1)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ],)
            )
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    // Source: https://api.flutter.dev/flutter/material/DataTable-class.html
    return Scrollbar(
      thumbVisibility: true,
      controller: _controller,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        child: DataTable(
          columnSpacing: 20,
          columns: <DataColumn>[
            // Table column titles
            const DataColumn(
              label: Expanded(
                child: Text(
                  'Date',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: Expanded(
                child: Text(
                  'Time',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  widget.col1Name,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  widget.col2Name,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  widget.col3Name,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  widget.col4Name,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
          // Table rows - dynamic - For each row we collected data for, create a DataCell for it
          // TODO: Some sort of "no history yet" message if there are no entries
          rows: <DataRow>[
            for (var row in widget.rows)
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(row.day)),
                  DataCell(Text(row.time)),
                  DataCell(Text(row.data1)),
                  DataCell(Text(row.data2)),
                  DataCell(Text(row.data3)),
                  DataCell(Text(row.data4)),
                ],
                onLongPress: () {
                  deleteRow(widget.dataType, row.docId);
                },
              ),
          ],
        ),
      ),
    );
  }
}

// Represents the data shown in the history table when we only need 3 columns
class RowData3Cols<T1, T2, T3, T4> {
  T1 day;
  T2 time;
  T3 data;
  T4 docId;

  RowData3Cols(this.day, this.time, this.data, this.docId);
}

// Represents the data shown in the history table when we need 4 columns
class RowData4Cols<T1, T2, T3, T4, T5> {
  T1 day;
  T2 time;
  T3 data1;
  T4 data2;
  T5 docId;

  RowData4Cols(this.day, this.time, this.data1, this.data2, this.docId);
}

// Represents the data shown in the history table when we need 5 columns
class RowData5Cols<T1, T2, T3, T4, T5, T6> {
  T1 day;
  T2 time;
  T3 data1;
  T4 data2;
  T5 data3;
  T6 docId;

  RowData5Cols(this.day, this.time, this.data1, this.data2, this.data3, this.docId);
}

// Represents the data shown in the history table when we need 6 columns
class RowData6Cols<T1, T2, T3, T4, T5, T6, T7> {
  T1 day;
  T2 time;
  T3 data1;
  T4 data2;
  T5 data3; 
  T6 data4;
  T7 docId;

  RowData6Cols(this.day, this.time, this.data1, this.data2, this.data3, this.data4, this.docId);
}