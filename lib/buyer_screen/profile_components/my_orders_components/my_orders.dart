import 'package:flutter/material.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/my_orders_components/all_orders.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/my_orders_components/delivered.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/my_orders_components/processing.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/my_orders_components/rejected.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFC21010),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text("My Orders"),
          bottom: const TabBar(
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            )),
            tabs: [
              Tab(
                child: Text(
                  "All Orders",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text("Rejected",
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              Tab(
                child: Text("Processing",
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              Tab(
                child: Text("Delivered",
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AllOrders(),
            Rejected(),
            Processing(),
            Delivered(),
          ],
        ),
      ),
    );
  }
}
