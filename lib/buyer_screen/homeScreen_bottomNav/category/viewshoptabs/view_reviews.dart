import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ViewReviews extends StatefulWidget {
  const ViewReviews({super.key});

  @override
  State<ViewReviews> createState() => _ViewReviewsState();
}

class _ViewReviewsState extends State<ViewReviews> {
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return SafeArea(
      child: StreamBuilder<dynamic>(
        stream:
            FirebaseFirestore.instance.collection("seller_info").snapshots(),
        builder: (context, snapshot) {
          final reviewData = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("waiting...");
          } else if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return Column(
              children: [
                Image.network(
                  reviewData['productImageUrl'],
                ),
                RatingBar.builder(
                  itemSize: widthVar / 30,
                  initialRating:
                      double.parse(reviewData['productRating'].toString()),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Color(0xFFC21010),
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
