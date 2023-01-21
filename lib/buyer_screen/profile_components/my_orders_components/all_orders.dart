import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  final transacList =
      FirebaseFirestore.instance.collectionGroup("transactionList");
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return SafeArea(
      child: StreamBuilder<dynamic>(
        stream: transacList
            .where("buyerUid",
                isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
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
                  child: transacData['status'] == "accepted" ||
                          transacData['status'] == "processing" ||
                          transacData['status'] == "delivered"
                      ? Container(
                          decoration: BoxDecoration(
                            color: transacData['status'] == "accepted"
                                ? Colors.green.withOpacity(0.2)
                                : transacData['status'] == "rejected"
                                    ? Colors.red.withOpacity(0.2)
                                    : transacData['status'] == "delivered"
                                        ? Colors.blue.withOpacity(0.2)
                                        : transacData['status'] == "processing"
                                            ? Colors.purple.withOpacity(0.2)
                                            : Colors.green.withOpacity(0.2),
                            border: Border.all(
                              width: 2,
                              color: transacData['status'] == "accepted"
                                  ? Colors.green
                                  : transacData['status'] == "rejected"
                                      ? Colors.red
                                      : transacData['status'] == "delivered"
                                          ? Colors.blue
                                          : transacData['status'] ==
                                                  "processing"
                                              ? Colors.purple
                                              : Colors.green,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
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
                                        "Id: ${transacData['transactionId']}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "Buyer: ${transacData['buyerName']}"),
                                      Text(transacData['transactionDate']
                                          .toDate()
                                          .toString()),
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Text(
                                              "Status: ${transacData['status']}"),
                                          Icon(
                                            Icons.circle,
                                            color: transacData['status'] ==
                                                    "accepted"
                                                ? Colors.green
                                                : transacData['status'] ==
                                                        "rejected"
                                                    ? Colors.red
                                                    : transacData['status'] ==
                                                            "delivered"
                                                        ? Colors.blue
                                                        : transacData[
                                                                    'status'] ==
                                                                "processing"
                                                            ? Colors.purple
                                                            : Colors.green,
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.more_vert,
                                        color: transacData['status'] ==
                                                "accepted"
                                            ? Colors.green
                                            : transacData['status'] ==
                                                    "rejected"
                                                ? Colors.red
                                                : transacData['status'] ==
                                                        "delivered"
                                                    ? Colors.blue
                                                    : transacData['status'] ==
                                                            "processing"
                                                        ? Colors.purple
                                                        : Colors.green,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: widthVar / 25,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: heightVar / 80,
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
