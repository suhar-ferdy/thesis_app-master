import 'package:flutter/material.dart';
import 'package:thesis_app/page/account.dart';
import 'package:thesis_app/page/discover.dart';
import 'package:thesis_app/page/home.dart';
import 'package:thesis_app/page/notifications.dart';


class BotNavBar extends StatelessWidget {
  final currIndex;
  BotNavBar({this.currIndex});
  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index){
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (context,animation, secondaryAnimation) {
                Widget widget;
                switch (index){
                  case 0 : widget = HomePage(); break;
                  case 1 : widget = DiscoverPage(); break;
                  case 2 : widget = NotificationsPage(); break;
                  case 3 : widget = AccountPage(); break;

                }
                return widget;
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var begin = Offset(0, 0);
                var end = Offset.zero;
                var curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              }
          )
      );
    }
    return BottomNavigationBar(
      selectedItemColor: Colors.blue,
      onTap: onItemTapped,
      currentIndex: currIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text('Discovers'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          title: Text('Notifications'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Account'),
        ),
      ],
    );
  }
}
