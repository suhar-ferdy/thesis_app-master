import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: 'Event ',
              style: TextStyle(color: Colors.white, fontSize: 56),
              children: <TextSpan>[
                TextSpan(text: 'plaza', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black)),
              ],
            ),
          ),
          Text('The better way to improve your life',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
        ],
      ),
    );
  }
}
