import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/my_orders_components/return/return_details.dart';

class ReturnProduct extends StatefulWidget {
  const ReturnProduct({super.key});

  @override
  State<ReturnProduct> createState() => _ReturnProductState();
}

class _ReturnProductState extends State<ReturnProduct> {
  final productsRef =
      FirebaseFirestore.instance.collectionGroup("transactionList");
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return SizedBox(
      height: heightVar / 1,
      child: StreamBuilder<dynamic>(
        stream: productsRef.snapshots(),
        builder: (context, snapshot) {
          final count = snapshot.data?.docs.length;
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("waiting...");
          } else if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: count,
              itemBuilder: (context, index) {
                final reviewData = snapshot.data?.docs[index];
                return Container(
                  child: reviewData['status'] == "processing" &&
                          reviewData['buyerUid'] ==
                              FirebaseAuth.instance.currentUser!.uid
                      ? Column(
                          children: [
                            SizedBox(
                              height: heightVar / 60,
                            ),
                            const Text(
                              "Select a product to return",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color(0xFFC21010)),
                            ),
                            SizedBox(
                              height: heightVar / 60,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: reviewData['itemList'].length,
                              itemBuilder: (context, index) {
                                final reviewData1 =
                                    reviewData['itemList'][index];
                                return InkWell(
                                  onTap: () {
                                    showBarModalBottomSheet(
                                      expand: true,
                                      context: context,
                                      backgroundColor: Colors.white,
                                      builder: (context) => ReturnDetails(
                                        productId: reviewData1['productId'],
                                        productImageUrl:
                                            reviewData1['productImageUrl'],
                                        productName: reviewData1['productName'],
                                        sellerUid: reviewData1['sellerUid'],
                                        subtotal: reviewData1['subtotal'],
                                        quantity:
                                            reviewData1['productQuantity'],
                                        shopName: reviewData['businessName'],
                                        buyerName: reviewData['buyerName'],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    margin: EdgeInsets.only(
                                        left: widthVar / 35,
                                        right: widthVar / 35,
                                        top: heightVar / 100),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: heightVar / 80,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: widthVar / 35,
                                              right: widthVar / 35),
                                          child: Row(
                                            children: [
                                              Image.network(
                                                reviewData['itemList'][index]
                                                    ['productImageUrl'],
                                                height: 60,
                                                width: 60,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: widthVar / 25),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "Product Name: ${reviewData['itemList'][index]['productName'].toString()}"),
                                                    Text(
                                                        "Price: ₱${reviewData['itemList'][index]['productPrice'].toString()}.00"),
                                                    Text(
                                                        "QTY: x${reviewData['itemList'][index]['productQuantity'].toString()}"),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: const Icon(
                                                  Icons.keyboard_return,
                                                  color: Colors.grey,
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: heightVar / 60,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : Container(),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
