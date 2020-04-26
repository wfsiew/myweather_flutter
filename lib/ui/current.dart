import 'package:flutter/material.dart';
import 'package:myweather_flutter/model/weather.dart';
import 'dart:async';
import 'package:myweather_flutter/service/weather-service.dart';
import 'package:myweather_flutter/model/weather-info.dart';
import 'package:myweather_flutter/helpers.dart';

class Current extends StatefulWidget {
  Current({Key key, this.title}) : super(key: key);

  static const String routeName = '/Home';

  final String title;

  @override
  _CurrentState createState() => _CurrentState();
}

class _CurrentState extends State<Current>
  with AutomaticKeepAliveClientMixin<Current> {

  ScrollController scr = ScrollController();
  WeatherInfo info;
  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void load() async {
    try {
      setState(() {
        isLoading = true;
      });
      var o = await getWeatherCurrent();
      setState(() {
        info = o;
        isLoading = false;
      });
    }

    catch (error) {
      setState(() {
        isLoading = false;
        handleError(context, error, load);
      });
    }
  }

  Future<void> refreshData() async {
    try {
      var o = await getWeatherCurrent();
      setState(() {
        info = o;
      });
    }

    catch (error) {
      handleError(context, error, () async {
        await refreshData();
      });
    }
  }

  Widget buildWeathers() {
    List<Widget> lx = List();
    for (int i = 0; i < info.current.weather.length; i++) {
      Weather o = info.current.weather[i];
      var x = ListTile(
        leading: Image.network(getIcon(o.icon)),
        title: Text(o.main),
      );
      lx.add(x);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lx,
    );
  }

  Widget buildContent() {
    if (isLoading || info == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 5,
        child: ListView(
          controller: scr,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: Text(
                'Current Weather',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text('dt'),
              trailing: Text('${formatDate(info.current.dt)}'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary, 
              height: 2.0,
            ),
            ListTile(
              title: Text('sunrise'),
              trailing: Text('${formatDate(info.current.sunrise)}'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary, 
              height: 2.0,
            ),
            ListTile(
              title: Text('sunset'),
              trailing: Text('${formatDate(info.current.sunset)}'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary, 
              height: 2.0,
            ),
            ListTile(
              title: Text('temp'),
              trailing: Text('${info.current.temp} deg. Celsius'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary, 
              height: 2.0,
            ),
            ListTile(
              title: Text('feels_like'),
              trailing: Text('${info.current.feelsLike} deg. Celsius'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary, 
              height: 2.0,
            ),
            ListTile(
              title: Text('pressure'),
              trailing: Text('${info.current.pressure} hPa'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary, 
              height: 2.0,
            ),
            ListTile(
              title: Text('humidity'),
              trailing: Text('${info.current.humidity} %'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary, 
              height: 2.0,
            ),
            ListTile(
              title: Text('dew_point'),
              trailing: Text('${info.current.dewPoint} deg. Celsius'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary, 
              height: 2.0,
            ),
            ListTile(
              title: Text('uvi'),
              trailing: Text('${info.current.uvi}'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary, 
              height: 2.0,
            ),
            ListTile(
              title: Text('clouds'),
              trailing: Text('${info.current.clouds} %'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary, 
              height: 2.0,
            ),
            ListTile(
              title: Text('visibility'),
              trailing: Text('${info.current.visibility} meters'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary, 
              height: 2.0,
            ),
            ListTile(
              title: Text('wind_speed'),
              trailing: Text('${info.current.windSpeed} m/s'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary, 
              height: 2.0,
            ),
            ListTile(
              title: Text('wind_deg'),
              trailing: Text('${info.current.windDeg} deg.'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary, 
              height: 2.0,
            ),

            buildWeathers(),
          ],
        ),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: refreshData,
      child: buildContent(),
    );
  }
}