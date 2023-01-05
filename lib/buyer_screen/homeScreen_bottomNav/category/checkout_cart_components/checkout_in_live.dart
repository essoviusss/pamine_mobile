import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/model/mined_cart_model.dart';

class CheckoutInLive extends StatefulWidget {
  const CheckoutInLive({super.key});

  @override
  State<CheckoutInLive> createState() => _CheckoutInLiveState();
}

class _CheckoutInLiveState extends State<CheckoutInLive> {
  int? subtotal;
  int? minedCartBaseTotal;
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collectionGroup("minedProducts")
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        int? count = snapshot.data?.docs.length;
        final cartItems = snapshot.data?.docs.map((DocumentSnapshot doc) {
          MinedCartModel.fromMap(doc.data());
          subtotal = doc.get("productPrice");
        });

        minedCartBaseTotal =
            cartItems?.fold(0, (current, index) => current! + subtotal!);
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
                "Mined Cart",
                style: TextStyle(
                    color: Color(0xFFC21010),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text("Total Items: $count"),
              Text("Subtotal: ₱$minedCartBaseTotal.00"),
              const Text("Delivery Fee: Free Delivery"),
              Text("Total Price: ₱$minedCartBaseTotal.00",
                  style: const TextStyle(
                      color: Color(0xFFC21010), fontWeight: FontWeight.bold)),
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
