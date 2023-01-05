import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/viewshoptabs/view_reviews.dart';

class ShopSoldProducts extends StatefulWidget {
  const ShopSoldProducts({super.key});

  @override
  State<ShopSoldProducts> createState() => _ShopSoldProductsState();
}

class _ShopSoldProductsState extends State<ShopSoldProducts> {
  final transactionRef = FirebaseFirestore.instance.collectionGroup("sold");
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Column(
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
                          onTap: () {},
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
