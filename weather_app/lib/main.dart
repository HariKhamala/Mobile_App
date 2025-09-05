import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system; // Default to system theme

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
      themeMode: _themeMode, // Dynamic theme
      home: WeatherApp(toggleTheme: toggleTheme),
    );
  }
}
class WeatherApp extends StatefulWidget {
  final VoidCallback toggleTheme; // Function to toggle theme

  WeatherApp({required this.toggleTheme});

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  TextEditingController timeController = TextEditingController();
  String selectedCountry = 'USA';
  String convertedTime = '';

  Map<String, int> timeZoneOffsets = {
    'USA': -5,
    'India': 5,
    'UK': 0,
    'Australia': 10,
  };

  void convertTime() {
    String inputTime = timeController.text;
    if (inputTime.isEmpty) return;

    try {
      DateTime inputDateTime = DateFormat("HH:mm").parse(inputTime);
      int offset = timeZoneOffsets[selectedCountry] ?? 0;
      DateTime convertedDateTime = inputDateTime.add(Duration(hours: offset));
      String outputTime = DateFormat("HH:mm").format(convertedDateTime);

      setState(() {
        convertedTime = outputTime;
      });
    } catch (e) {
      setState(() {
        convertedTime = "Invalid time format!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather & Time Zone App"),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme, // Toggle theme on button press
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter Time (HH:MM):"),
            TextField(
              controller: timeController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "e.g., 14:30",
              ),
            ),
            SizedBox(height: 20),

            Text("Select Country:"),
            DropdownButton<String>(
              value: selectedCountry,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCountry = newValue!;
                });
              },
              items: timeZoneOffsets.keys.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: convertTime,
              child: Text("Convert Time"),
            ),

            SizedBox(height: 20),
            Text(
              convertedTime.isEmpty
                  ? "Converted Time will appear here"
                  : "Converted Time: $convertedTime",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
