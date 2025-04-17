import 'package:flutter/material.dart';

class SevenDayForecast extends StatelessWidget {
  final String? day;
  final Icon icon;
  final double? maximumTemperature;
  final double? minimumTemperature;
  const SevenDayForecast({
      super.key,
      required this.day,
      required this.icon,
      required this.maximumTemperature,
      required this.minimumTemperature,
    });
    
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),        
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$day",
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                width: 125,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    icon,
                    Text(
                      "${(maximumTemperature!-273).toStringAsFixed(0)}°C",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "${(minimumTemperature!-273).toStringAsFixed(0)}°C",
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}