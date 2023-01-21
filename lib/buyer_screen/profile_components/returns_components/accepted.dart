import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReturnAccepted extends StatefulWidget {
  const ReturnAccepted({super.key});

  @override
  State<ReturnAccepted> createState() => _ReturnAcceptedState();
}

class _ReturnAcceptedState extends State<ReturnAccepted> {
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
                  int? itemCount = snapshot.data?.docs.length;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print("waiting...");
                  } else if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: itemCount,
                          itemBuilder: (context, index) {
                            final post = snapshot.data?.docs[index];
                            String? status = post['returnStatus'];
                            return status == "accepted"
                                ? Expanded(
                                    child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: const [
                                          BoxShadow(
                                            spreadRadius: 0.1,
                                            blurStyle: BlurStyle.normal,
                                            color: Colors.grey,
                                            blurRadius: 10,
                                            offset:
                                                Offset(4, 8), // Shadow position
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
                                            "Return request has been accepted",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: heightVar / 60,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: widthVar / 25,
                                              ),
                                              Image.network(
                                                post['itemList'][index]
                                                    ['productImageUrl'],
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
                                                      "Product Name: ${post['itemList'][index]['productName']}"),
                                                  Text(
                                                      "Status: ${post['returnStatus']}"),
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
                                                width: widthVar / 25,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: heightVar / 100,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: widthVar / 25,
                                                right: widthVar / 25),
                                            alignment: Alignment.centerLeft,
                                            child: const Text(
                                              "Seller Return Address",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            height: heightVar / 60,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: widthVar / 25,
                                                right: widthVar / 25),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Receiver: ${post['receiver']}"),
                                                Text(
                                                    "Cp#: ${post['receiverNumber']}"),
                                                Text(
                                                    "Return Address: ${post['returnAddress']}"),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: heightVar / 60,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                                : Container();
                          }),
                    );
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }
}
