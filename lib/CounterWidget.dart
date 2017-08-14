import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:async';

class CounterWidget extends StatefulWidget {
  String name, duration;
  int time;

  CounterWidget({this.name, this.time, this.duration});

  @override
  State<StatefulWidget> createState() =>
      new CounterWidgetState(name: name, time: time, duration: duration);
}

class CounterWidgetState extends State<CounterWidget> {
  String name, duration;
  int time;

  CounterWidgetState({this.name, this.time, this.duration});

  var timer;
  String remTime;

  calTime(DateTime startTime, DateTime currTime, var diff) {
    if (this!= null) {
      this.setState(() {
        if (startTime.compareTo(currTime) > 0) {
          diff = startTime.difference(currTime);
          remTime = diff.toString().substring(0, diff.toString().lastIndexOf(":"))+ " hrs\nRemaining";
        } else {
          remTime = "Expired";
          if (timer != null) timer.cancel();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    DateTime startTime = new DateTime.fromMillisecondsSinceEpoch(time);
    DateTime currTime = new DateTime.now();
    startTime = startTime.add(new Duration(hours: int.parse(duration)));
    var diff = startTime.difference(currTime);
    if (startTime.compareTo(currTime) > 0) {
      remTime = diff.toString().substring(0, diff.toString().lastIndexOf(":"))+ " hrs\nRemaining";
    } else {
      remTime = "Expired";
      if (timer != null) timer.cancel();
    }
    if (this != null) {
      timer = new Timer(new Duration(seconds: 60), () {
        return calTime(startTime, currTime, diff);
      });
    }

    return (new Container(
      child: new Column(
        children: <Widget>[
          new Card(
            elevation: 3.0,
            child: new Container(
              height: 80.0,
              padding: new EdgeInsets.all(16.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    child: new Icon(Icons.access_alarm),
                    padding: new EdgeInsets.only(right: 16.0),
                  ),
                  new Expanded(
                      flex: 1,
                      child: new Text(
                        name,
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      )),
                  new Container(
                    alignment: FractionalOffset.centerRight,
                    padding: new EdgeInsets.all(8.0),
                    child: new Text(
                      remTime.toString(),
                      textAlign: TextAlign.center,
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
