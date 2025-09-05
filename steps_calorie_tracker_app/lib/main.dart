import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: StepTracker(toggleTheme: toggleTheme),
    );
  }
}

class StepTracker extends StatefulWidget {
  final VoidCallback toggleTheme;
  StepTracker({required this.toggleTheme});

  @override
  _StepTrackerState createState() => _StepTrackerState();
}

class _StepTrackerState extends State<StepTracker> {
  TextEditingController stepsController = TextEditingController();
  List<Map<String, dynamic>> progressData = [];

  void addProgress() {
    String stepsText = stepsController.text;
    if (stepsText.isEmpty) return;

    try {
      int steps = int.parse(stepsText);
      double caloriesBurned = steps * 0.04; // Approximate calculation

      setState(() {
        progressData.add({
          "steps": steps,
          "calories": caloriesBurned,
        });
      });

      stepsController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid input! Enter a number.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Steps & Calorie Tracker", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter Steps:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
              controller: stepsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Steps Taken",
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addProgress,
              child: Text("Add Progress"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Expanded(child: buildProgressChart()),
            Expanded(child: buildDataTable()),
          ],
        ),
      ),
    );
  }

  Widget buildProgressChart() {
    return progressData.isEmpty
        ? Center(child: Text("No data yet", style: TextStyle(fontSize: 18)))
        : LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()} kcal', style: TextStyle(fontSize: 12));
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Text('Day ${value.toInt() + 1}', style: TextStyle(fontSize: 12));
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: progressData.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value["calories"]);
                  }).toList(),
                  isCurved: true,
                  color: Colors.teal,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          );
  }

  Widget buildDataTable() {
    return progressData.isEmpty
        ? Center(child: Text("No data yet", style: TextStyle(fontSize: 18)))
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              columns: [
                DataColumn(label: Text("Steps", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Calories Burned", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: progressData.map((data) {
                return DataRow(cells: [
                  DataCell(Text(data["steps"].toString())),
                  DataCell(Text(data["calories"].toStringAsFixed(2))),
                ]);
              }).toList(),
            ),
          );
  }
}
