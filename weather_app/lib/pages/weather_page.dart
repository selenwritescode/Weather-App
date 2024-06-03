import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_models.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('aad3ecc7d4453021f7cf03ed95f03ad4');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get the weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any errors
    catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstrom':
        return 'assets/thunder.json';
      case 'sunny':
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/suny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather on start up
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            // location icon
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // city name
                  Text(
                    (_weather?.cityName ?? "loading city..").toUpperCase(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
            // animations
            Expanded(child: Lottie.asset(getWeatherAnimation(_weather?.mainCondition))),
            const Spacer(),
            // temperature
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                children: [
                  Text(
                    '${_weather?.temperature.round()}°C',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  
                  // weather condition
                  Text(
                    _weather?.mainCondition ?? "",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
