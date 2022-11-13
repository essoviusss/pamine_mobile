import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/delivery_details_components/delivery_details.dart';
import 'package:pamine_mobile/model/delivery_details_model.dart';

class AddDeliveryDetails extends StatefulWidget {
  const AddDeliveryDetails({super.key});

  @override
  State<AddDeliveryDetails> createState() => _AddDeliveryDetailsState();
}

class _AddDeliveryDetailsState extends State<AddDeliveryDetails> {
  final firestore = FirebaseFirestore.instance
      .collection("buyer_info")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("delivery_details");

  deleteDeliveryDetails(String id) async {
    await firestore.doc(id).delete().then((value) {
      Fluttertoast.showToast(msg: "Info Deleted!");
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC21010),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text("Delivery Details"),
      ),
      body: StreamBuilder<dynamic>(
        stream: firestore.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("waiting...");
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DeliveryDetailsModel ship = DeliveryDetailsModel.fromMap(
                    snapshot.data.docs[index].data());
                if (snapshot.hasData) {
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
                        top: heightVar / 50,
                        left: widthVar / 25,
                        right: widthVar / 25),
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
                              Row(
                                children: [
                                  Text(
                                    ship.fullName!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.edit,
                                      color: Color(0xFFC21010),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          deleteDeliveryDetails(
                                              snapshot.data.docs[index].id);
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Color(0xFFC21010),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
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
                              Text(
                                  snapshot.data.docs[index]["shippingAddress"]),
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
          return Container();
        },
      ),
      persistentFooterButtons: [
        Column(
          children: [
            Center(
              child: IconButton(
                iconSize: 70,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const DeliveryDetails()),
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey,
                ),
              ),
            ),
            const Text("Add Delivery Details")
          ],
        ),
      ],
    );
  }
}
