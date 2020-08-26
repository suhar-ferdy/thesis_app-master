import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white
      ),
      child: Text('Chip'),
    );
  }
}
