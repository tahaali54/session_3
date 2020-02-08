import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<WeatherDetail> fetchPost() async {
  final response = await http.get(
      'http://api.openweathermap.org/data/2.5/weather?q=Karachi,pk&units=metric&APPID=0154ac07e7c0fc3b2556cc8e5da8ad48');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return WeatherDetail.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class WeatherDesc {
  final String desc;
  WeatherDesc({this.desc});
  factory WeatherDesc.fromJson(dynamic json) {
    return WeatherDesc(
      desc: json['description'] as String,
    );
  }
  @override
  String toString() {
    return '${desc[0].toUpperCase()}${desc.substring(1)}';
  }
}

class WeatherDetail {
  final Main main;
  List<WeatherDesc> weather = List();

  WeatherDetail({this.main, this.weather});

  factory WeatherDetail.fromJson(Map<String, dynamic> json) {
    return WeatherDetail(
        main: Main.fromJson(json['main']),
        weather: (json['weather'] as List)
            .map((weatherDesc) => WeatherDesc.fromJson(weatherDesc))
            .toList());
  }
}

class Main {
  final int temperature;
  final int maxTemp;
  final int minTemp;
  final double feelsLike;

  Main({this.temperature, this.maxTemp, this.minTemp, this.feelsLike});
  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
        temperature: json['temp'],
        maxTemp: json['temp_max'],
        minTemp: json['temp_min'],
        feelsLike: json['feels_like']);
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<WeatherDetail> post;

  @override
  void initState() {
    super.initState();
    post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: FutureBuilder<WeatherDetail>(
              future: post,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildWeatherUI(snapshot.data);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherUI(WeatherDetail data) {
    String _degreeSymbol = '°';
    String _temperature = data.main.temperature.toString();
    String _lowest = (data.main.minTemp - 3).toString();
    String _highest = (data.main.maxTemp + 4).toString();
    String _feelsLike = data.main.feelsLike.toInt().toString();
    String _desc = data.weather.first.toString();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Align(
            alignment: Alignment.topRight,
            child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Color(0xFF343334).withOpacity(0.75),
                ),
                onPressed: () {
                  setState(() {
                    post = fetchPost();
                  });
                })),
        Expanded(child: Container()),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: _temperature,
              style: TextStyle(
                color: Colors.black,
                fontSize: 50,
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
              ),
              children: [
                TextSpan(
                  text: _degreeSymbol,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 60,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                  ),
                ),
                TextSpan(
                  text: 'C',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ]),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: '$_lowest.0 - $_highest.0',
              style: TextStyle(
                color: Color(0xFF343334).withOpacity(0.75),
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
              ),
              children: [
                TextSpan(
                  text: _degreeSymbol,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                ),
                TextSpan(
                  text: 'C',
                  style: TextStyle(
                    color: Color(0xFF343334).withOpacity(0.75),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                )
              ]),
        ),
        Text(
          _desc,
          style: TextStyle(
            fontSize: 50,
            color: Colors.red,
            fontWeight: FontWeight.w700,
            fontFamily: 'Montserrat',
          ),
        ),
        Text(
          'Karachi',
          style: TextStyle(
            color: Color(0xFF343334).withOpacity(0.75),
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
          ),
        ),
        Text(
          'PK',
          style: TextStyle(
            color: Color(0xFF343334).withOpacity(0.75),
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
