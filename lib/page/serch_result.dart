import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thesis_app/widget/event_item.dart';
import 'package:geolocator/geolocator.dart';
import 'package:thesis_app/widget/toast_msg.dart';

class SearchResultPage extends StatefulWidget {
  final int distance;
  final String category;
  final List data;
  SearchResultPage({Key key, this.distance, this.data, this.category}) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

List list = new List();
final dbRef = FirebaseDatabase.instance.reference().child("Events");
int count;
FToast flutterToast;

class _SearchResultPageState extends State<SearchResultPage> {

  void initState() {
    super.initState();
    flutterToast = FToast(context);
    list.clear();
    loadResult();
  }
  void loadResult() async{
    if(widget.data != null){
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      widget.data.forEach((item){
        double d = getDistanceFromLatLonInKm(position.latitude, position.longitude, item["lat"], item["lng"]);
        if(widget.category == '\#Any'){
          if(widget.distance == 0){
            setState(() {
              list.add(item);
            });
          }
          if(d < widget.distance){
            setState(() {
              list.add(item);
            });
          }
        }
        else{
          if(widget.distance == 0 && widget.category == item['category']){
            setState(() {
              list.add(item);
            });
          }
          if(d < widget.distance && widget.category == item['category']){
            setState(() {
              list.add(item);
            });
          }
        }
      });
    }
    if(list.isEmpty){
      ToastMsg(msg: "No search results", flutterToast:  flutterToast).showToast();
    }
  }

  double getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2-lat1);  // deg2rad below
    var dLon = deg2rad(lon2-lon1);
    var a =
        sin(dLat/2) * sin(dLat/2) +
            cos(deg2rad(lat1)) * cos(deg2rad(lat2)) *
                sin(dLon/2) * sin(dLon/2);

    var c = 2 * atan2(sqrt(a), sqrt(1-a));
    var d = R * c; // Distance in km
    return d;
  }
  double deg2rad(deg) {
    const double pi = 3.1415926535897932;
    return deg * (pi/180);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext ctx, int index){
              return EventItem(event: list[index],);
            },
          ),
        ),
      ),
    );
  }
}
