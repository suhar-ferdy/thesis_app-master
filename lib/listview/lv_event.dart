import 'package:flutter/material.dart';
import 'package:thesis_app/widget/event_item.dart';

class EventLV extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (BuildContext ctx, int index){
        return EventItem();
      },
    );
  }
}
