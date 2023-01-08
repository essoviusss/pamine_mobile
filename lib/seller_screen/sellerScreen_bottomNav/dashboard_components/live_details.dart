import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LiveDetails extends StatefulWidget {
  const LiveDetails({super.key});

  @override
  State<LiveDetails> createState() => _LiveDetailsState();
}

class _LiveDetailsState extends State<LiveDetails> {
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.orange.shade200,
            border: Border.all(color: Colors.transparent),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          width: double.infinity,
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
                  "Product Review",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: heightVar / 20,
                ),
                Row(
                  children: [
                    const Text(
                      "Total Reviews",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<dynamic>(
                        stream: FirebaseFirestore.instance
                            .collectionGroup("sold")
                            .snapshots(),
                        builder: (context, snapshot) {
                          int? count = snapshot.data.docs.length;
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            print("waiting...");
                          } else if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          } else {
                            return Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                count.toString(),
                                style: const TextStyle(
                                  fontSize: 50,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: heightVar / 20,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: heightVar / 60,
        ),
      ],
    );
  }
}
