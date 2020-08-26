import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:thesis_app/firebase/authentication.dart';

class GoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Builder(
        builder: (context) => SignInButton(
          Buttons.GoogleDark,
          onPressed: () async {
            AuthMethod().googleSignIn();
          },
        ),
      ),
    );
  }
}
