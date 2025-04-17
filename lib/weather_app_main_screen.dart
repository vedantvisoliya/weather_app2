import "package:flutter/material.dart";
import 'package:weather_app/additional_info_items.dart';
import 'package:weather_app/hourly_forecast_items.dart';
import 'package:weather_app/seven_day_forecast.dart';
import 'package:weather_app/open_weather_api_key.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherAppMainScreen extends StatefulWidget {
  const WeatherAppMainScreen({super.key});

  @override
  State<WeatherAppMainScreen> createState() => _WeatherAppMainScreenState();
}

class _WeatherAppMainScreenState extends State<WeatherAppMainScreen> {
  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url =
        "http://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$openWeatherAPIKey";

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data["cod"] != "200") {
        throw "An unexpected error occured";
      } else {
        return data;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static int counter = 0;

  String stringNullCheck(String? variable){
    if(variable == null){
      return "null";
    }
    else{
      return variable;
    }
  }

  double doubleNullCheck(double? variable){
    if(variable == null){
      return 0;
    }
    else{
      return variable;
    }
  }

  @override
  Widget build(BuildContext context) {
    String cityName = "New Delhi";

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () => {}, icon: Icon(Icons.search)),
          IconButton(
            onPressed: () => {setState(() {
              counter = 0;
            })},
            icon: Icon(Icons.refresh),
          ),
        ],
        elevation: 0,
      ),
      body: FutureBuilder(
        future: fetchWeather(cityName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          // Current data
          final data = snapshot.data!;
          final city = data['city']['name'];
          final double currentTemperature = data['list'][0]['main']['temp'];
          final currentWindSpeed = data['list'][0]['wind']['speed'];
          final currentHumidity = data['list'][0]['main']['humidity'];
          final currentPressure = data['list'][0]['main']['pressure'];
          final String currentSkyDescription =
              data['list'][0]['weather'][0]['description'];
          final String currentSky = data['list'][0]['weather'][0]['main'];
          final currentDateTimeObject = DateTime.parse(
            data['list'][0]['dt_txt'],
          );
          final String date = DateFormat(
            'EEEE, d MMMM',
          ).format(currentDateTimeObject);

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$city",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7),
                  // MAIN CARD
                  SizedBox(
                    width: double.infinity,
                    // height:
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 15,
                      color: Color.fromARGB(255, 46, 136, 222),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${(currentTemperature - 273).toStringAsFixed(0)}°C",
                                  style: const TextStyle(
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  currentSky == "Clouds" || currentSky == "Rain"
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 67,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Text(
                              currentSkyDescription,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AdditionalInfoItems(
                                  icon: Icons.water_drop_outlined,
                                  label: "Humidity",
                                  value: "$currentHumidity%",
                                ),
                                AdditionalInfoItems(
                                  icon: Icons.air,
                                  label: "Wind",
                                  value: "$currentWindSpeed km/hr",
                                ),
                                AdditionalInfoItems(
                                  icon: Icons.beach_access,
                                  label: "Pressure",
                                  value: "$currentPressure",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  // HOURLY FORECAST
                  const Text(
                    "Hourly Forecast",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
                  ),
            
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final dateTimeObject = DateTime.parse(
                          data['list'][index + 1]['dt_txt'],
                        );
                        final String time = DateFormat.j().format(
                          dateTimeObject,
                        );
                        final double temperature =
                            (data['list'][index + 1]['main']['temp']) - 273;
                        return HourlyForecastItems(
                          time: time,
                          icon: Icon(
                            data['list'][index + 1]['weather'][0]['main'] ==
                                        "Clouds" ||
                                    data['list'][index +
                                            1]['weather'][0]['main'] ==
                                        "Rain"
                                ? Icons.cloud
                                : Icons.sunny,
                            color:
                                data['list'][index + 1]['weather'][0]['main'] ==
                                            "Clouds" ||
                                        data['list'][index +
                                                1]['weather'][0]['main'] ==
                                            "Rain"
                                    ? Colors.blue
                                    : Colors.yellow,
                          ),
                          temperature: temperature.toStringAsFixed(0),
                        );
                      },
                    ),
                  ),
            
                  const SizedBox(height: 7),
                  // 7-DAY FORECAST
                  const Text(
                    "5-Day Forecast",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
                  ), 
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
                        List<String> nickNameForDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                        String? day;
                        String? nickDay;
                        String? time;
                        double? maxTemp;
                        double? minTemp;
                        String? sky;

                        final List list = data['list'];
                        for (counter; counter < list.length-1; counter++){
                          final dateTimeObject = DateTime.parse(data['list'][counter]['dt_txt']);
                          time = DateFormat.H().format(dateTimeObject);
                          // print("-----------------");
                          // print(time);
                          // print("-----------------");
                          if(time == "00"){
                            day = DateFormat('EEEE').format(dateTimeObject);
                            maxTemp = data['list'][counter]['main']['temp_max'];
                            minTemp = data['list'][counter]['main']['temp_min'];
                            sky = data['list'][counter]['weather'][0]['main'];
                            counter++;
                            break;
                          }
                        }
            
                        for (int j = 0; j < days.length; j++){
                          if(days[j] == day){
                            nickDay = nickNameForDays[j];
                          }
                        }
            
                        // print("----------------------");
                        // print(counter);
                        // print(day);
                        // print(nickDay);
                        // print(time);
                        // print(sky);
                        // print(minTemp);
                        // print(maxTemp);
                        // print("----------------------");
                        day = stringNullCheck(day);
                        nickDay = stringNullCheck(nickDay);
                        time = stringNullCheck(time);
                        sky = stringNullCheck(sky);
                        minTemp = doubleNullCheck(minTemp);
                        maxTemp = doubleNullCheck(maxTemp);
                        return SevenDayForecast(
                          day: nickDay,
                          icon: Icon(
                            sky == "Clouds" || sky == "Rain" || sky == "null" ? Icons.cloud:Icons.sunny,
                            color: sky == "Clouds" || sky == "Rain" ? Colors.blue:Colors.yellow,
                          ),
                          maximumTemperature: maxTemp,
                          minimumTemperature: minTemp,
                        );
                        // return const Placeholder();
                      }
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
