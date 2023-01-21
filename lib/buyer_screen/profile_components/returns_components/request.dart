import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/returns_components/requestModal.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: widthVar / 35, right: widthVar / 35),
        child: Column(
          children: [
            StreamBuilder<dynamic>(
                stream: FirebaseFirestore.instance
                    .collectionGroup("returns")
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
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data?.docs[index];
                          String? status = post['returnStatus'];
                          return Expanded(
                              child: status == "none"
                                  ? InkWell(
                                      onTap: () {
                                        showBarModalBottomSheet(
                                          expand: true,
                                          context: context,
                                          backgroundColor: Colors.white,
                                          builder: (context) => RequestModal(
                                            buyerName: post['buyerName'],
                                            rUrl: post['rUrl'],
                                            returnDetails:
                                                post['returnDetails'],
                                            businessName: post['businessName'],
                                            buyerUid: post['buyerUid'],
                                            cpNum: post['cpNum'],
                                            itemList: post['itemList'],
                                            logoUrl: post['logoUrl'],
                                            modeOfPayment:
                                                post['modeOfPayment'],
                                            sellerUid: post['sellerUid'],
                                            statId: post.id,
                                            totalCommision:
                                                post['totalCommision'],
                                            totalSale: post['totalSale'],
                                            transactionId:
                                                post['transactionId'],
                                            transactionTotalPrice:
                                                post['transactionTotalPrice'],
                                          ),
                                        );
                                      },
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
                                              height: heightVar / 100,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: widthVar / 35,
                                                ),
                                                const Icon(
                                                  Icons.notifications,
                                                  color: Color(0xFFC21010),
                                                  size: 30,
                                                ),
                                                SizedBox(
                                                  width: widthVar / 8,
                                                ),
                                                Column(
                                                  children: const [
                                                    Text(
                                                        "Your return request is not",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(" yet accepted",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(
                                                        "click to view details",
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red)),
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
                                            ),
                                            SizedBox(
                                              height: heightVar / 100,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container());
                        });
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }
}
