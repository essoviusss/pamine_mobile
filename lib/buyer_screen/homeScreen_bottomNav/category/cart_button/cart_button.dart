import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/cart.dart';

class CartButton extends StatefulWidget {
  const CartButton({super.key});

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  User? user = FirebaseAuth.instance.currentUser;
  int? count1;
  int? count;
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(right: widthVar / 40),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Cart(
                sellerUid: '',
              ),
            ),
          );
        },
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("buyer_info")
              .doc(user?.uid)
              .collection("cart")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            count = snapshot.data?.docs.length;
            if (snapshot.connectionState == ConnectionState.waiting) {
              print("waiting...");
            }
            if (snapshot.hasData) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collectionGroup("minedProducts")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  int? count1 = snapshot.data?.docs.length;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print("waiting...");
                  }
                  if (snapshot.hasData) {
                    int totalCount = count! + count1!;
                    return Badge(
                      badgeColor: const Color.fromARGB(255, 158, 158, 158),
                      position: BadgePosition.topEnd(top: 0, end: -3),
                      animationDuration: const Duration(seconds: 1),
                      badgeContent: Center(child: Text('$totalCount')),
                      child: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 35,
                      ),
                    );
                  }
                  return Container();
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
