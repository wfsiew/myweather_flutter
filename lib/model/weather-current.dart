import 'weather.dart';

class WeatherCurrent {
  int dt;
  int sunrise;
  int sunset;
  num temp;
  num feelsLike;
  int pressure;
  int humidity;
  num dewPoint;
  num uvi;
  int clouds;
  int visibility;
  num windSpeed;
  int windDeg;
  List<Weather> weather;

  WeatherCurrent({
    this.dt,
    this.sunrise,
    this.sunset,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.dewPoint,
    this.uvi,
    this.clouds,
    this.visibility,
    this.windSpeed,
    this.windDeg,
    this.weather
  });

  factory WeatherCurrent.fromJson(Map<String, dynamic> json) {
    var ls = json['weather'] as List;
    List<Weather> lx = ls.map<Weather>((x) => Weather.fromJson(x)).toList();

    return WeatherCurrent(
      dt: json['dt'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      temp: json['temp'],
      feelsLike: json['feels_like'],
      pressure: json['pressure'],
      humidity: json['humidity'],
      dewPoint: json['dew_point'],
      uvi: json['uvi'],
      clouds: json['clouds'],
      visibility: json['visibility'],
      windSpeed: json['wind_speed'],
      windDeg: json['wind_deg'],
      weather: lx
    );
  }
}