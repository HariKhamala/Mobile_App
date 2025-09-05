import 'package:flutter/material.dart';

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
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.black,
      ),
      themeMode: _themeMode,
      home: TemperatureDisplay(toggleTheme: toggleTheme),
    );
  }
}

class TemperatureDisplay extends StatefulWidget {
  final VoidCallback toggleTheme;
  TemperatureDisplay({required this.toggleTheme});

  @override
  _TemperatureDisplayState createState() => _TemperatureDisplayState();
}

class _TemperatureDisplayState extends State<TemperatureDisplay> {
  TextEditingController tempController = TextEditingController();
  double temperature = 25.0; // Default temperature

  void updateTemperature() {
    setState(() {
      temperature = double.tryParse(tempController.text) ?? 25.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text("Real-Time Temperature Display"),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter Temperature (°C):", style: TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: tempController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Temperature",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: updateTemperature,
              child: Text("Update Temperature"),
            ),
            SizedBox(height: 20),
            Text(
              "$temperature °C",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.orange : Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
