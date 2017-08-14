import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:counter_widget/CounterWidget.dart';

class CounterList extends StatelessWidget {
  final reference = FirebaseDatabase.instance.reference().child('root/events');

  Future<String> _StartService(String name) async {
    var response = await http.get(
        Uri.encodeFull(
            "https://us-central1-counterwidget-fee5a.cloudfunctions.net/startService?serviceID=${name}"),
        headers: {"Accept": "application/json"});
    return response.body;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(title: new Text("Counter Events")),
        body: new Container(
          padding: new EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.all(16.0),
                child: new Text(
                  "Events List",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              new Flexible(
                child: new FirebaseAnimatedList(
                  query: reference,
                  sort: (a, b) => a.key.compareTo(b.key),
                  reverse: false,
                  itemBuilder:
                      (_, DataSnapshot snapshot, Animation<double> animation) {
                    if (snapshot.value["startTs"] != 0) {
                      return new CounterWidget(
                          name: snapshot.value["name"],
                          time: snapshot.value["startTs"],
                          duration: snapshot.value["ttl"]);
                    } else {
                      return new Card(
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
                                  child: new Text(snapshot.value["name"],
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                ),
                                new Container(
                                  padding: new EdgeInsets.only(left: 17.0),
                                  child: new FlatButton(
                                      onPressed: () {
                                        _StartService(snapshot.key);
                                      },
                                      child: new Text(
                                        "Start",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      )),
                                )
                              ]),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
