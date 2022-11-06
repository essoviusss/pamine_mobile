import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pamine_mobile/model/cart_model.dart';

class Cart extends StatefulWidget {
  const Cart({
    super.key,
  });

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  CollectionReference cartItemDel = FirebaseFirestore.instance
      .collection("buyer_info")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("cart");

  Future<void> itemDelete(String itemId) async {
    await cartItemDel.doc(itemId).delete();
  }

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFFC21010),
        title: const Text("My Cart"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: heightVar / 60,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: widthVar / 25),
              child: const Text(
                "Cart Items",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            StreamBuilder<dynamic>(
              stream: FirebaseFirestore.instance
                  .collection("buyer_info")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("cart")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.waveDots(
                    color: Colors.blue,
                    size: 50,
                  );
                } else {
                  return SingleChildScrollView(
                    child: Container(
                      height: heightVar / 2,
                      margin: EdgeInsets.only(
                        left: widthVar / 25,
                        right: widthVar / 25,
                      ),
                      child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            CartModel cartItem = CartModel.fromMap(
                                snapshot.data.docs[index].data());
                            return Container(
                              height: heightVar / 10,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    spreadRadius: 0.1,
                                    blurStyle: BlurStyle.normal,
                                    color: Colors.grey,
                                    blurRadius: 10,
                                    offset: Offset(4, 8), // Shadow position
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.only(
                                bottom: heightVar / 80,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: widthVar / 20),
                                    child: Image.network(
                                      cartItem.productImageUrl!,
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                  SizedBox(
                                    width: widthVar / 6,
                                  ),
                                  Wrap(
                                    spacing: widthVar / 20,
                                    children: [
                                      SizedBox(
                                        width: widthVar / 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              cartItem.productName!,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "₱${cartItem.productPrice!}.00"),
                                            Text("Quantity: "),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          itemDelete(
                                              snapshot.data!.docs[index].id);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Color(0xFFC21010),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  );
                }
              },
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                left: widthVar / 25,
                right: widthVar / 25,
                top: heightVar / 70,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Price Breakdown",
                    style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    children: [
                      const Text(
                        "Base Price",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(""),
                    ],
                  ),
                  Text("Taxes",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("Delivery Fee",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("Total",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFC21010)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: widthVar / 3.9, vertical: heightVar / 60),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Checkout',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
