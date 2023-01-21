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
        stream: buyerOrderStatus
            .where("buyerUid",
                isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
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
                String? buyerName = orderData['buyerName'];
                final checkBuyer = orderData['buyerUid'];
                final buyerUid = FirebaseAuth.instance.currentUser!.uid;
                final checkStatus = orderData['status'];
                return Expanded(
                  child: checkStatus == "accepted" || checkStatus == "rejected"
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
                                        builder: (context) => Container(
                                          margin: EdgeInsets.only(
                                              left: widthVar / 25,
                                              right: widthVar / 25),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: heightVar / 60,
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  "Rejection Details",
                                                  style: TextStyle(
                                                      color: Color(0xFFC21010),
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                height: heightVar / 60,
                                              ),
                                              Text(
                                                "Hi,$buyerName, we are deeply sorry about the rejection of your order, due to the following reasons;",
                                                textAlign: TextAlign.justify,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "      • ${orderData['rejectionDetails']}",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: heightVar / 60,
                                              ),
                                              const Text(
                                                "Order Details",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: heightVar / 60,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "Transaction Id: ${orderData['transactionId']}"),
                                                  Text(
                                                      "Buyer: ${orderData['buyerName']}"),
                                                  Text(
                                                      "Total Price: ₱${orderData['transactionTotalPrice']}.00"),
                                                  Text(
                                                      "Total Items: ${orderData['itemList'].length.toString()}"),
                                                  SizedBox(
                                                    height: heightVar / 60,
                                                  ),
                                                  const Text(
                                                    "Ordered Items:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        orderData['itemList']
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height:
                                                                heightVar / 80,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Image.network(
                                                                orderData['itemList']
                                                                        [index][
                                                                    'productImageUrl'],
                                                                height: 60,
                                                                width: 60,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          "Product Name: ${orderData['itemList'][index]['productName'].toString()}"),
                                                                      Text(
                                                                          "QTY: x${orderData['itemList'][index]['productQuantity'].toString()}"),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                heightVar / 60,
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
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
