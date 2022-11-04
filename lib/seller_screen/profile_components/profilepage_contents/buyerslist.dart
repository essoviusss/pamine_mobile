import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BuyersList extends StatelessWidget {
  const BuyersList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("seller_info")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("mined_products_list")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            Fluttertoast.showToast(msg: "waiting...");
          } else {
            return Container();
          }
          return Container();
        });
  }
}
