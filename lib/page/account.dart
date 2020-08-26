import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thesis_app/firebase/authentication.dart';
import 'package:thesis_app/page/post_event.dart';
import 'package:thesis_app/widget/botnavbar.dart';



class AccountPage extends StatefulWidget {

  @override
  _AccountPageState createState() => _AccountPageState();
}


File _image;
String _uploadedFileURL;
final picker = ImagePicker();
FirebaseUser user;
var uid;
var userName;
StorageReference ref = FirebaseStorage.instance.ref();
class _AccountPageState extends State<AccountPage> {

  // ignore: must_call_super
  void initState(){
    loadUsername();
    if(_uploadedFileURL == null && _image == null)
        downloadFile();

  }
  void loadUsername() async{
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    userName = firebaseUser.email;
  }
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
      uploadFile();
    });
  }
  Future uploadFile() async {
    StorageUploadTask uploadTask = ref.child('Profile').child(uid).putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    downloadFile();
  }
  Future downloadFile() async{
    print('Download File');
    user = await FirebaseAuth.instance.currentUser();
    uid = user.uid;
    ref.child('Profile').child(uid).getDownloadURL().then((fileURL) {
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
          body: Container(
            padding: EdgeInsets.only(top: 100),
            child: Column(
              children: <Widget>[
                Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap:(){
                            getImage();
                          },
                          child: Container(
                              width: 200.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: _uploadedFileURL == null
                                          ? AssetImage('assets/person.png')
                                          : NetworkImage(_uploadedFileURL)
                                  )
                              ),

                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(userName != null ? userName : '', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        )
                      ],
                    )
                ),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(top: 30),
                        child: ListView(
                          children: <Widget>[
                            FlatButton.icon(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PostEventPage())
                                );
                              },
                              icon: Icon(Icons.add, size: 25,),
                              label: Text('Post Event', style: TextStyle(fontSize: 15),),
                            ),
                            FlatButton.icon(
                              onPressed: (){
                                AuthMethod().signOut(context);
                              },
                              icon: Icon(Icons.exit_to_app, size: 25,),
                              label: Text('Logout', style: TextStyle(fontSize: 15),),
                            ),
                          ],
                        )
                    )
                )
              ],
            ),
          ),
          bottomNavigationBar: BotNavBar(currIndex: 3,)
        ),
      ),
    );
  }
}
