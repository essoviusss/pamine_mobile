import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/cart.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

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
              builder: (context) => const Cart(),
            ),
          );
        },
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("buyer_info")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("cart")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            int? count = snapshot.data?.docs.length;
            if (snapshot.connectionState == ConnectionState.waiting) {
              print("waiting...");
            }
            if (snapshot.hasData) {
              return Badge(
                badgeColor: const Color.fromARGB(255, 158, 158, 158),
                position: BadgePosition.topEnd(top: -5, end: -3),
                animationDuration: const Duration(seconds: 1),
                badgeContent: Text('$count'),
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 35,
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
