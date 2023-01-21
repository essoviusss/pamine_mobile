import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SellerReturned extends StatefulWidget {
  const SellerReturned({super.key});

  @override
  State<SellerReturned> createState() => _SellerReturnedState();
}

class _SellerReturnedState extends State<SellerReturned> {
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
                            onTap: () {},
                            child: ret['returnStatus'] == "returned"
                                ? Expanded(
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: const [
                                            BoxShadow(
                                              spreadRadius: 0.1,
                                              blurStyle: BlurStyle.normal,
                                              color: Colors.grey,
                                              blurRadius: 10,
                                              offset: Offset(
                                                  4, 8), // Shadow position
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.only(
                                            left: widthVar / 35,
                                            right: widthVar / 35,
                                            top: heightVar / 100),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: heightVar / 60,
                                            ),
                                            const Text(
                                              "Item/s returned",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: heightVar / 60,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: widthVar / 25),
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "Transaction Id: ${ret['transactionId']}"),
                                                  Text(
                                                      "Buyer Name: ${ret['buyerName']}"),
                                                  const Text(
                                                      "Status: Processing"),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: heightVar / 60,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: widthVar / 25),
                                              alignment: Alignment.centerLeft,
                                              child: const Text(
                                                "Items to return: ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              ),
                                            ),
                                            SizedBox(
                                              height: heightVar / 60,
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: ret['itemList'].length,
                                              itemBuilder: (context, index) {
                                                String? sellerUid =
                                                    ret['itemList'][index]
                                                        ['sellerUid'];
                                                String? productId =
                                                    ret['itemList'][index]
                                                        ['productId'];
                                                return Container(
                                                  margin: EdgeInsets.only(
                                                    left: widthVar / 25,
                                                    right: widthVar / 25,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: heightVar / 80,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Image.network(
                                                            ret['itemList']
                                                                    [index][
                                                                'productImageUrl'],
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
                                                                      "Product Name: ${ret['itemList'][index]['productName'].toString()}"),
                                                                  Text(
                                                                      "Quantity: ${ret['itemList'][index]['productQuantity'].toString()}"),
                                                                  Text(
                                                                      "Item Price: ₱${ret['itemList'][index]['productPrice'].toString()}.00"),
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
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(
                                              height: heightVar / 100,
                                            ),
                                          ],
                                        ),
                                      ),
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
