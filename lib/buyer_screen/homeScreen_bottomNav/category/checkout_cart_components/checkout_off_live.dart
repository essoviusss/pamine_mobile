// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/model/cart_model.dart';

class CheckoutOffLive extends StatefulWidget {
  const CheckoutOffLive({super.key});

  @override
  State<CheckoutOffLive> createState() => _CheckoutOffLiveState();
}

class _CheckoutOffLiveState extends State<CheckoutOffLive> {
  int? subtotal;
  int? cartBaseTotal;

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return StreamBuilder<dynamic>(
      stream: FirebaseFirestore.instance
          .collection("buyer_info")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("cart")
          .snapshots(),
      builder: (context, snapshot) {
        int? count = snapshot.data?.docs.length;
        final cartTotal = snapshot.data?.docs.map((DocumentSnapshot doc) {
          CartModel.fromMap(doc.data());
          subtotal = doc.get("subtotal");
        });
        cartBaseTotal =
            cartTotal?.fold(0, (current, index) => current + subtotal);
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("waiting...");
        }
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: heightVar / 100,
              ),
              const Text(
                "Items Cart",
                style: TextStyle(
                    color: Color(0xFFC21010),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text("Total Items: $count"),
              Text("Subtotal: ₱$cartBaseTotal.00"),
              const Text("Delivery Fee: Free Delivery"),
              Text(
                "Total Price: ₱$cartBaseTotal.00",
                style: const TextStyle(
                    color: Color(0xFFC21010), fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: heightVar / 100,
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
