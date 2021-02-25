import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  int temperature = 0;
  String location = 'seoul';
  int woeid = 1132599;
  String weather = 'clear';

  String searchApiUrl = 'https://www.metaweather.com/api/location/search/?query=';
  String locationApiUrl = 'https://www.metaweather.com/api/location/';

  void fetchSearch( String input) async{
    var searchResult = await http.get(searchApiUrl + input);
    var result = json.decode(searchResult.body)[0];

    setState(() {
      location = result["title"];
      woeid = result["woeid"];
    });
  }

  void fetchLocation() async {
    var locationResult = await http.get(locationApiUrl + woeid.toString());
    var result = json.decode(locationResult.body);
    var consolidated_weather = result['consolidated_weather'];
    var data = consolidated_weather[0];

    setState(() {
      temperature = data['the_temp'].round();
      weather = data['weather_state_name'].replaceAll(' ','').toLowerCase();
      print(weather);
    });
  }

  void onTextFieldSubmitted(String input) {
    fetchSearch(input);
    fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('images/$weather.png'),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Center(
                    child: Text(
                  temperature.toString() + ' ℃',
                  style: TextStyle(fontSize: 60, color: Colors.white),
                )),
                Center(
                    child: Text(location,
                        style: TextStyle(fontSize: 40, color: Colors.white)))
              ],
            ),
            Column(
              children: [
                Container(
                  width: 300,
                  child: TextField(
                    onSubmitted: (String input){
                      onTextFieldSubmitted(input);
                    },
                    style: TextStyle(color: Colors.white, fontSize: 25),
                    decoration: InputDecoration(
                      hintText: '검색하고 싶은 도시를 입력하세요',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                      prefixIcon: Icon(Icons.search, color: Colors.white,)
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
