import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

String name, number;
final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
TextEditingController nameController = new TextEditingController();
TextEditingController numberController = new TextEditingController();

Future<String> _createService(String name, String number) async {
  var response = await http.get(
      Uri.encodeFull(
          "https://us-central1-counterwidget-fee5a.cloudfunctions.net/createService?serviceName=${name}&ttlHour=${number}"),
      headers: {"Accept": "application/json"});
  return response.body;
}

void showInSnackBar(String value) {
  _scaffoldKey.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

void _handleSubmitted() {
  final FormState form = formKey.currentState;
  form.save();
  nameController.clear();
  numberController.clear();
  _createService(name, number).then((onValue) {
    showInSnackBar(onValue);
  }).catchError((PlatformException onError) {
    showInSnackBar(onError.message);
  });
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: new AppBar(title: new Text("Create Counter Event")),
      key: _scaffoldKey,
      drawer: new Drawer(
          child: new ListView(
        children: [
          new DrawerHeader(
              decoration: new BoxDecoration(color: Colors.blue),
              child: new Container(
                alignment: FractionalOffset.centerLeft,
                child: new Text("Counter Widget",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0)),
              )),
          new ListTile(
            title: new Text("Events List"),
            leading: new Icon(Icons.list),
            onTap: () {
              Navigator.popAndPushNamed(context, "/counterList");
            },
          ),
        ],
      )),
      body: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new SizedBox(
              height: screenSize.height / 2 - 100,
              child: new Container(
                alignment: FractionalOffset.center,
                child: new Text("Create Event",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24.0)),
              ),
            ),
            new Container(
              padding: new EdgeInsets.all(26.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Form(
                    key: formKey,
                    autovalidate: false,
                    child: new Column(
                      children: <Widget>[
                        new TextFormField(
                          obscureText: false,
                          controller: nameController,
                          decoration: new InputDecoration(
                              hintText: "Event Name", hideDivider: false),
                          keyboardType: TextInputType.text,
                          validator: null,
                          onSaved: (String text) {
                            name = text;
                          },
                        ),
                        new TextFormField(
                          obscureText: false,
                          controller: numberController,
                          decoration: new InputDecoration(
                            hintText: "Live Time",
                          ),
                          keyboardType: TextInputType.number,
                          validator: null,
                          onSaved: (String text) {
                            number = text;
                          },
                        ),
                        new Container(
                          margin: new EdgeInsets.only(top: 20.0),
                          width: screenSize.width,
                          child: new RaisedButton(
                            onPressed: _handleSubmitted,
                            child: new Text("Create Event"),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
