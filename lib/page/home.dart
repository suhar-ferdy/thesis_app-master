import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thesis_app/widget//event_item.dart';
import 'package:thesis_app/widget/botnavbar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}


final dbRef = FirebaseDatabase.instance.reference().child("Events");
List list=new List();

class _HomePageState extends State<HomePage> {
  // ignore: must_call_super
  void initState(){
    loadEvents();
  }

  void loadEvents(){
    dbRef.once().then((DataSnapshot snapshot){
      list.clear();
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,values) {
        if(!timeDifference(values['day'], values['month'], values['year'], values['hour'], values['minute']).isNegative){
          setState(() {
            list.add(values);
          });
        }
      });
    }).whenComplete((){
      if(list.isEmpty){
        Fluttertoast.showToast(
            msg: "No Events",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });
  }

  Duration timeDifference(int day, int month, int year, int hour, int minute){
    var dateEvent = DateTime(year,month,day,hour,minute);
    var date = DateTime.now();
    var val  = dateEvent.difference(date);
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            child: Text('What\'s good in?',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                            margin: EdgeInsets.only(left: 20,right: 20,top: 35),
                          ),
                          Container(
                            width: double.infinity,
                            child: Text('Indonesia',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                            margin: EdgeInsets.only(left: 20,right: 20,top: 10),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          child: ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (BuildContext ctx, int index){
                              return EventItem(event: list[index],);
                            },
                          ),
                        ),
                      )
                    ],
                  )
              ),
            ],
          ),
          bottomNavigationBar: BotNavBar(currIndex: 0,)
        ),
      )
    );
  }
}

