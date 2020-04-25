import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

void handleError(BuildContext context, DioError error, void Function() onYes) {
  String msg = '';
  if (error.type == DioErrorType.CONNECT_TIMEOUT) {
    msg = 'Connection Timeout';
  }

  else if (error.type == DioErrorType.RECEIVE_TIMEOUT) {
    msg = 'Receive Timeout';
  }

  else if (error.type == DioErrorType.RESPONSE) {
    msg = 'Error occurred - ${error.response.statusCode}';
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(''),
        content: Text('$msg. Do you want to retry ?'),
        actions: <Widget>[
          FlatButton(
            child: Text('NO'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('YES'),
            onPressed: () {
              Navigator.of(context).pop();
              onYes();
            },
          ),
        ],
      );
    }
  );
}

String getIcon(String s) {
  return 'http://openweathermap.org/img/wn/$s@2x.png';
}

String formatDate(int x) {
  var dt = DateTime.fromMillisecondsSinceEpoch(x * 1000);
  return DateFormat('d MMM y hh:mm:ss a').format(dt);
}