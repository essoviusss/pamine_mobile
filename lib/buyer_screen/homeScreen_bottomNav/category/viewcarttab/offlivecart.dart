import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pamine_mobile/model/cart_model.dart';

class OffLiveCart extends StatefulWidget {
  const OffLiveCart({super.key});

  @override
  State<OffLiveCart> createState() => _OffLiveCartState();
}

class _OffLiveCartState extends State<OffLiveCart> {
  CollectionReference cartItemDel = FirebaseFirestore.instance
      .collection("buyer_info")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("cart");

  Future<void> itemDelete(String itemId) async {
    await cartItemDel.doc(itemId).delete();
  }

  int? basetotal;
  int? subtotal1;

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
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
                final cartItems = snapshot.data?.docs.map(
                    (DocumentSnapshot doc) => CartModel.fromMap(doc.data()));

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.waveDots(
                    color: Colors.blue,
                    size: 50,
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: heightVar / 2,
                          margin: EdgeInsets.only(
                            left: widthVar / 25,
                            right: widthVar / 25,
                          ),
                          child: ListView.builder(
                              itemCount: cartItems.length,
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
                                        margin: EdgeInsets.only(
                                            left: widthVar / 20),
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                    "₱${cartItem.productPrice.toString()}.00"),
                                                Text(
                                                    "Qty: ${cartItem.productQuantity}"),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              itemDelete(
                                                  snapshot.data.docs[index].id);
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
                      ],
                    ),
                  );
                }
              },
            ),
            Container(
              margin: EdgeInsets.only(top: heightVar / 30),
              child: StreamBuilder<dynamic>(
                stream: FirebaseFirestore.instance
                    .collection("buyer_info")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("cart")
                    .snapshots(),
                builder: (context, snapshot) {
                  final cartItems =
                      snapshot.data?.docs.map((DocumentSnapshot doc) {
                    CartModel.fromMap(doc.data());
                    subtotal1 = doc.get("subtotal");
                  });

                  basetotal = cartItems?.fold(
                      0, (subtotal, index) => subtotal + subtotal1!);

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print("waiting...");
                  } else {
                    return Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        left: widthVar / 25,
                        right: widthVar / 25,
                        top: heightVar / 70,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Subtotal: ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text("₱$basetotal.00",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFC21010))),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: widthVar / 50,
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
