import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProductReviews extends StatefulWidget {
  const ProductReviews({super.key});

  @override
  State<ProductReviews> createState() => _ProductReviewsState();
}

class _ProductReviewsState extends State<ProductReviews> {
  final transactionRef = FirebaseFirestore.instance
      .collection("seller_info")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("sold");
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text("Product Reviews"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          StreamBuilder<dynamic>(
              stream: transactionRef.snapshots(),
              builder: (context, snapshot) {
                final countItem = snapshot.data?.docs.length;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("waiting...");
                } else if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio:
                            ((widthVar / 2.2) / (heightVar / 3.8)),
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      shrinkWrap: true,
                      itemCount: countItem,
                      itemBuilder: (context, index) {
                        final post = snapshot.data.docs[index];
                        return InkWell(
                          onTap: () {
                            showBarModalBottomSheet(
                              expand: true,
                              context: context,
                              backgroundColor: Colors.white,
                              builder: (context) => Container(
                                margin: EdgeInsets.only(
                                    left: widthVar / 25, right: widthVar / 25),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: heightVar / 60,
                                    ),
                                    const Text(
                                      "Product Rating",
                                      style: TextStyle(
                                          color: Color(0xFFC21010),
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: heightVar / 60,
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                              post['productImageUrl']),
                                          SizedBox(
                                            height: heightVar / 60,
                                          ),
                                          Text(
                                            "Product Name: ${post['productName']}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Buyer Name: ${post['buyerName']}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Rating: ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              RatingBar.builder(
                                                itemSize: widthVar / 30,
                                                initialRating: double.parse(
                                                    post['productRating']
                                                        .toString()),
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Color(0xFFC21010),
                                                ),
                                                onRatingUpdate: (rating) {
                                                  print(rating);
                                                },
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "Comment: ${post['comment']}",
                                            textAlign: TextAlign.justify,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 3.0, color: Colors.grey.shade300),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                              ),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: Image.network(
                                            post['productImageUrl']),
                                      ),
                                      SizedBox(
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                top: heightVar / 99)),
                                      ),
                                      Text(
                                        post['productName'],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Rating: ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          RatingBar.builder(
                                            itemSize: widthVar / 30,
                                            initialRating: double.parse(
                                                post['productRating']
                                                    .toString()),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Color(0xFFC21010),
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container();
              }),
        ],
      ),
    );
  }
}
