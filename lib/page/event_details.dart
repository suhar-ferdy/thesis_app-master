import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thesis_app/firebase/crud.dart';

class EventDetailsPage extends StatefulWidget {
  final event;
  EventDetailsPage({this.event});
  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}
String _uploadedFileURL;

class _EventDetailsPageState extends State<EventDetailsPage> {

  void initState(){
    downloadFile();
  }

  Future downloadFile() async{
    print('Download File');
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    StorageReference ref = FirebaseStorage.instance.ref();
    ref.child('EventCoverImage/$uid').child(widget.event['eventName']).getDownloadURL().then((fileURL) {
      setState(() {
        fileURL == null ? _uploadedFileURL = null : _uploadedFileURL = fileURL;
      });
    }).catchError((e){
      print(e.code);
    });
  }

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children:[
              Expanded(
                flex: 5,
                child: ListView(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: _uploadedFileURL == null ? AssetImage('assets/cover.jpeg') : NetworkImage(_uploadedFileURL)
                          ),
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.black
                              )
                          )
                      ),
                      height: MediaQuery.of(context).size.height * 40/100,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 55/100,top: 10,right: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.date_range),
                          Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(widget.event['dates'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, ),)
                          ),
                        ],
                      )
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(widget.event['eventName'],
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent
                          ),
                        ),
                      ),

                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(widget.event['address'],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent
                          ),
                        ),
                      ),

                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: FlatButton.icon(
                          onPressed: (){},
                          icon: Icon(Icons.alarm),
                          label: Text(widget.event['times'])
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                      child: Text(widget.event['category'])
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20,left: 10, right: 10),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(widget.event['description'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                  child: Container(
                    width: double.infinity,
                    child: RaisedButton(
                      padding: EdgeInsets.only(left: 30,right: 30,top: 20, bottom: 20),
                      onPressed: (){
                        CRUD().readDuplicateAndCreatePushNotification(widget.event, 'Notification', widget.event['eventName']);
                      },
                      color: Colors.redAccent,
                      child: Text('Add to favourites..', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
              )

            ]
          ),
        ),
      ),
    );
  }
}
