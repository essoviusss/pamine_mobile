import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../model/product_model.dart';

class MyProducts extends StatelessWidget {
  const MyProducts({super.key});

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: Colors.red,
        title: const Text("My Products"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("seller_info")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("products")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            LoadingAnimationWidget.waveDots(
              color: Colors.blue,
              size: 50,
            );
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: ((widthVar / 2.2) / (heightVar / 3.8)),
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              shrinkWrap: true,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                Products post =
                    Products.fromMap(snapshot.data?.docs[index].data());

                return Card(
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 3.0, color: Colors.grey.shade300),
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
                                  child: Image.network(post.productImageUrl!),
                                ),
                                SizedBox(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(top: heightVar / 99)),
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
                      ],
                    ),
                  ),
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
