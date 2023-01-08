// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/checkout_cart_components/checkout_in_live.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/checkout_cart_components/checkout_off_live.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/delivery_details_components/choose_delivery_details.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/place_order_components/place_order.dart';
import 'package:pamine_mobile/model/cart_model.dart';
import 'package:pamine_mobile/model/mined_cart_model.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CheckOut extends StatefulWidget {
  final String? sellerUid;
  const CheckOut({super.key, required this.sellerUid});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  int? basetotal1;
  int? basetotal2;
  int? subtotal1;
  int? subtotal2;
  int? grandTotal;
  int? subCommision;
  int? subCommission1;
  int? totalCommision;
  int? totalCommission1;
  int? totalSale;
  int? totalSale1;
  int? grandTotalSale;
  int? grandTotalSale1;

  bool? isSet = true;
  bool? option1 = false;
  bool? option2 = false;
  bool? paymentOption1 = false;
  bool? paymentOption2 = false;
  bool? paymentOption3 = false;

  String? buyerName;
  List cartItems = [];
  List minedProducts = [];
  List cartItemsList = [];

  List minedItemsList = [];
  List items = [];
  List sellerId = [];
  List sellerId1 = [];

  List<dynamic> sample = [];
  List itemlist = [];
  String? modeOfPayment;
  String? cpNum;
  String? shippingAddress;

  final firestore = FirebaseFirestore.instance
      .collection("buyer_info")
      .doc(FirebaseAuth.instance.currentUser!.uid);
  final sellerShop = FirebaseFirestore.instance.collection("seller_info");

  final auth = FirebaseAuth.instance.currentUser;

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collectionGroup('groupedItems').get();
    QuerySnapshot querySnapshot1 =
        await FirebaseFirestore.instance.collectionGroup('minedProducts').get();

    QuerySnapshot sellerUid = await FirebaseFirestore.instance
        .collection("buyer_info")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cart")
        .get();
    QuerySnapshot sellerUid1 = await FirebaseFirestore.instance
        .collection("buyer_info")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("mined_products")
        .get();
    cartItems = querySnapshot.docs.map((doc) => doc.id).toList();
    minedProducts = querySnapshot1.docs.map((doc) => doc.id).toList();
    cartItemsList = querySnapshot.docs.map((doc) => doc.data()).toList();
    minedItemsList = querySnapshot1.docs.map((doc) => doc.data()).toList();
    sellerId = sellerUid.docs.map((doc) => doc.id).toList();
    sellerId1 = sellerUid1.docs.map((doc) => doc.id).toList();
  }

  Future update() async {
    await getData();
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final querySnapshot =
        await FirebaseFirestore.instance.collectionGroup("products").get();

    //offlive
    for (var productId in querySnapshot.docs) {
      if (cartItems.contains(productId.id)) {
        print("PRODUCT QTY ${productId.data()["productQuantity"]}");
        batch.update(productId.reference,
            {"productQuantity": productId.data()['productQuantity'] - 1});
      }
    }
    //inlive
    for (var productId1 in querySnapshot.docs) {
      if (minedProducts.contains(productId1.id)) {
        print("PRODUCT QTY ${productId1.data()["productQuantity"]}");
        batch.update(productId1.reference,
            {"productQuantity": productId1.data()['productQuantity'] - 1});
      }
    }
    return batch.commit().then((value) {
      Fluttertoast.showToast(msg: "Transaction Completed");
    });
  }

  Future set() async {
    await update();
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final transacId = DateTime.now().microsecondsSinceEpoch.toString();
    final transacId1 = DateTime.now().microsecondsSinceEpoch.toString();
    Map<String, dynamic>? data = {
      "transactionId": "#$transacId",
      "transactionTotalPrice": basetotal1,
      "transactionDate": DateTime.now(),
      "totalCommision": totalCommision,
      "totalSale": grandTotalSale,
      "buyerName": buyerName,
      "modeOfPayment": modeOfPayment,
      "cpNum": cpNum,
      "shippingAddress": shippingAddress,
      "status": "pending",
      "buyerUid": FirebaseAuth.instance.currentUser!.uid,
      "itemList": cartItemsList,
    };
    Map<String, dynamic>? data1 = {
      "transactionId": "#1$transacId1",
      "transactionTotalPrice": basetotal2,
      "transactionDate": DateTime.now(),
      "totalCommision": totalCommission1,
      "totalSale": grandTotalSale1,
      "buyerName": buyerName,
      "modeOfPayment": modeOfPayment,
      "cpNum": cpNum,
      "shippingAddress": shippingAddress,
      "status": "pending",
      "buyerUid": FirebaseAuth.instance.currentUser!.uid,
      "itemList": minedItemsList,
    };
    if (option1 == true) {
      for (var mined in sellerId1) {
        batch.set(
            FirebaseFirestore.instance
                .collection("transactions")
                .doc(mined)
                .collection("transactionList")
                .doc(transacId1),
            data1);
      }
    }
    if (option2 == true) {
      for (var items in sellerId) {
        batch.set(
            FirebaseFirestore.instance
                .collection("transactions")
                .doc(items)
                .collection("transactionList")
                .doc(transacId),
            data);
      }
    }
    return batch.commit();
  }

  Future delete() async {
    await set();
    var collection = FirebaseFirestore.instance.collectionGroup('groupedItems');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
    var collection1 =
        FirebaseFirestore.instance.collectionGroup('minedProducts');
    var snapshots1 = await collection1.get();
    for (var doc in snapshots1.docs) {
      await doc.reference.delete();
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlaceOrder(
          grandTotal: grandTotal,
        ),
      ),
    );
  }

  String? sellerUid;

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC21010),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text("Checkout"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: heightVar / 60, left: widthVar / 25, right: widthVar / 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cart to Checkout",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.only(top: heightVar / 60),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: option1 == true
                          ? const Color(0xFFC21010)
                          : const Color.fromARGB(255, 200, 200, 200)),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Container(
                  color: option1 == true
                      ? Colors.red.withOpacity(0.1)
                      : Colors.transparent,
                  child: Row(
                    children: [
                      SizedBox(
                        width: widthVar / 25,
                      ),
                      RoundCheckBox(
                        isChecked: option1,
                        size: 30,
                        checkedColor: const Color(0xFFC21010),
                        onTap: (selected) =>
                            setState((() => option1 = selected)),
                      ),
                      SizedBox(
                        width: widthVar / 15,
                      ),
                      const CheckoutInLive(),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              showBarModalBottomSheet(
                                  expand: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => Container(
                                        height: double.infinity,
                                        color: Colors.white,
                                        child: StreamBuilder<dynamic>(
                                            stream: FirebaseFirestore.instance
                                                .collectionGroup(
                                                    "minedProducts")
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                print("waiting...");
                                              }
                                              if (snapshot.hasData) {
                                                return Column(
                                                  children: [
                                                    SizedBox(
                                                      height: heightVar / 60,
                                                    ),
                                                    const Text(
                                                      "Mined Items",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFFC21010),
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: snapshot
                                                            .data.docs.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Container(
                                                              height:
                                                                  heightVar /
                                                                      10,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                boxShadow: const [
                                                                  BoxShadow(
                                                                    spreadRadius:
                                                                        0.1,
                                                                    blurStyle:
                                                                        BlurStyle
                                                                            .normal,
                                                                    color: Colors
                                                                        .grey,
                                                                    blurRadius:
                                                                        10,
                                                                    offset: Offset(
                                                                        4,
                                                                        8), // Shadow position
                                                                  ),
                                                                ],
                                                              ),
                                                              margin: EdgeInsets.only(
                                                                  left:
                                                                      widthVar /
                                                                          25,
                                                                  right:
                                                                      widthVar /
                                                                          25,
                                                                  bottom:
                                                                      heightVar /
                                                                          80,
                                                                  top:
                                                                      heightVar /
                                                                          80),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                      margin: EdgeInsets.only(
                                                                          left: widthVar /
                                                                              20),
                                                                      child: Image
                                                                          .network(
                                                                        snapshot
                                                                            .data
                                                                            .docs[index]['productImageUrl'],
                                                                        height:
                                                                            60,
                                                                        width:
                                                                            60,
                                                                      )),
                                                                  SizedBox(
                                                                      width:
                                                                          widthVar /
                                                                              6),
                                                                  Wrap(
                                                                    crossAxisAlignment:
                                                                        WrapCrossAlignment
                                                                            .center,
                                                                    spacing:
                                                                        widthVar /
                                                                            20,
                                                                    children: [
                                                                      SizedBox(
                                                                          width: widthVar /
                                                                              3,
                                                                          child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  snapshot.data.docs[index]['productName'],
                                                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text("₱${snapshot.data.docs[index]['productPrice'].toString()}.00"),
                                                                              ])),
                                                                    ],
                                                                  )
                                                                ],
                                                              ));
                                                        }),
                                                  ],
                                                );
                                              }
                                              return Container();
                                            }),
                                      ));
                            },
                            child: const Icon(
                              Icons.more_vert,
                              color: Color(0xFFC21010),
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: heightVar / 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: option2 == true
                                ? const Color(0xFFC21010)
                                : const Color.fromARGB(255, 200, 200, 200)),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Container(
                        color: option2 == true
                            ? Colors.red.withOpacity(0.1)
                            : Colors.transparent,
                        child: Row(
                          children: [
                            SizedBox(
                              width: widthVar / 25,
                            ),
                            RoundCheckBox(
                              isChecked: option2,
                              size: 30,
                              checkedColor: const Color(0xFFC21010),
                              onTap: (selected) =>
                                  setState((() => option2 = selected)),
                            ),
                            SizedBox(
                              width: widthVar / 15,
                            ),
                            const CheckoutOffLive(),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    showBarModalBottomSheet(
                                        expand: true,
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => Container(
                                              height: double.infinity,
                                              color: Colors.white,
                                              child: StreamBuilder<dynamic>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collectionGroup(
                                                          "groupedItems")
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      print("waiting...");
                                                    }
                                                    if (snapshot.hasData) {
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height:
                                                                heightVar / 60,
                                                          ),
                                                          const Text(
                                                            "Cart Items",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFFC21010),
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          ListView.builder(
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  snapshot
                                                                      .data
                                                                      .docs
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Container(
                                                                    height:
                                                                        heightVar /
                                                                            10,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12),
                                                                      boxShadow: const [
                                                                        BoxShadow(
                                                                          spreadRadius:
                                                                              0.1,
                                                                          blurStyle:
                                                                              BlurStyle.normal,
                                                                          color:
                                                                              Colors.grey,
                                                                          blurRadius:
                                                                              10,
                                                                          offset: Offset(
                                                                              4,
                                                                              8), // Shadow position
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    margin: EdgeInsets.only(
                                                                        left: widthVar /
                                                                            25,
                                                                        right: widthVar /
                                                                            25,
                                                                        bottom:
                                                                            heightVar /
                                                                                80,
                                                                        top: heightVar /
                                                                            80),
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                            margin:
                                                                                EdgeInsets.only(left: widthVar / 20),
                                                                            child: Image.network(
                                                                              snapshot.data.docs[index]['productImageUrl'],
                                                                              height: 60,
                                                                              width: 60,
                                                                            )),
                                                                        SizedBox(
                                                                            width:
                                                                                widthVar / 6),
                                                                        Wrap(
                                                                          crossAxisAlignment:
                                                                              WrapCrossAlignment.center,
                                                                          spacing:
                                                                              widthVar / 20,
                                                                          children: [
                                                                            SizedBox(
                                                                                width: widthVar / 3,
                                                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                  Text(
                                                                                    snapshot.data.docs[index]['productName'],
                                                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text("₱${snapshot.data.docs[index]['productPrice'].toString()}.00"),
                                                                                  Text("Qty: ${snapshot.data.docs[index]['productQuantity'].toString()}")
                                                                                ])),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ));
                                                              }),
                                                        ],
                                                      );
                                                    }
                                                    return Container();
                                                  }),
                                            ));
                                  },
                                  child: const Icon(
                                    Icons.more_vert,
                                    color: Color(0xFFC21010),
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: heightVar / 60,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: heightVar / 60,
              ),
              const Text("Delivery Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                height: heightVar / 100,
              ),
              StreamBuilder(
                stream: firestore
                    .collection("default_delivery_details")
                    .doc("default")
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  buyerName = snapshot.data?['fullName'];
                  cpNum = snapshot.data?['cpNumber'];
                  shippingAddress = snapshot.data?['shippingAddress'];
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print("waiting...");
                  }
                  if (snapshot.data?.exists == false) {
                    return Container(
                      width: double.infinity,
                      height: heightVar / 8,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.grey,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: IconButton(
                              iconSize: 70,
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: heightVar / 2,
                                      child: Column(
                                        children: const [
                                          Icon(
                                            Icons.linear_scale_sharp,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                          ChooseDeliveryDetails(),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const Text("Choose Delivery Details")
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      width: double.infinity,
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
                                Row(
                                  children: [
                                    Text(
                                      snapshot.data?['fullName'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            showModalBottomSheet<void>(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SizedBox(
                                                  height: heightVar / 2,
                                                  child: Column(
                                                    children: const [
                                                      Icon(
                                                        Icons
                                                            .linear_scale_sharp,
                                                        size: 50,
                                                        color: Colors.grey,
                                                      ),
                                                      ChooseDeliveryDetails(),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: const Text(
                                            "change",
                                            style: TextStyle(
                                                color: Color(0xFFC21010),
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                },
              ),
              SizedBox(
                height: heightVar / 60,
              ),
              const Text("Payment Methods",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                height: heightVar / 100,
              ),
              Container(
                height: heightVar / 8,
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
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (paymentOption1 == false) {
                          setState(() {
                            modeOfPayment = "Cash On Delivery";
                            paymentOption1 = true;
                            firestore
                                .collection("payment_methods")
                                .doc("default_payment_method")
                                .set({
                              "paymentMethod": "Cash On Delivery"
                            }).then((value) {
                              Fluttertoast.showToast(msg: "Cash on Delivery");
                            });
                          });
                        } else if (paymentOption1 == true) {
                          setState(() {
                            paymentOption1 = false;
                            firestore
                                .collection("payment_methods")
                                .doc("default_payment_method")
                                .delete()
                                .then((value) {
                              Fluttertoast.showToast(
                                  msg: "Payment method removed");
                            });
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: paymentOption1 == true
                                  ? const Color(0xFFC21010)
                                  : const Color.fromARGB(255, 200, 200, 200)),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: paymentOption1 == true
                              ? Colors.red.withOpacity(0.2)
                              : Colors.white,
                        ),
                        width: widthVar / 4,
                        margin: EdgeInsets.only(
                            top: heightVar / 100,
                            bottom: heightVar / 100,
                            left: widthVar / 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.monetization_on,
                              size: 50,
                              color: Color(0xFFC21010),
                            ),
                            Text(
                              "Cash on Delivery",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (paymentOption2 == false) {
                          setState(() {
                            modeOfPayment = "Cash On Pickup";
                            paymentOption2 = true;
                            firestore
                                .collection("payment_methods")
                                .doc("default_payment_method")
                                .set({"paymentMethod": "Cash On Pickup"}).then(
                                    (value) {
                              Fluttertoast.showToast(msg: "Cash on Pickup");
                            });
                          });
                        } else if (paymentOption2 == true) {
                          setState(() {
                            paymentOption2 = false;
                            firestore
                                .collection("payment_methods")
                                .doc("default_payment_method")
                                .delete()
                                .then((value) {
                              Fluttertoast.showToast(
                                  msg: "Payment method removed");
                            });
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: paymentOption2 == true
                                  ? const Color(0xFFC21010)
                                  : const Color.fromARGB(255, 200, 200, 200)),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: paymentOption2 == true
                              ? Colors.red.withOpacity(0.2)
                              : Colors.white,
                        ),
                        width: widthVar / 4,
                        margin: EdgeInsets.only(
                            top: heightVar / 100,
                            bottom: heightVar / 100,
                            left: widthVar / 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.price_check_rounded,
                              size: 50,
                              color: Color(0xFFC21010),
                            ),
                            Text(
                              "Cash on Pickup",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: const Color.fromARGB(255, 200, 200, 200)),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.white,
                      ),
                      width: widthVar / 4,
                      margin: EdgeInsets.only(
                          top: heightVar / 100,
                          bottom: heightVar / 100,
                          left: widthVar / 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            "https://img.icons8.com/plasticine/400/gcash.png",
                            height: 60,
                            width: 60,
                          ),
                          const Text(
                            "Gcash",
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: heightVar / 50,
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Column(
          children: [
            SizedBox(
              height: heightVar / 50,
            ),
            Container(
              margin: EdgeInsets.only(right: widthVar / 25),
              alignment: Alignment.centerRight,
              child: StreamBuilder<dynamic>(
                stream: FirebaseFirestore.instance
                    .collectionGroup("groupedItems")
                    .snapshots(),
                builder: (context, snapshot) {
                  final cartItems =
                      snapshot.data?.docs.map((DocumentSnapshot doc) {
                    CartModel.fromMap(doc.data());
                    subtotal1 = doc.get("subtotal");
                    subCommision = doc.get("commision");
                    totalSale = doc.get("origPrice");
                  });
                  grandTotalSale = cartItems?.fold(
                      0, (gTotalSale, tots) => gTotalSale + totalSale);

                  totalCommision = cartItems?.fold(
                      0, (commision, total) => commision + subCommision);

                  basetotal1 = cartItems?.fold(
                      0, (subtotal, index) => subtotal + subtotal1!);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print("waiting...");
                  }
                  if (snapshot.hasData) {
                    return StreamBuilder<dynamic>(
                      stream: FirebaseFirestore.instance
                          .collectionGroup("minedProducts")
                          .snapshots(),
                      builder: (context, snapshot) {
                        final cartItems =
                            snapshot.data?.docs.map((DocumentSnapshot doc) {
                          MinedCartModel.fromMap(doc.data());
                          subtotal2 = doc.get("productPrice");
                          subCommission1 = doc.get("commission");
                          totalSale1 = doc.get("productOrigPrice");
                        });
                        grandTotalSale1 = cartItems?.fold(0,
                            (mGTotalSale, gTotal) => mGTotalSale + totalSale1);

                        totalCommission1 = cartItems?.fold(
                            0,
                            (mineCommission, totalCom) =>
                                mineCommission + subCommission1!);
                        basetotal2 = cartItems?.fold(
                            0, (subtotal, index) => subtotal + subtotal2!);

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          print("waiting...");
                        }
                        if (snapshot.hasData) {
                          grandTotal = basetotal1! + basetotal2!;
                          return option1 == true && option2 == true
                              ? Text(
                                  "Total Price: ₱$grandTotal.00",
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              : option1 == true
                                  ? Text(
                                      "Total Price: ₱$basetotal2.00",
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )
                                  : option2 == true
                                      ? Text(
                                          "Total Price: ₱$basetotal1.00",
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )
                                      : const Text(
                                          "Total Price: ₱0.00",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        );
                        }
                        return Container();
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
            SizedBox(
              height: heightVar / 50,
            ),
            Row(
              children: [
                (option1 == true && paymentOption1 == true && isSet == true) ||
                        (paymentOption1 == true &&
                            option2 == true &&
                            isSet == true) ||
                        (paymentOption1 == true &&
                            option1 == true &&
                            option2 == true &&
                            isSet == true)
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFFC21010)),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    horizontal: widthVar / 3.9,
                                    vertical: heightVar / 60),
                              ),
                            ),
                            onPressed: () {
                              delete();
                            },
                            child: const Text(
                              'Place Order',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.grey),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    horizontal: widthVar / 3.9,
                                    vertical: heightVar / 60),
                              ),
                            ),
                            onPressed: null,
                            child: const Text(
                              'Place Order',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
