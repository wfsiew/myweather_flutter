import 'weather-current.dart';

class WeatherInfo {
  double lat;
  double lon;
  String timezone;
  WeatherCurrent current;

  WeatherInfo({
    this.lat,
    this.lon,
    this.timezone,
    this.current
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      lat: json['lat'],
      lon: json['lon'],
      timezone: json['timezone'],
      current: WeatherCurrent.fromJson(json['current'])
    );
  }
}