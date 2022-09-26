import 'package:flutter/material.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/home.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/notification.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/profile.dart';

// ignore: camel_case_types
class home_screen extends StatefulWidget {
  const home_screen({Key? key}) : super(key: key);
  static const String id = "home_screen";
  static const routeName = "home_screen";

  @override
  State<home_screen> createState() => _home_screenState();
}

// ignore: camel_case_types
class _home_screenState extends State<home_screen> {
  int currentIndex = 0;
  //contents
  static const List<Widget> _screens = <Widget>[
    homePage(),
    categoryPage(),
    notificationPage(),
    profilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC21010),
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text("Buyer Home Screen"),
        ),
      ),
      body: _screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Color(0xFFC21010),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Videos",
            backgroundColor: Color(0xFFC21010),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notification",
            backgroundColor: Color(0xFFC21010),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Color(0xFFC21010),
          ),
        ],
      ),
    );
  }
}
