import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thesis_app/widget/botnavbar.dart';
import 'package:thesis_app/widget/notification_item.dart';


class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}


List list=new List();

class _NotificationsPageState extends State<NotificationsPage> {

  // ignore: must_call_super
  void initState(){
    loadEvents();
  }

  void loadEvents()async{
    final user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    final dbRef = FirebaseDatabase.instance.reference().child("Notification/$uid");
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
    }).catchError((e){
      print(e);
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
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index){
                  return NotificationItem(data: list[index],);
                },
            ),
          ),
          bottomNavigationBar: BotNavBar(currIndex: 2,),
        ),
      ),
    );
  }
}
