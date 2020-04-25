import 'package:flutter/material.dart';
import 'package:myweather_flutter/ui/hourly.dart';
import 'package:myweather_flutter/ui/daily.dart';

class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({Key key, this.index}) : super(key: key);

  final int index;

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState(currIndex: index);
}

class _CustomBottomBarState extends State<CustomBottomBar> {

  int currIndex = 0;

  _CustomBottomBarState({
    this.currIndex
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currIndex,
      onTap: (int i) {
        if (i == 0 && currIndex != i) {
          Navigator.pop(context);
        }

        else if (i == 1 && currIndex != i) {
          Navigator.pushNamed(context, Hourly.routeName);
        }

        else if (i == 2 && currIndex != i) {
          Navigator.pushNamed(context, Daily.routeName);
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Current')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer),
          title: Text('Hourly')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          title: Text('Daily')
        ),
      ],
    );
  }
}