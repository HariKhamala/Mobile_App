import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system; // Default system theme

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
      home: CalorieCalculator(toggleTheme: toggleTheme),
    );
  }
}

class CalorieCalculator extends StatefulWidget {
  final VoidCallback toggleTheme;

  CalorieCalculator({required this.toggleTheme});

  @override
  _CalorieCalculatorState createState() => _CalorieCalculatorState();
}

class _CalorieCalculatorState extends State<CalorieCalculator> {
  TextEditingController weightController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  
  String selectedActivity = "Running";
  double caloriesBurned = 0.0;
  List<Map<String, dynamic>> history = [];

  Map<String, double> activityMET = {
    "Running": 9.8,
    "Walking": 3.5,
    "Cycling": 7.5,
    "Swimming": 8.0,
  };

  void calculateCalories() {
    String weightText = weightController.text;
    String durationText = durationController.text;

    if (weightText.isEmpty || durationText.isEmpty) return;

    try {
      double weight = double.parse(weightText);
      double duration = double.parse(durationText);
      double met = activityMET[selectedActivity] ?? 1.0;
      
      double burned = (met * weight * duration) / 60;
      
      setState(() {
        caloriesBurned = burned;
        history.add({
          "weight": weight,
          "activity": selectedActivity,
          "duration": duration,
          "calories": burned,
        });
      });
    } catch (e) {
      setState(() {
        caloriesBurned = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calories Calculator"),
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
          children: [
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Your Weight (kg)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedActivity,
              onChanged: (String? newValue) {
                setState(() {
                  selectedActivity = newValue!;
                });
              },
              items: activityMET.keys.map((String activity) {
                return DropdownMenuItem<String>(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Duration (minutes)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: calculateCalories,
              child: Text("Calculate Calories"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange, // Custom color
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Calories Burned: ${caloriesBurned.toStringAsFixed(2)} kcal",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            SizedBox(height: 20),
            Expanded(child: buildDataTable()),
          ],
        ),
      ),
    );
  }

  Widget buildDataTable() {
    return history.isEmpty
        ? Center(child: Text("No data yet"))
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 10,
              columns: [
                DataColumn(label: Text("Weight (kg)")),
                DataColumn(label: Text("Activity")),
                DataColumn(label: Text("Duration (min)")),
                DataColumn(label: Text("Calories Burned")),
              ],
              rows: history.map((data) {
                return DataRow(cells: [
                  DataCell(Text(data["weight"].toString())),
                  DataCell(Text(data["activity"])),
                  DataCell(Text(data["duration"].toString())),
                  DataCell(Text(data["calories"].toStringAsFixed(2))),
                ]);
              }).toList(),
            ),
          );
  }
}
