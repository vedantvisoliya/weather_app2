import 'package:flutter/material.dart';
import 'package:weather_app/weather_app_main_screen.dart';

void main(){
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Weather App",
      theme: ThemeData.light(useMaterial3: true),
      home: const WeatherAppMainScreen(),
    );
  }
}