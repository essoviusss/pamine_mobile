import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/my_orders_components/review_products/add_review.dart';

class Delivered extends StatefulWidget {
  const Delivered({super.key});

  @override
  State<Delivered> createState() => _DeliveredState();
}

class _DeliveredState extends State<Delivered> {
  String? transId;
  final transacList =
      FirebaseFirestore.instance.collectionGroup("transactionList");
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return SafeArea(
      child: StreamBuilder<dynamic>(
        stream: transacList.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("waiting...");
          } else if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                final transacData = snapshot.data.docs[index];
                return Expanded(
                  child: transacData['status'] == "delivered" &&
                          transacData['buyerUid'] ==
                              FirebaseAuth.instance.currentUser!.uid
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
                              SizedBox(
                                height: heightVar / 80,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  "Your order has been delivered!",
                                  style: TextStyle(
                                      color: Color(0xFFC21010),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: heightVar / 80,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: widthVar / 25,
                                  ),
                                  Image.network(
                                    transacData['logoUrl'],
                                    height: 60,
                                    width: 60,
                                  ),
                                  SizedBox(
                                    width: widthVar / 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Transaction Id: ${transacData['transactionId']}"),
                                      Text(
                                          "Buyer: ${transacData['buyerName']}"),
                                      Text(
                                          "Total Price: ₱${transacData['transactionTotalPrice']}.00"),
                                      Text(
                                          "Total Items: ${transacData['itemList'].length.toString()}"),
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: const [
                                          Text("Status: Delivered"),
                                          Icon(
                                            Icons.circle,
                                            color: Colors.blue,
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: const Icon(
                                        Icons.more_vert,
                                        color: Color(0xFFC21010),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: widthVar / 25,
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                    left: widthVar / 25, top: heightVar / 60),
                                child: const Text(
                                  "Ordered Items:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: transacData['itemList'].length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                      left: widthVar / 25,
                                      right: widthVar / 25,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: heightVar / 80,
                                        ),
                                        Row(
                                          children: [
                                            Image.network(
                                              transacData['itemList'][index]
                                                  ['productImageUrl'],
                                              height: 60,
                                              width: 60,
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "Product Name: ${transacData['itemList'][index]['productName'].toString()}"),
                                                    Text(
                                                        "QTY: x${transacData['itemList'][index]['productQuantity'].toString()}"),
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
                              const Divider(
                                color: Colors.grey,
                                thickness: 0.3,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      margin:
                                          EdgeInsets.only(right: widthVar / 25),
                                      child: transacData['isReviewed'] == false
                                          ? TextButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(const Color(
                                                            0xFFC21010)),
                                                padding: MaterialStateProperty
                                                    .all<EdgeInsets>(
                                                  EdgeInsets.symmetric(
                                                      horizontal: widthVar / 20,
                                                      vertical: 12),
                                                ),
                                              ),
                                              onPressed: () {
                                                print(transacData[
                                                    'transactionId']);
                                                showBarModalBottomSheet(
                                                  expand: true,
                                                  context: context,
                                                  backgroundColor: Colors.white,
                                                  builder: (context) =>
                                                      AddReview(
                                                    transactionId: transacData[
                                                        'transactionId'],
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                "Add Review",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : TextButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.grey),
                                                padding: MaterialStateProperty
                                                    .all<EdgeInsets>(
                                                  EdgeInsets.symmetric(
                                                      horizontal: widthVar / 20,
                                                      vertical: 12),
                                                ),
                                              ),
                                              onPressed: null,
                                              child: const Text(
                                                "Add Review",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: heightVar / 100,
                              ),
                            ],
                          ),
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
