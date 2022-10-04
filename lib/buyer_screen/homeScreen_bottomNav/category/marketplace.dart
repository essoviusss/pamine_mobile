import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../model/product_model.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({super.key});

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
          Container(
            padding: EdgeInsets.symmetric(horizontal: widthVar / 4),
            margin: EdgeInsets.only(top: heightVar / 60),
            child: TextField(
              decoration: InputDecoration(
                  hintStyle: const TextStyle(fontSize: 15.0, color: Colors.red),
                  contentPadding: const EdgeInsets.all(0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                    borderSide: BorderSide(width: 0, color: Colors.white),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search...'),
              onChanged: (val) {
                setState(() {});
              },
            ),
          ),
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
                      onTap: () {},
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
