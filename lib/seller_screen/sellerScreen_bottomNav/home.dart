// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/dashboard_components/live_details.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/dashboard_components/total_sale.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String? docName = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference sellerInfo =
      FirebaseFirestore.instance.collection("seller_info");

  final pendingRef = FirebaseFirestore.instance
      .collection("transactions")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("transactionList")
      .where("status", isEqualTo: "pending");
  final acceptedRef = FirebaseFirestore.instance
      .collection("transactions")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("transactionList")
      .where("status", isEqualTo: "accepted");
  final shippedRef = FirebaseFirestore.instance
      .collection("transactions")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("transactionList")
      .where("status", isEqualTo: "processing");
  final deliveredRef = FirebaseFirestore.instance
      .collection("transactions")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("transactionList")
      .where("status", isEqualTo: "delivered");

  String? month = DateTime.now().month.toString();
  String? day = DateTime.now().day.toString();
  String? year = DateTime.now().year.toString();
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text("Dashboard"),
        ),
      ),
      body: StreamBuilder<dynamic>(
          stream: sellerInfo.doc(docName).snapshots(),
          builder: (context, snapshot) {
            final sellerName = snapshot.data?['businessOwnerName'];
            final dash = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting) {
              print("waiting...");
            } else if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                      left: widthVar / 25,
                      right: widthVar / 25,
                      top: heightVar / 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(dash?['logoUrl']),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Column(
                                children: [
                                  Text(
                                    "Hello, $sellerName",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "0$month/0$day/$year",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(0.4)),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: heightVar / 100,
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [
                              0.3,
                              0.7,
                            ],
                            colors: [
                              Colors.red,
                              Colors.red.shade200,
                            ],
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                            left: widthVar / 35,
                            right: widthVar / 35,
                            top: heightVar / 60,
                            bottom: heightVar / 60,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Order Status",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: const Text(
                                        "Total",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: heightVar / 100,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Pending",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  StreamBuilder<dynamic>(
                                    stream: pendingRef.snapshots(),
                                    builder: (context, snapshot) {
                                      int? pendingCount =
                                          snapshot.data?.docs.length;
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        print("waiting...");
                                      } else if (!snapshot.hasData) {
                                        return const CircularProgressIndicator();
                                      } else {
                                        return Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              pendingCount.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: heightVar / 100,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Accepted",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  StreamBuilder<dynamic>(
                                    stream: acceptedRef.snapshots(),
                                    builder: (context, snapshot) {
                                      int? pendingCount =
                                          snapshot.data?.docs.length;
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        print("waiting...");
                                      } else if (!snapshot.hasData) {
                                        return const CircularProgressIndicator();
                                      } else {
                                        return Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              pendingCount.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: heightVar / 100,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Shipped",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  StreamBuilder<dynamic>(
                                    stream: shippedRef.snapshots(),
                                    builder: (context, snapshot) {
                                      int? pendingCount =
                                          snapshot.data?.docs.length;
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        print("waiting...");
                                      } else if (!snapshot.hasData) {
                                        return const CircularProgressIndicator();
                                      } else {
                                        return Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              pendingCount.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: heightVar / 100,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Delivered",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  StreamBuilder<dynamic>(
                                    stream: deliveredRef.snapshots(),
                                    builder: (context, snapshot) {
                                      int? pendingCount =
                                          snapshot.data?.docs.length;
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        print("waiting...");
                                      } else if (!snapshot.hasData) {
                                        return const CircularProgressIndicator();
                                      } else {
                                        return Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              pendingCount.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const TotalSales(),
                      SizedBox(
                        height: heightVar / 60,
                      ),
                      const LiveDetails(),
                      SizedBox(
                        height: heightVar / 40,
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
          }),
    );
  }
}
