// ignore_for_file: use_build_context_synchronously

import 'package:animated_icon/animate_icon.dart';
import 'package:animated_icon/animate_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/my_orders_components/delivered.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/notification_components/accepted.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/notification_components/pending_orders.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/notification_components/shipped.dart';

class notificationPage extends StatefulWidget {
  const notificationPage({super.key});

  @override
  State<notificationPage> createState() => _notificationPageState();
}

class _notificationPageState extends State<notificationPage> {
  CollectionReference transactionRef = FirebaseFirestore.instance
      .collection("transactions")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("transactionList");

  final auth = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference sellerDetails =
      FirebaseFirestore.instance.collection("seller_info");

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text("Orders"),
          bottom: const TabBar(
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            )),
            tabs: [
              Tab(
                child: Text(
                  "Pending",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text("Accepted",
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              Tab(
                child: Text("Shipped Out",
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              Tab(
                child: Text("Delivered",
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PendingOrders(),
            Accepted(),
            Shipped(),
            Delivered(),
          ],
        ),
      ),
    );
  }
}
