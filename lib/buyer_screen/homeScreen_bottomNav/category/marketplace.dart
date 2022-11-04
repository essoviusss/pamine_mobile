import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/productdescription.dart';

import '../../../model/product_model.dart';

class Marketplace extends StatefulWidget {
  final String productImageUrl;
  final String productName;
  final String productPrice;
  final String productQuantity;
  final String productDescription;
  final String productCategory;
  final String sellerUid;

  const Marketplace({
    super.key,
    required this.productImageUrl,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productDescription,
    required this.productCategory,
    required this.sellerUid,
  });

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace> {
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.03),
          StreamBuilder<dynamic>(
            stream: FirebaseFirestore.instance
                .collectionGroup("products")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: ((widthVar / 2.2) / (heightVar / 3.8)),
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    Products post =
                        Products.fromMap(snapshot.data.docs[index].data());

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProductDescription(
                              productName: post.productName!,
                              productPrice: post.productPrice!,
                              productCategory: post.productCategory!,
                              productDescription: post.productDescription!,
                              productImageUrl: post.productImageUrl!,
                              productQuantity: post.productQuantity!,
                              sellerUid: post.sellerUid!,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 3.0, color: Colors.grey.shade300),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Image.network(post.productImageUrl!),
                                  ),
                                  SizedBox(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: heightVar / 99)),
                                  ),
                                  Text(
                                    post.productName!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("₱${post.productPrice!}.00",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
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
            },
          ),
        ],
      ),
    );
  }
}
