import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WriteReview extends StatefulWidget {
  final String? productId;
  final String? productImageUrl;
  final String? productName;
  final String? transactionId;
  final int? subtotal;
  final int? quantity;
  final String? sellerUid;
  final String? shopName;
  final String? buyerName;
  final List? index;

  const WriteReview({
    super.key,
    required this.productId,
    required this.productImageUrl,
    required this.productName,
    required this.transactionId,
    required this.subtotal,
    required this.quantity,
    required this.sellerUid,
    required this.shopName,
    required this.buyerName,
    required this.index,
  });

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  final TextEditingController commentController = TextEditingController();
  final ref = FirebaseFirestore.instance;
  double? productRating;
  final transacList =
      FirebaseFirestore.instance.collectionGroup("transactionList");

  addReview() async {
    ref
        .collection("seller_info")
        .doc(widget.sellerUid)
        .collection("sold")
        .doc(widget.productId)
        .set(
      {
        "productId": widget.productId,
        "buyerName": widget.buyerName,
        "productName": widget.productName,
        "productImageUrl": widget.productImageUrl,
        "productRating": productRating,
        "quantity": widget.quantity,
        "comment": commentController.text,
      },
      SetOptions(merge: false),
    );
  }

  reviewed() async {
    await addReview();
    WriteBatch batch = FirebaseFirestore.instance.batch();

    await transacList.get().then((value) {
      for (var orderList in value.docs) {
        print(orderList.reference);
        if ("#${orderList.id}".contains(widget.transactionId!)) {
          batch.set(
              orderList.reference,
              {
                "itemList"[0]: FieldValue.arrayUnion([
                  {
                    "isReviewed": true,
                  }
                ]),
              },
              SetOptions(merge: true));
        }
      }
      return batch.commit().then((value) {
        Fluttertoast.showToast(msg: "Review has been submitted!");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            left: widthVar / 35,
            right: widthVar / 35,
            top: heightVar / 60,
          ),
          child: Column(
            children: [
              SizedBox(
                height: heightVar / 60,
              ),
              const Text(
                "Write a review",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFFC21010)),
              ),
              SizedBox(
                height: heightVar / 60,
              ),
              Image.network(
                widget.productImageUrl!,
              ),
              SizedBox(
                width: widthVar / 25,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: heightVar / 60,
                  ),
                  Text(
                    "Product Id: ${widget.productId!}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text("Product Name: ${widget.productName!}"),
                  Text("Price: ₱${widget.subtotal.toString()}.00"),
                  Text("Shop Name: ${widget.shopName}"),
                  const Divider(
                    color: Colors.grey,
                  ),
                  const Text("Rate Product",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC21010))),
                  SizedBox(
                    height: heightVar / 100,
                  ),
                  RatingBar.builder(
                    itemSize: widthVar / 6,
                    initialRating: 0,
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
                      productRating = rating;
                      print(productRating);
                    },
                  ),
                  SizedBox(
                    height: heightVar / 100,
                  ),
                  const Text("Add Comment",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC21010))),
                  SizedBox(
                    height: heightVar / 100,
                  ),
                  TextFormField(
                    minLines: 5,
                    maxLines: 5,
                    controller: commentController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Field Required");
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Comment...",
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.red.shade300),
                      contentPadding: const EdgeInsets.all(15),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(width: 0, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: heightVar / 60,
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFC21010)),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              horizontal: widthVar / 8, vertical: 15),
                        ),
                      ),
                      onPressed: () {
                        reviewed();
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: heightVar / 30,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
