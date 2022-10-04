import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/model/product_model.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
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
                .collection('seller_info')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("products")
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

                    return Card(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 3.0, color: Colors.grey.shade300),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child:
                                          Image.network(post.productImageUrl!),
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
                                    Text(post.productPrice!,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: heightVar / 150),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    splashColor: Colors.blue,
                                    icon: const Icon(Icons.edit),
                                    color: Colors.red,
                                    onPressed: () {},
                                  ),
                                  SizedBox(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: widthVar / 12)),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            )
                          ],
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
