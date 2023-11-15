import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}
 
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
 
class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _cityController = new TextEditingController();

  String _station = "";
  double _temp = 0.0;
  int _humidity = 0;
  String _country = "";
  String _description = "";
  

  void _httpRequest() async {
    await dotenv.load();
    String city = _cityController.text.toString();

    // make request
    String url = "https://api.openweathermap.org/data/2.5/weather?units=metric&q=" + city + "&lang=fi&appid=" + dotenv.env['API_KEY'];
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    var extractdata = json.decode(response.body);

    setState(() {
      // parse json and update ui
      _station = extractdata["name"];
      _temp = extractdata["main"]["temp"].toDouble();
      _humidity = extractdata["main"]["humidity"].toInt();
      _country = extractdata["sys"]["country"];
      _description = extractdata["weather"][0]["description"].toUpperCase();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          TextField(controller: _cityController, style: TextStyle(fontSize: 32), decoration: InputDecoration(border: InputBorder.none, hintText: "Syötä kaupungin nimi"),cursorColor: Colors.pink, enableSuggestions: false, keyboardType: TextInputType.visiblePassword),
          RaisedButton(onPressed: _httpRequest, color: Colors.pink, child: Text("Hae säätiedot", style: TextStyle(color: Colors.white,fontSize: 32),),),
          
          Text("$_country", style: TextStyle(fontSize: 26, color: Colors.pink),),
          Text("$_station", style: TextStyle(fontSize: 26, color: Colors.pink),),
          if (_station != "" && _country != "")
          Text("$_temp °C", style: TextStyle(fontSize: 26, color: Colors.pink),),
          if (_station != "" && _country != "") 
          Text("$_humidity %", style: TextStyle(fontSize: 26, color: Colors.pink),),
          Text("$_description", style: TextStyle(fontSize: 26, color: Colors.pink),)
        ],)
      ),
    );
  }
}