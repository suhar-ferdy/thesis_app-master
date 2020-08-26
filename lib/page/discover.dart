import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thesis_app/page/event_details.dart';
import 'package:thesis_app/page/serch_result.dart';
import 'package:thesis_app/widget/botnavbar.dart';




class DiscoverPage extends StatefulWidget {

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

String _selectedCategory = "\#Any";
List category = ["\#Any","\#Culinary","\#Animal","\#Sports","\#Education","\#Music","\#Dance","\#Seminar","\#Tech", "\#Religion"];
TextEditingController distanceController = TextEditingController();

final dbRef = FirebaseDatabase.instance.reference().child("Events");
List list=new List();

class _DiscoverPageState extends State<DiscoverPage> {

  void initState(){
    loadEvents();
  }

  Duration timeDifference(int day, int month, int year, int hour, int minute){
    var dateEvent = DateTime(year,month,day,hour,minute);
    var date = DateTime.now();
    var val  = dateEvent.difference(date);
    return val;
  }

  static List getSuggestions(String query) {
    List matches = List();
    matches.addAll(list);

    matches.retainWhere((s) => s['eventName'].toLowerCase().contains(query.toLowerCase()) || s['address'].toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
  void loadEvents(){
    dbRef.once().then((DataSnapshot snapshot){
      list.clear();
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,values) {
        if(!timeDifference(values['day'], values['month'], values['year'], values['hour'], values['minute']).isNegative){
          setState(() {
            list.add(values);
          });
        }
      });
    }).whenComplete((){
      if(list.isEmpty){
        Fluttertoast.showToast(
            msg: "No Events",
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Container(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 20, right: 20,top: 50),
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          autofocus: false,
                          decoration: InputDecoration(
                              hintText: 'Search for...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                          )
                      ),
                      suggestionsCallback: (pattern) async {
                        return getSuggestions(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          leading: Icon(Icons.event),
                          title: Text(suggestion['eventName']),
                          subtitle: Text(suggestion['address']),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsPage(event: suggestion,)));
                      },
                    ),
                ),

                Container(
                  padding: EdgeInsets.only(top: 25,left: 20,right: 20),
                  width: double.infinity,
                  child: Text('Category',style: TextStyle(fontSize: 18,),),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10,left: 20,right: 20),
                  width: double.infinity,
                  child: DropdownButton(
                      isExpanded: true,
                      value: _selectedCategory,
                      items: category.map((value){
                        return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                        );
                      }).toList(),
                      onChanged: (value){
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                  )
                ),
                Container(
                  padding: EdgeInsets.only(top: 25,left: 20,right: 20),
                  width: double.infinity,
                  child: Text('Nearby events?',style: TextStyle(fontSize: 18,),),
                ),
                Container(
                    padding: EdgeInsets.only(top: 10,left: 20,right: 20),
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex : 2,
                            child: TextField(
                              autofocus: false,
                              controller: distanceController,
                              maxLength: 2,
                              decoration: InputDecoration(
                                hintText: "ex. 12",
                                counterText: "",
                              ),
                            )
                        ),
                        Expanded(
                            flex: 9,
                            child: Text("km")
                        )
                      ],
                    ),
                ),
                Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                      child: Container(
                        width: double.infinity,
                        child: RaisedButton(
                          padding: EdgeInsets.only(left: 30,right: 30,top: 20, bottom: 20),
                          onPressed: (){
                            int d;
                            if(distanceController.text == "")
                              d = 0;
                            if(distanceController.text != "")
                              d = int.parse(distanceController.text);

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  SearchResultPage(
                                    distance: d,
                                    data: list,
                                    category: _selectedCategory,
                                  )
                            ));
                          },
                          color: Colors.redAccent,
                          child: Text('Find things to do..', style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ),
                )
              ],
            ),
          ),
          bottomNavigationBar: BotNavBar(currIndex: 1,)
        ),
      ),
    );
  }
}
