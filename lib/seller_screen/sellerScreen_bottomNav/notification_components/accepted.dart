import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Accepted extends StatefulWidget {
  const Accepted({super.key});

  @override
  State<Accepted> createState() => _AcceptedState();
}

class _AcceptedState extends State<Accepted> {
  CollectionReference transactionRef = FirebaseFirestore.instance
      .collection("transactions")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("transactionList");

  final auth = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder<dynamic>(
          stream: transactionRef.snapshots(),
          builder: (context, snapshot) {
            int? itemCount = snapshot.data?.docs.length;
            if (snapshot.connectionState == ConnectionState.waiting) {
              print("waiting...");
            } else if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    final transacData = snapshot.data?.docs[index];
                    return Expanded(
                      child: transacData['status'] == "accepted"
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
                                  top: heightVar / 100,
                                  bottom: heightVar / 100),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: heightVar / 100,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Order Details',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: heightVar / 100,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: widthVar / 35,
                                      right: widthVar / 35,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Transaction Id: ${transacData['transactionId']}"),
                                        Text(
                                            "Buyer: ${transacData['buyerName']}"),
                                        Text("Cp#: ${transacData['cpNum']}"),
                                        Text(
                                            "Shipping Address: ${transacData['shippingAddress']}"),
                                        Text(
                                            "Order Date: ${transacData['transactionDate'].toDate().toString()}"),
                                        Text(
                                            "Total Price: ₱${transacData['transactionTotalPrice']}.00"),
                                        Text(
                                            "Total Items: ${transacData['itemList'].length.toString()}"),
                                        SizedBox(
                                          height: heightVar / 60,
                                        ),
                                        const Text(
                                          "Items to Deliver:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              transacData['itemList'].length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: heightVar / 80,
                                                ),
                                                Row(
                                                  children: [
                                                    Image.network(
                                                      transacData['itemList']
                                                              [index]
                                                          ['productImageUrl'],
                                                      height: 60,
                                                      width: 60,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                "Product Name: ${transacData['itemList'][index]['productName'].toString()}"),
                                                            Text(
                                                                "QTY: x${transacData['itemList'][index]['productQuantity'].toString()}"),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: heightVar / 60,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 0.3,
                                        ),
                                        Row(
                                          children: [
                                            TextButton(
                                                onPressed: () {},
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                                            Expanded(
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  Colors.red),
                                                      padding:
                                                          MaterialStateProperty
                                                              .all<EdgeInsets>(
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                widthVar / 12,
                                                            vertical: 12),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      transactionRef
                                                          .doc(transacData.id)
                                                          .update({
                                                        "status": "processing"
                                                      });
                                                    },
                                                    child: const Text(
                                                        'Ship Order',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: heightVar / 60,
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    );
                  });
            }
            return Container();
          }),
    );
  }
}
