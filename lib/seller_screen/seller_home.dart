import 'package:flutter/material.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/home.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/notification.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/products.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/profile.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/videos.dart';

// ignore: camel_case_types
class seller_home extends StatefulWidget {
  const seller_home({Key? key}) : super(key: key);
  static const String id = "home_screen";
  static const routeName = "home_screen";

  @override
  State<seller_home> createState() => _seller_screenState();
}

// ignore: camel_case_types
class _seller_screenState extends State<seller_home> {
  int currentIndex = 0;
  //contents
  static const List<Widget> _screens = <Widget>[
    homePage(),
    products(),
    videos(),
    notificationPage(),
    profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text("Seller Home Screen"),
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
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Products",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_settings),
            label: "Videos",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add),
            label: "Notification",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profile",
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
