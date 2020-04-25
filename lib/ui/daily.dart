import 'package:flutter/material.dart';
import 'package:myweather_flutter/model/weather.dart';
import 'dart:async';
import 'package:myweather_flutter/service/weather-service.dart';
import 'package:myweather_flutter/model/weather-daily.dart';
import 'package:myweather_flutter/helpers.dart';
import 'package:myweather_flutter/shared/widget/bottom-bar.dart';

class Daily extends StatefulWidget {
  Daily({Key key, this.title}) : super(key: key);

  static const String routeName = '/Dailyly';

  final String title;

  @override
  _DailyState createState() => _DailyState();
}

class _DailyState extends State<Daily> {

  ScrollController scr = ScrollController();
  List<WeatherDaily> list;
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

  void load() async {
    try {
      setState(() {
        isLoading = true;
      });
      var o = await getWeatherDaily();
      setState(() {
        list = o;
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
      var o = await getWeatherDaily();
      setState(() {
        list = o;
      });
    }

    catch (error) {
      handleError(context, error, () async {
        await refreshData();
      });
    }
  }

  Widget buildTemp(WeatherDaily o) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${o.temp.morn} (Morn)'),
          Text('${o.temp.day} (Day)'),
          Text('${o.temp.eve} (Eve)'),
          Text('${o.temp.night} (Night)'),
        ],
      ),
    );
  }

  Widget buildWeathers(WeatherDaily o) {
    List<Widget> lx = List();
    for (int i = 0; i < o.weather.length; i++) {
      Weather w = o.weather[i];
      var x = ListTile(
        leading: Image.network(getIcon(w.icon)),
        title: Text(w.main),
      );
      lx.add(x);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lx,
    );
  }

  Widget buildRow(WeatherDaily o) {
    return Card(
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Text('${formatDate(o.dt)}'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text('Sunrise: ${formatDate(o.sunrise)}'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text('Sunset: ${formatDate(o.sunset)}'),
          ),
          buildWeathers(o),
          buildTemp(o),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Center(
              child: Text('deg. Celsius'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    if (isLoading || list == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, i) {
          WeatherDaily o = list[i];
          return buildRow(o);
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[],
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: refreshData,
        child: buildContent(),
      ),
      bottomNavigationBar: CustomBottomBar(index: 2),
    );
  }
}