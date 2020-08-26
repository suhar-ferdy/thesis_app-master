import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:thesis_app/page/event_details.dart';

class EventItem extends StatefulWidget {
  final event;
  EventItem({this.event});

  @override
  _EventItemState createState() => _EventItemState();
}

String _uploadedFileURL;

class _EventItemState extends State<EventItem> {
  @override

  void initState(){
    downloadFile();
  }
  Future downloadFile() async{
    print('Download File');
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var eo = widget.event['user'];
    StorageReference ref = FirebaseStorage.instance.ref();
    ref.child('EventCoverImage/$eo').child(widget.event['eventName']).getDownloadURL().then((fileURL) {
      setState(() {
        fileURL == null ? _uploadedFileURL = null : _uploadedFileURL = fileURL;
      });
    }).catchError((e){
      print(e.code);
    });
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 10,left: 20,right: 20),
      child: Material(
        child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsPage(event: widget.event,)));
            },
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: _uploadedFileURL == null ? AssetImage('assets/cover.jpeg') : NetworkImage(_uploadedFileURL)
                      )
                  ),
                  width: MediaQuery.of(context).size.width * 40/100,
                  height: 150,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 10,bottom: 40),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20))
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10,bottom: 10,top: 5),
                          width: double.infinity,
                          child: Text(widget.event['eventName'] == null ? '' : widget.event['eventName'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          width: double.infinity,
                          child: Text(widget.event['address'] == null ? '' : widget.event['address'],style: TextStyle(fontSize: 14, color: Colors.blueAccent),),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          width: double.infinity,
                          child: Text(widget.event['category'] == null ? '' : widget.event['category'],style: TextStyle(fontSize: 12),),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
        ),
      ),

    );
  }
}
