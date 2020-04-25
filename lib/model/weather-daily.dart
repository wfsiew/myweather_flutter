
import 'weather.dart';

class Temp {
  num day;
  num min;
  num max;
  num night;
  num eve;
  num morn;

  Temp({
    this.day,
    this.min,
    this.max,
    this.night,
    this.eve,
    this.morn
  });

  factory Temp.fromJson(Map<String, dynamic> json) {
    return Temp(
      day: json['day'],
      min: json.containsKey('min') ? json['min'] : 0,
      max: json.containsKey('max') ? json['max'] : 0,
      night: json['night'],
      eve: json['eve'],
      morn: json['morn']
    );
  }
}

class WeatherDaily {
  int dt;
  int sunrise;
  int sunset;
  Temp temp;
  Temp feelsLike;
  int pressure;
  int humidity;
  num dewPoint;
  num windSpeed;
  int windDeg;
  List<Weather> weather;
  int clouds;
  num rain;
  num uvi;

  WeatherDaily({
    this.dt,
    this.sunrise,
    this.sunset,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.dewPoint,
    this.windSpeed,
    this.windDeg,
    this.weather,
    this.clouds,
    this.rain,
    this.uvi
  });

  factory WeatherDaily.fromJson(Map<String, dynamic> json) {
    var ls = json['weather'] as List;
    List<Weather> lx = ls.map<Weather>((x) => Weather.fromJson(x)).toList();

    return WeatherDaily(
      dt: json['dt'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      temp: Temp.fromJson(json['temp']),
      feelsLike: Temp.fromJson(json['feels_like']),
      pressure: json['pressure'],
      humidity: json['humidity'],
      dewPoint: json['dew_point'],
      windSpeed: json['wind_speed'],
      windDeg: json['wind_deg'],
      weather: lx,
      clouds: json['clouds'],
      rain: json['rain'],
      uvi: json['uvi']
    );
  }
}