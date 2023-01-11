import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReturnActions extends StatefulWidget {
  final String? buyerName,
      productId,
      productImageUrl,
      productName,
      rUrl,
      returnDetails;

  const ReturnActions({
    super.key,
    required this.buyerName,
    required this.productId,
    required this.productImageUrl,
    required this.productName,
    required this.rUrl,
    required this.returnDetails,
  });

  @override
  State<ReturnActions> createState() => _ReturnActionsState();
}

class _ReturnActionsState extends State<ReturnActions> {
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(
            left: widthVar / 25, right: widthVar / 25, top: heightVar / 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: heightVar / 60,
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "Return Details",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            Row(
              children: [
                Image.network(
                  widget.productImageUrl!,
                  height: 60,
                  width: 60,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Product Name: ${widget.productName!}"),
                        Text("Buyer Name: ${widget.buyerName!}"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            Text(
              "Return Details: ${widget.returnDetails!}",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            Image.network(widget.rUrl!),
            SizedBox(
              height: heightVar / 60,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        FirebaseFirestore.instance
                            .collection("seller_info")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("returns")
                            .doc(widget.productId)
                            .set(
                          {
                            "returnStatus": "rejected",
                          },
                          SetOptions(merge: true),
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Reject Request",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: widthVar / 12, vertical: 12),
                            ),
                          ),
                          onPressed: () async {
                            FirebaseFirestore.instance
                                .collection("seller_info")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("returns")
                                .doc(widget.productId)
                                .set(
                              {
                                "returnStatus": "accepted",
                              },
                              SetOptions(merge: true),
                            );
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Accept Request",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
