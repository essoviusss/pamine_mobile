import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pamine_mobile/seller_screen/profile_components/returnRequest_components/returnActions.dart';

class Returns extends StatefulWidget {
  const Returns({super.key});

  @override
  State<Returns> createState() => _ReturnsState();
}

class _ReturnsState extends State<Returns> {
  final returnRef = FirebaseFirestore.instance
      .collection("seller_info")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("returns");
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder<dynamic>(
              stream: returnRef.snapshots(),
              builder: (context, snapshot) {
                final itemCount = snapshot.data?.docs.length;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("waiting...");
                } else if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final ret = snapshot.data?.docs[index];
                      return Expanded(
                        child: InkWell(
                            onTap: () {
                              showBarModalBottomSheet(
                                expand: true,
                                context: context,
                                backgroundColor: Colors.white,
                                builder: (context) => ReturnActions(
                                  buyerName: ret['buyerName'],
                                  rUrl: ret['rUrl'],
                                  returnDetails: ret['returnDetails'],
                                  totalItems: ret['itemList'].length,
                                  transactionId: ret['transactionId'],
                                  transactionTotalPrice:
                                      ret['transactionTotalPrice'],
                                  itemList: ret['itemList'],
                                ),
                              );
                            },
                            child: ret['returnStatus'] == "none"
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
                                          offset: Offset(4, 8),
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.only(
                                        left: widthVar / 35,
                                        right: widthVar / 35,
                                        top: heightVar / 100),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: widthVar / 35,
                                            ),
                                            const Icon(
                                              Icons.notifications,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              width: widthVar / 10,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                    "${ret['buyerName']} is requesting ",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const Text(
                                                    "to return the item to you",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const Text(
                                                  "Click to view details",
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Color(0xFFC21010)),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: const Icon(
                                                  Icons.more_vert,
                                                  color: Color(0xFFC21010),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: widthVar / 35,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                : Container()),
                      );
                    },
                  );
                }
                return Container();
              })
        ],
      ),
    );
  }
}
