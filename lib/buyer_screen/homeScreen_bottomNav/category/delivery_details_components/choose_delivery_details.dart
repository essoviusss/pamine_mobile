import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pamine_mobile/model/delivery_details_model.dart';

class ChooseDeliveryDetails extends StatefulWidget {
  const ChooseDeliveryDetails({super.key});

  @override
  State<ChooseDeliveryDetails> createState() => _ChooseDeliveryDetailsState();
}

class _ChooseDeliveryDetailsState extends State<ChooseDeliveryDetails> {
  final firestore = FirebaseFirestore.instance
      .collection("buyer_info")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("delivery_details");
  final firestore1 = FirebaseFirestore.instance
      .collection("buyer_info")
      .doc(FirebaseAuth.instance.currentUser!.uid);
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return StreamBuilder<dynamic>(
      stream: firestore.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          print("waiting...");
        } else if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                DeliveryDetailsModel ship = DeliveryDetailsModel.fromMap(
                    snapshot.data?.docs[index].data());
                if (snapshot.hasData) {
                  return InkWell(
                    onTap: () {
                      firestore1
                          .collection("default_delivery_details")
                          .doc("default")
                          .set({
                        "fullName": ship.fullName,
                        "cpNumber": ship.cpNumber,
                        "shippingAddress": snapshot.data?.docs[index]
                            ['shippingAddress'],
                      }).then((value) {
                        Fluttertoast.showToast(
                            msg: "Default Delivery Details Added!");
                        Navigator.of(context).pop();
                      });
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
                            offset: Offset(4, 8), // Shadow position
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(
                          top: heightVar / 50,
                          left: widthVar / 25,
                          right: widthVar / 25),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            height: heightVar / 10,
                            margin: EdgeInsets.only(
                              top: heightVar / 100,
                              left: widthVar / 25,
                              right: widthVar / 25,
                              bottom: heightVar / 100,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ship.fullName!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: heightVar / 150,
                                ),
                                Text(
                                  ship.cpNumber!,
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: heightVar / 150,
                                ),
                                Text(snapshot.data?.docs[index]
                                    ["shippingAddress"]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          );
        }
        return Container();
      },
    );
    /**/
  }
}
