import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:thesis_app/page/login.dart';

class EmailButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Builder(
        builder: (context) => SignInButton(
          Buttons.Email,
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                    builder: (context) => LoginPage()));
          },
        ),
      ),
    );
  }
}
