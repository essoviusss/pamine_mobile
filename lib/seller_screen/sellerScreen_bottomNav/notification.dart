// ignore_for_file: use_build_context_synchronously

import 'package:animated_icon/animate_icon.dart';
import 'package:animated_icon/animate_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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

  CollectionReference orders = FirebaseFirestore.instance
      .collection("transactions")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("orders");

  final auth = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference sellerDetails =
      FirebaseFirestore.instance.collection("seller_info");

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Notifications"),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<dynamic>(
          stream: transactionRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print("waiting...");
            }
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  final transacData = snapshot.data.docs[index];
                  final checkStatus = snapshot.data.docs[index]['status'];
                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        //Modal start
                        showBarModalBottomSheet(
                          expand: true,
                          context: context,
                          backgroundColor: Colors.white,
                          builder: (context) => Container(
                            margin: EdgeInsets.only(
                                left: widthVar / 25, right: widthVar / 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: heightVar / 60,
                                ),
                                const Center(
                                  child: Text(
                                    "Order Details",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: heightVar / 60,
                                ),
                                Text(
                                    "Transaction Id: ${transacData['transactionId']}"),
                                Text("Buyer: ${transacData['buyerName']}"),
                                Text("Cp#: ${transacData['cpNum']}"),
                                Text(
                                    "Shipping Address: ${transacData['shippingAddress']}"),
                                Text(
                                    "Order Date: ${transacData['transactionDate'].toDate().toString()}"),
                                Text(
                                    "Total Price: ₱${transacData['transactionTotalPrice']}.00"),
                                Text(
                                    "Total Items: ${transacData['itemList'].length.toString()}"),
                                Text(
                                    "Admin Commision: ₱${transacData['total commision']}.00"),
                                Text("Status: ${transacData['status']}"),
                                SizedBox(
                                  height: heightVar / 60,
                                ),
                                const Text(
                                  "Ordered Items:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: transacData['itemList'].length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: heightVar / 80,
                                            ),
                                            Text(
                                                "Product Name: ${transacData['itemList'][index]['productName'].toString()}"),
                                            Text(
                                                "QTY: x${transacData['itemList'][index]['productQuantity'].toString()}"),
                                            Image.network(
                                              transacData['itemList'][index]
                                                  ['productImageUrl'],
                                              height: heightVar / 4,
                                              width: widthVar / 1,
                                            ),
                                            SizedBox(
                                              height: heightVar / 60,
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                                SizedBox(
                                  height: heightVar / 60,
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        DocumentSnapshot snapshot =
                                            await sellerDetails
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .get();
                                        String? businessName =
                                            snapshot['businessName'];
                                        String? logoUrl = snapshot['logoUrl'];
                                        transactionRef
                                            .doc(transacData.id)
                                            .update(
                                          {"status": "rejected"},
                                        );
                                        transactionRef.doc(transacData.id).set(
                                          {
                                            "businessName": businessName,
                                            "logoUrl": logoUrl,
                                          },
                                          SetOptions(merge: true),
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "Reject Order",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red),
                                            padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                              EdgeInsets.symmetric(
                                                  horizontal: widthVar / 12,
                                                  vertical: 12),
                                            ),
                                          ),
                                          onPressed: () async {
                                            DocumentSnapshot snapshot =
                                                await sellerDetails
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .get();
                                            String? businessName =
                                                snapshot['businessName'];
                                            String? logoUrl =
                                                snapshot['logoUrl'];
                                            transactionRef
                                                .doc(transacData.id)
                                                .update(
                                              {"status": "accepted"},
                                            );
                                            transactionRef
                                                .doc(transacData.id)
                                                .set(
                                              {
                                                "businessName": businessName,
                                                "logoUrl": logoUrl,
                                              },
                                              SetOptions(merge: true),
                                            );
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "Accept Order",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: heightVar / 30,
                                ),
                              ],
                            ),
                          ),
                        );
                      }, //modal end
                      child: checkStatus == "pending"
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    spreadRadius: 0.1,
                                    blurStyle: BlurStyle.normal,
                                    color: Colors.grey,
                                    blurRadius: 10,
                                    offset: Offset(4, 8), // Shadow position
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.only(
                                  left: widthVar / 35,
                                  right: widthVar / 35,
                                  top: heightVar / 100),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: heightVar / 70,
                                    width: widthVar / 25,
                                  ),
                                  Row(
                                    children: [
                                      AnimateIcon(
                                        key: UniqueKey(),
                                        onTap: () {},
                                        iconType: IconType.continueAnimation,
                                        height: 40,
                                        width: 40,
                                        color: Colors.red,
                                        animateIcon: AnimateIcons.bell,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: widthVar / 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "You have a new order!!!",
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "Buyer: ${transacData['buyerName']}"),
                                            Text(
                                                "Date: ${transacData['transactionDate'].toDate().toString()}"),
                                            Text(
                                                "Status: ${transacData['status']}"),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.more_vert,
                                                color: Colors.red,
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: heightVar / 70,
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                  );
                },
              );
            }
            return Container();
          }),
    );
  }
}
