import 'package:dio/dio.dart';
import 'dart:async';
import 'package:myweather_flutter/constants.dart';
import 'package:myweather_flutter/model/weather-info.dart';
import 'package:myweather_flutter/model/weather-hourly.dart';
import 'package:myweather_flutter/model/weather-daily.dart';

final String url = '${Constants.API_URL}';
final Dio dio = Dio(BaseOptions(connectTimeout: 5000, receiveTimeout: 15000));

Future<dynamic> getData({double lat = 3.030112, double lon = 101.668607}) async {
  dynamic o;

  try {
    var res = await dio.get(url, queryParameters: {
      'lat': lat,
      'lon': lon,
      'units': 'metric',
      'appid': Constants.APPID
    });
    o = res.data;
  }

  catch (error) {
    throw(error);
  }

  return o;
}

Future<WeatherInfo> getWeatherCurrent(double lat, double lon) async {
  WeatherInfo o;

  try {
    var data = await getData(lat: lat, lon: lon);
    o = WeatherInfo.fromJson(data);
  }

  catch (error) {
    throw(error);
  }

  return o;
}

Future<List<WeatherHourly>> getWeatherHourly(double lat, double lon) async {
  List<WeatherHourly> lx;

  try {
    var data = await getData(lat: lat, lon: lon);
    var ls = data['hourly'] as List;
    lx = ls.map<WeatherHourly>((x) => WeatherHourly.fromJson(x)).toList();
  }

  catch (error) {
    throw(error);
  }

  return lx;
}

Future<List<WeatherDaily>> getWeatherDaily(double lat, double lon) async {
   List<WeatherDaily> lx;

  try {
    var data = await getData(lat: lat, lon: lon);
    var ls = data['daily'] as List;
    lx = ls.map<WeatherDaily>((x) => WeatherDaily.fromJson(x)).toList();
  }

  catch (error) {
    throw(error);
  }

  return lx;
}
