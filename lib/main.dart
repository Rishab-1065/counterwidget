import 'package:flutter/material.dart';
import 'package:counter_widget/CounterList.dart';
import 'package:counter_widget/CreateEvents.dart';

var routes = <String, WidgetBuilder>{
  "/counterList": (BuildContext context) => new CounterList(),
};
void main() {
  runApp(new MaterialApp(
    routes: routes,
    title: "CounterWidget Demo",
    theme: new ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: new MyApp(),
  ));
}
