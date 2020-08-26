import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationItem extends StatefulWidget {
  final data;
  NotificationItem({this.data});
  @override
  _NotificationItemState createState() => _NotificationItemState();
}

String notificationStatus;
Icon notificationIcon;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
String _uploadedFileURL;

class _NotificationItemState extends State<NotificationItem> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    downloadFile();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    notificationStatus = 'off';
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          AlertDialog(
            title: Text('Aye'),
            content: Text('Aye Content'),
          )
      ),
    );
  }

  Duration timeDifference(int day, int month, int year, int hour, int minute){
    var dateEvent = DateTime(year,month,day,hour,minute);
    var date = DateTime.now();
    var val  = dateEvent.difference(date);
    return val;
  }

  void switchOnOffNotification(){
    if(notificationStatus == 'off'){
      setState(() {
        notificationStatus = 'on';
        notificationIcon = Icon(Icons.notifications,color: Colors.blueAccent,size: 30,);
      });
    }
    else{
      setState(() {
        notificationStatus = 'off';
        notificationIcon = Icon(Icons.notifications_off,size: 30,);
      });
    }
  }

  setNotifications() async{
    var duration = timeDifference(widget.data["day"], widget.data["month"], widget.data["year"], widget.data["hour"], widget.data["minute"]);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        DateTime.now().add(duration),
        platformChannelSpecifics);
  }

  Future downloadFile() async{
    print('Download File');
    var eo = widget.data["user"];
    StorageReference ref = FirebaseStorage.instance.ref();
    ref.child('EventCoverImage/$eo').child(widget.data['eventName']).getDownloadURL().then((fileURL) {
      setState(() {
        fileURL == null ? _uploadedFileURL = null : _uploadedFileURL = fileURL;
      });
    }).catchError((e){
      print(e.code);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 20, left: 15,right: 15),
      child: Row(children: <Widget>[
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: _uploadedFileURL == null ? AssetImage('assets/cover.jpeg') : NetworkImage(_uploadedFileURL)
            )
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Text(widget.data == null? '' : widget.data['eventName'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                width: double.infinity,
                child: Text(widget.data == null? '' : widget.data['dates'],textAlign: TextAlign.left,),
              ),
              Container(
                width: double.infinity,
                child: Text(widget.data == null? '' : widget.data['times']),
              )
            ],
          ),
            constraints: BoxConstraints(maxWidth: 150)
        ),
        Expanded(
          child: Container(
            height: 150,
            width: 100,
            child: IconButton(
                onPressed: (){
                  setNotifications();
                  switchOnOffNotification();
                },
                icon: notificationIcon == null ? Icon(Icons.notifications_off, size: 25,) :  notificationIcon,
            ),
          ),
        ),

      ],),
    );
  }
}
