import 'package:flutter/material.dart';
import 'package:pamine_mobile/seller_screen/profile_components/returnRequest_components/returns.dart';
import 'package:pamine_mobile/seller_screen/profile_components/returnRequest_components/sellerProcessing.dart';
import 'package:pamine_mobile/seller_screen/profile_components/returnRequest_components/sellerRejected.dart';
import 'package:pamine_mobile/seller_screen/profile_components/returnRequest_components/sellerReturned.dart';

class ReturnedOrders extends StatefulWidget {
  const ReturnedOrders({super.key});

  @override
  State<ReturnedOrders> createState() => _ReturnedOrdersState();
}

class _ReturnedOrdersState extends State<ReturnedOrders> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text("Returns/Cancellations"),
          bottom: const TabBar(
            isScrollable: true,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            )),
            tabs: [
              Tab(
                child: Text(
                  "Requests",
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
                child: Text("Returned",
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Returns(),
            SellerRejected(),
            SellerProcessing(),
            SellerReturned(),
          ],
        ),
      ),
    );
    ;
  }
}
