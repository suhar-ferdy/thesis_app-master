//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class CRUD {

  void create(var data, String tableName, String dataProperty) async{
//    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    FirebaseDatabase.instance
        .reference()
        .child(tableName)
        .child(data[dataProperty])
        .set(data);
  }
  void createPushNotification(var data, String tableName, String dataProperty) async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    FirebaseDatabase.instance
        .reference()
        .child('$tableName/$uid')
        .push().set(data);
  }

  void readDuplicateAndCreatePushNotification(var data, String tableName, String dataProperty) async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    var abort = false;
    var usersRef = FirebaseDatabase.instance.reference().child('$tableName/$uid');
    usersRef.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      try{
        values.forEach((key,values) {
          if(values['eventName'] == data['eventName']){
            abort = true;
          }
        });
      }
      catch(e){
        print(e);
      }
    }).whenComplete((){
      if(abort == false){
        createPushNotification(data, tableName, dataProperty);
        Fluttertoast.showToast(
            msg: "Added to favorites",
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

  void readDuplicateAndCreate(var data, String tableName, String dataProperty) async{
    var val;
    var usersRef = FirebaseDatabase.instance.reference().child(tableName).child(data[dataProperty]);
    usersRef.once().then((DataSnapshot snapshot){
      val = snapshot.value;
    }).whenComplete((){
      if(val == null){
        print('safe');
        create(data, tableName, dataProperty);
        Fluttertoast.showToast(
            msg: "Event registered",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );

      }
      else{
        Fluttertoast.showToast(
            msg: "Event name already exists",
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
}