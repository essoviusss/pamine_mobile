import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/home.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/liveStream.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/notification.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/products.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/profile.dart';

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
    ProductPage(),
    notificationPage(),
    profile(),
    LiveStreamScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: _screens[currentIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentIndex = 4;
            });
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.live_tv_sharp),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Material(
                  child: Center(
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          currentIndex = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.home),
                          Text("Home"),
                          //const Padding(padding: EdgeInsets.all(10))
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  child: Center(
                    child: InkWell(
                      focusColor: Colors.red,
                      hoverColor: Colors.red,
                      highlightColor: Colors.red,
                      onTap: () {
                        setState(() {
                          currentIndex = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add),
                          Text("Products"),
                          //const Padding(padding: EdgeInsets.only(left: 10))
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(), //to make space for the floating button
                Material(
                  child: Center(
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          currentIndex = 2;
                        });
                      },
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("transactions")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("transactionList")
                              .where("status", isEqualTo: "pending")
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            int? count = snapshot.data?.docs.length;
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              print("waiting...");
                            } else if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Badge(
                                    badgeColor: Colors.red,
                                    animationDuration:
                                        const Duration(seconds: 0),
                                    badgeContent: Center(child: Text('$count')),
                                    child: const Icon(
                                      Icons.notifications,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Text("Orders"),
                                ],
                              );
                            }
                            return Container();
                          }),
                    ),
                  ),
                ),
                Material(
                  child: Center(
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          currentIndex = 3;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.shop_2),
                          Text("Shop")
                          //const Padding(padding: EdgeInsets.only(left: 10))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
