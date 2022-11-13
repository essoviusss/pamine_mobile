import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DefaultDeliveryDetails extends StatefulWidget {
  const DefaultDeliveryDetails({super.key});

  @override
  State<DefaultDeliveryDetails> createState() => _DefaultDeliveryDetailsState();
}

class _DefaultDeliveryDetailsState extends State<DefaultDeliveryDetails> {
  final firestore = FirebaseFirestore.instance
      .collection("buyer_info")
      .doc(FirebaseAuth.instance.currentUser!.uid);
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: firestore
          .collection("default_delivery_details")
          .doc("default")
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("waiting...");
        }
        if (snapshot.data!.exists) {
          return Container(
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
                top: heightVar / 50, left: widthVar / 25, right: widthVar / 25),
            child: Column(
              children: [
                Container(
                  height: heightVar / 10,
                  margin: EdgeInsets.only(
                    top: heightVar / 100,
                    left: widthVar / 25,
                    right: widthVar / 25,
                    bottom: heightVar / 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data?['fullName'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: heightVar / 150,
                      ),
                      Text(
                        snapshot.data?['cpNumber'],
                        style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: heightVar / 150,
                      ),
                      Text(snapshot.data?["shippingAddress"]),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
