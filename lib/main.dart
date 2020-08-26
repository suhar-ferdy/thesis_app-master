import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thesis_app/page/home.dart';
import 'package:thesis_app/page/login_selection.dart';

//void main() => runApp(MyApp());

void main(){
  WidgetsFlutterBinding.ensureInitialized();

  runApp(FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
        if (snapshot.hasData){
//          FirebaseUser user = snapshot.data; // this is your user instance
          /// is because there is user already logged
          return HomePage();
        }
        /// other way there is no user logged.
        return LoginSelectionPage();
      }
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp();
  }
}
