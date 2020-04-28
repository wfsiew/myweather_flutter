import 'package:flutter/material.dart';
import 'package:myweather_flutter/model/weather.dart';
import 'dart:async';
import 'package:myweather_flutter/service/weather-service.dart';
import 'package:myweather_flutter/model/weather-info.dart';
import 'package:myweather_flutter/helpers.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:geolocator/geolocator.dart';

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
  bool isLocationServiceEnabled = false;
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

  Future<void> checkLocationPermission() async {
    PermissionStatus permission = await LocationPermissions().checkPermissionStatus();
    if (permission != PermissionStatus.granted) {
      permission = await LocationPermissions().requestPermissions();
      if (permission != PermissionStatus.granted) {
        setState(() {
          isLocationServiceEnabled = false;
          isLoading = false;
          info = null;
        });
      }

      else {
        ServiceStatus serviceStatus = await LocationPermissions().checkServiceStatus();
        if (serviceStatus == ServiceStatus.disabled) {
          setState(() {
            isLocationServiceEnabled = false;
            isLoading = false;
            info = null;
          });
        }

        else if (serviceStatus == ServiceStatus.enabled) {
          setState(() {
            isLocationServiceEnabled = true;
          });
        }
      }
    }

    else {
      ServiceStatus serviceStatus = await LocationPermissions().checkServiceStatus();
      if (serviceStatus == ServiceStatus.disabled) {
        setState(() {
          isLocationServiceEnabled = false;
          isLoading = false;
          info = null;
        });
      }

      else if (serviceStatus == ServiceStatus.enabled) {
        setState(() {
          isLocationServiceEnabled = true;
        });
      }
    }
  }

  Future<void> load() async {
    try {
      await checkLocationPermission();
      if (!isLocationServiceEnabled) {
        return;
      }

      setState(() {
        isLoading = true;
      });
      final Geolocator geolocator = Geolocator();
      Position position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      var o = await getWeatherCurrent(position.latitude, position.longitude);
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
      await checkLocationPermission();
      if (!isLocationServiceEnabled) {
        return;
      }

      final Geolocator geolocator = Geolocator();
      Position position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      var o = await getWeatherCurrent(position.latitude, position.longitude);
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
    if (!isLocationServiceEnabled) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Location Service not available',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          ),
          RaisedButton(
            elevation: 5,
            color: Theme.of(context).primaryColor,
            child: Text(
              'Retry',
              style: TextStyle(
                color: Colors.white
              ),
            ),
            onPressed: () async {
              await load();
            },
          ),
        ],
      );
    }

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (!isLoading && info == null) {
      return Center(child: Text('Unable to get current weather details'));
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
              title: Text('lat'),
              trailing: Text('${info.lat}'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary, 
              height: 2.0,
            ),
            ListTile(
              title: Text('lon'),
              trailing: Text('${info.lon}'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary, 
              height: 2.0,
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