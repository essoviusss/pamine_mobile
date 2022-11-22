import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/model/transaction_model.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Column(
      children: [
        Container(
          child: StreamBuilder<dynamic>(
              stream: FirebaseFirestore.instance
                  .collection("transactions")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("waiting...");
                } else {
                  return Container(
                    height: heightVar / 2,
                    margin: EdgeInsets.only(
                      top: heightVar / 60,
                      left: widthVar / 25,
                      right: widthVar / 25,
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          Transactions transaction = Transactions.fromMap(
                              snapshot.data.docs[index].data());
                          return Container(
                            height: heightVar / 7,
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
                              bottom: heightVar / 80,
                            ),
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: widthVar / 25,
                                  right: widthVar / 25,
                                  top: heightVar / 80,
                                  bottom: heightVar / 80),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order Details",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "Order Id: ${transaction.TransactionId}"),
                                  Text("Name: ${transaction.BuyerName}"),
                                  Text(
                                      "Price: ₱${transaction.TransactionTotalPrice.toString()}.00"),
                                  Text(
                                      "Date: ${transaction.TransactionDate.toDate()}"),
                                  Text("Status: Pending")
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }
                return Container();
              }),
        )
      ],
    ));
  }
}
