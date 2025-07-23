import 'package:flutter/material.dart';
import 'prediction.dart'; // Import your PredictionPage (or the main page)

void main() {
  runApp(MyApp()); // Launch your app
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prediction App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PredictionPage(), // Use your prediction page as the home page
    );
  }
}
