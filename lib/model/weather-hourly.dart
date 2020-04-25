import 'rain.dart';
import 'weather.dart';

class WeatherHourly {
  int dt;
  num temp;
  num feelsLike;
  int pressure;
  int humidity;
  num dewPoint;
  int clouds;
  num windSpeed;
  int windDeg;
  List<Weather> weather;
  Rain rain;

  WeatherHourly({
    this.dt,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.dewPoint,
    this.clouds,
    this.windSpeed,
    this.windDeg,
    this.weather,
    this.rain
  });

  factory WeatherHourly.fromJson(Map<String, dynamic> json) {
    var ls = json['weather'] as List;
    List<Weather> lx = ls.map<Weather>((x) => Weather.fromJson(x)).toList();

    return WeatherHourly(
      dt: json['dt'],
      temp: json['temp'],
      feelsLike: json['feels_like'],
      pressure: json['pressure'],
      humidity: json['humidity'],
      dewPoint: json['dew_point'],
      clouds: json['clouds'],
      windSpeed: json['wind_speed'],
      windDeg: json['wind_deg'],
      weather: lx,
      rain: json.containsKey('rain') ? Rain.fromJson(json['rain']) : null
    );
  }
}