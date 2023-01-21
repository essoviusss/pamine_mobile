import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/my_orders_components/return/return_details.dart';

class Processing extends StatefulWidget {
  const Processing({super.key});

  @override
  State<Processing> createState() => _ProcessingState();
}

class _ProcessingState extends State<Processing> {
  final transacList =
      FirebaseFirestore.instance.collectionGroup("transactionList");

  Future updateStatus(String id) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    await transacList.get().then((value) {
      for (var orderList in value.docs) {
        if (orderList.id.contains(id)) {
          batch.update(orderList.reference, {
            "status": "delivered",
          });
          batch.set(orderList.reference, {"isReviewed": false},
              SetOptions(merge: true));
        }
      }
      return batch.commit();
    });
  }

  String? sellerUid, productId;

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return SafeArea(
      child: StreamBuilder<dynamic>(
        stream: transacList
            .where("buyerUid",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("waiting...");
          } else if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                final transacData = snapshot.data.docs[index];

                return Expanded(
                  child: transacData['status'] == "processing"
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
                                  "Your order has been shipped out!",
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
                                          Text("Status: Shipped Out"),
                                          Icon(
                                            Icons.circle,
                                            color: Colors.purple,
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
                                  sellerUid = transacData['itemList'][index]
                                      ['sellerUid'];
                                  productId = transacData['itemList'][index]
                                      ['productId'];
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
                                                        "Quantity: ${transacData['itemList'][index]['productQuantity'].toString()}"),
                                                    Text(
                                                        "Item Price: ₱${transacData['itemList'][index]['productPrice'].toString()}.00"),
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
                              Container(
                                margin: EdgeInsets.only(
                                    left: widthVar / 25, right: widthVar / 25),
                                child: const Text(
                                  "Note: Mark this order as delivered if you have received your order or you can return your item to the seller.",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              SizedBox(
                                height: heightVar / 60,
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: widthVar / 25),
                                    child: TextButton(
                                      onPressed: () {
                                        showBarModalBottomSheet(
                                          expand: true,
                                          context: context,
                                          backgroundColor: Colors.white,
                                          builder: (context) => ReturnDetails(
                                            businessName:
                                                transacData['businessName'],
                                            buyerName: transacData['buyerName'],
                                            buyerUid: FirebaseAuth
                                                .instance.currentUser?.uid,
                                            cpNum: transacData['cpNum'],
                                            logoUrl: transacData['logoUrl'],
                                            modeOfPayment:
                                                transacData['modeOfPayment'],
                                            totalCommision:
                                                transacData['totalCommision'],
                                            totalSale: transacData['totalSale'],
                                            transactionId:
                                                transacData['transactionId'],
                                            transactionTotalPrice: transacData[
                                                'transactionTotalPrice'],
                                            sellerUid: sellerUid,
                                            itemList: transacData['itemList'],
                                            statId: transacData.id,
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "return/refund",
                                        style:
                                            TextStyle(color: Color(0xFFC21010)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      margin:
                                          EdgeInsets.only(right: widthVar / 25),
                                      child: TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xFFC21010)),
                                          padding: MaterialStateProperty.all<
                                              EdgeInsets>(
                                            EdgeInsets.symmetric(
                                                horizontal: widthVar / 20,
                                                vertical: 12),
                                          ),
                                        ),
                                        onPressed: () {
                                          updateStatus(transacData.id);
                                        },
                                        child: const Text(
                                          "Order Received",
                                          style: TextStyle(color: Colors.white),
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
