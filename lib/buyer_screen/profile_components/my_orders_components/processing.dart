import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Processing extends StatefulWidget {
  const Processing({super.key});

  @override
  State<Processing> createState() => _ProcessingState();
}

class _ProcessingState extends State<Processing> {
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
                  child: transacData['status'] == "processing"
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.2),
                            border: Border.all(
                              width: 2,
                              color: Colors.purple,
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
                                          const Icon(
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
                                        color: Colors.purple,
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
