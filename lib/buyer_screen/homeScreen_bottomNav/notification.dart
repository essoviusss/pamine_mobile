import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/my_orders_components/all_orders.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/my_orders_components/my_orders.dart';

// ignore: camel_case_types
class notificationPage extends StatefulWidget {
  const notificationPage({Key? key}) : super(key: key);

  @override
  State<notificationPage> createState() => _notificationPageState();
}

// ignore: camel_case_types
class _notificationPageState extends State<notificationPage> {
  final buyerOrderStatus =
      FirebaseFirestore.instance.collectionGroup("transactionList");
  String? accepted = "order details";
  String? rejected = "rejection details";
  bool? isClick = false;
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Notifications"),
        centerTitle: true,
        backgroundColor: const Color(0xFFC21010),
      ),
      body: StreamBuilder<dynamic>(
        stream: buyerOrderStatus.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("waiting...");
          } else if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                final orderData = snapshot.data.docs[index];
                final checkBuyer = orderData['buyerUid'];
                final buyerUid = FirebaseAuth.instance.currentUser!.uid;
                final checkStatus = orderData['status'];
                return Expanded(
                  child: checkBuyer == buyerUid && checkStatus == "accepted" ||
                          checkStatus == "rejected"
                      ? InkWell(
                          onTap: () {
                            checkStatus == "accepted"
                                ? Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const MyOrders()))
                                : checkStatus == "rejected"
                                    ? showBarModalBottomSheet(
                                        expand: true,
                                        context: context,
                                        backgroundColor: Colors.white,
                                        builder: (context) => Container(),
                                      )
                                    : Container();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  spreadRadius: 0.1,
                                  blurStyle: BlurStyle.normal,
                                  color: Colors.grey,
                                  blurRadius: 10,
                                  offset: Offset(4, 8),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(
                                left: widthVar / 35,
                                right: widthVar / 35,
                                top: heightVar / 100),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: widthVar / 35,
                                    ),
                                    Image.network(
                                      orderData['logoUrl'],
                                      height: 60,
                                      width: 60,
                                    ),
                                    SizedBox(
                                      width: widthVar / 15,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                            "Your order from ${orderData['businessName']}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          "has been ${orderData['status']}!!!",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Click to view $checkStatus details",
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Color(0xFFC21010)),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: const Icon(
                                          Icons.more_vert,
                                          color: Color(0xFFC21010),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: widthVar / 35,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
