import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReturnActions extends StatefulWidget {
  final String? buyerName, rUrl, returnDetails, transactionId;
  final int? transactionTotalPrice, totalItems;
  final List? itemList;

  const ReturnActions({
    super.key,
    required this.buyerName,
    required this.rUrl,
    required this.returnDetails,
    required this.transactionId,
    required this.transactionTotalPrice,
    required this.totalItems,
    required this.itemList,
  });

  @override
  State<ReturnActions> createState() => _ReturnActionsState();
}

class _ReturnActionsState extends State<ReturnActions> {
  CollectionReference returnSuccess =
      FirebaseFirestore.instance.collection('seller_info');
  String? businessOwnerName, address, cpNum;
  getData() async {
    DocumentSnapshot snapshot =
        await returnSuccess.doc(FirebaseAuth.instance.currentUser!.uid).get();
    businessOwnerName = snapshot['businessOwnerName'];
    address = snapshot['address'];
    cpNum = snapshot['phoneNumber'];
  }

  acceptReturn() async {
    await getData();
    FirebaseFirestore.instance
        .collection("seller_info")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("returns")
        .doc(widget.transactionId)
        .set(
      {
        "returnStatus": "accepted",
        "returnAddress": address,
        "receiver": businessOwnerName,
        "receiverNumber": cpNum,
      },
      SetOptions(merge: true),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(
            left: widthVar / 25, right: widthVar / 25, top: heightVar / 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: heightVar / 60,
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "Return Details",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Transaction Id: ${widget.transactionId!}"),
                        Text("Buyer Name: ${widget.buyerName!}"),
                        Text(
                            "Total Price: ₱${widget.transactionTotalPrice!}.00"),
                        Text("Total Item(s): ${widget.totalItems!}"),
                        SizedBox(
                          height: heightVar / 60,
                        ),
                        const Text(
                          "Ordered items:",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.totalItems,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                left: widthVar / 25,
                                right: widthVar / 25,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: heightVar / 80,
                                  ),
                                  Row(
                                    children: [
                                      Image.network(
                                        widget.itemList?[index]
                                            ['productImageUrl'],
                                        height: 60,
                                        width: 60,
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Product Name: ${widget.itemList?[index]['productName'].toString()}"),
                                              Text(
                                                  "Quantity: ${widget.itemList?[index]['productQuantity'].toString()}"),
                                              Text(
                                                  "Item Price: ₱${widget.itemList?[index]['productPrice'].toString()}.00"),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            Text(
              "Return Details: ${widget.returnDetails!}",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            Image.network(widget.rUrl!),
            SizedBox(
              height: heightVar / 60,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        FirebaseFirestore.instance
                            .collection("seller_info")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("returns")
                            .doc(widget.transactionId)
                            .set(
                          {
                            "returnStatus": "rejected",
                          },
                          SetOptions(merge: true),
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Reject Request",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: widthVar / 12, vertical: 12),
                            ),
                          ),
                          onPressed: () async {
                            acceptReturn();
                          },
                          child: const Text(
                            "Accept Request",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
