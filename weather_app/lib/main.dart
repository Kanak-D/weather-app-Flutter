import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() {
  runApp(MyApp());
}




class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int temperature;
  String location="London";
  int woeid=44418;
  String weather="clear";
  String abbrevation='';
  String searchApiUrl="https://www.metaweather.com/api/location/search/?query=";
  String locationApiUrl="https://www.metaweather.com/api/location/";


  void initState() {

    super.initState();
    fetchLocation();
  }
  void fetchSearch(String input) async{
    var searchResult= await http.get(searchApiUrl+ input);
    var result=json.decode(searchResult.body)[0];

    setState(() {
      location=result['title'];
      woeid=result["woied"];
    });
  }

  void fetchLocation() async{
    var locationResult=await http.get(locationApiUrl+ woeid.toString());
    var result=json.decode(locationResult.body);
    var consolidated=result[" consolidated_weather"];
    var data=consolidated[0];

    setState(() {
      temperature=data["the_temp"].round();
      weather=data["weather_state_name"].replaceAll(' ','').toLowerCase();
      abbrevation=data["weather_state_abbr"];
    });

  }
  void onTextFieldSubmitted(String input){
    fetchSearch(input);
    fetchLocation();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          image:DecorationImage(
            image:AssetImage("images/$weather.png"),
            fit:BoxFit.cover,

          ),
        ),
        child: temperature==null
        ?Center(child: CircularProgressIndicator()):
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget> [

              Column(
                children:<Widget> [
                  Center(
                    child:Image.network(
                      'https://www.metaweather.com/static/img/weather/png/'+ abbrevation+'.png',
                      width: 100,
                    ),
                  ),
                  Center(child:Text(
                    temperature.toString()+'C',style: TextStyle(color: Colors.white,fontSize: 60,),
                  ),),
                  Center(child:Text(
                    location,style: TextStyle(color: Colors.white,fontSize: 60,),
                  ),),
                ],

              ),
              Column(
                children: <Widget>[
                  Container(
                    width:300,
                    child: TextField(
                      onSubmitted: (String input){
                        onTextFieldSubmitted(input);
                      },
                      style: TextStyle(color: Colors.white,fontSize: 25),
                      decoration: InputDecoration(
                        hintText: 'Search another location',
                        hintStyle: TextStyle(
                          color: Colors.white,fontSize: 20,
                        ),
                        prefixIcon: Icon(Icons.search,color: Colors.white,),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
