import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TotalSales extends StatefulWidget {
  const TotalSales({super.key});

  @override
  State<TotalSales> createState() => _TotalSalesState();
}

class _TotalSalesState extends State<TotalSales> {
  int? subtotal1 = 0;
  int? basetotal = 0;

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: heightVar / 60),
      child: Container(
        margin: EdgeInsets.only(
          left: widthVar / 35,
          right: widthVar / 35,
          top: heightVar / 60,
          bottom: heightVar / 60,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sales",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    height: heightVar / 6.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: widthVar / 25, top: heightVar / 60),
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "Total Sales",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: StreamBuilder<dynamic>(
                            stream: FirebaseFirestore.instance
                                .collection('transactions')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("transactionList")
                                .where("status", isEqualTo: "delivered")
                                .snapshots(),
                            builder: (context, snapshot) {
                              final priceList = snapshot.data?.docs.map((doc) {
                                subtotal1 = doc.get("transactionTotalPrice");
                              }).toList();
                              basetotal = priceList?.fold(0,
                                  (subtotal, index) => subtotal + subtotal1!);
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                print("waiting...");
                              } else if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              } else {
                                return Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "₱${basetotal.toString()}.00",
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: widthVar / 25, bottom: heightVar / 60),
                            alignment: Alignment.bottomLeft,
                            child: InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.shopping_bag,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: widthVar / 35,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    height: heightVar / 6.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: widthVar / 25, top: heightVar / 60),
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "Sold Items",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: StreamBuilder<dynamic>(
                                stream: FirebaseFirestore.instance
                                    .collectionGroup("sold")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  final count = snapshot.data?.docs.length;
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    print("waiting...");
                                  } else if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  } else {
                                    return Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          count.toString(),
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 40),
                                        ),
                                      ),
                                    );
                                  }
                                  return Container();
                                })),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: widthVar / 25, bottom: heightVar / 60),
                            alignment: Alignment.bottomLeft,
                            child: const Icon(
                              Icons.currency_exchange,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    height: heightVar / 6.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: widthVar / 25, top: heightVar / 60),
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "Total Items",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: StreamBuilder<dynamic>(
                                stream: FirebaseFirestore.instance
                                    .collection("seller_info")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("products")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  final count = snapshot.data?.docs.length;
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    print("waiting...");
                                  } else if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  } else {
                                    return Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        count.toString(),
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 35),
                                      ),
                                    );
                                  }
                                  return Container();
                                })),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: widthVar / 25, bottom: heightVar / 60),
                            alignment: Alignment.bottomLeft,
                            child: const Icon(
                              Icons.shopping_basket,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: widthVar / 35,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    height: heightVar / 6.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: widthVar / 25, top: heightVar / 60),
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "Total Orders",
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: StreamBuilder<dynamic>(
                                stream: FirebaseFirestore.instance
                                    .collection("transactions")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("transactionList")
                                    .where("status", isNotEqualTo: "rejected")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  int? count = snapshot.data?.docs.length;
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    print("waiting...");
                                  } else if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  } else {
                                    return Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        count.toString(),
                                        style: const TextStyle(
                                            color: Colors.purple,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 35),
                                      ),
                                    );
                                  }
                                  return Container();
                                })),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: widthVar / 25, bottom: heightVar / 60),
                            alignment: Alignment.bottomLeft,
                            child: const Icon(
                              Icons.shopping_cart_rounded,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
