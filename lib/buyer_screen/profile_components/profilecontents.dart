// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/delivery_details_components/add_delivery_details.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/my_orders_components/my_orders.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/payment_methods_components/add_payment_method.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/profilemenu.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/profilepic.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/delivery_details_components/delivery_details.dart';

import '../../screens/front.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //SignOut EmailAndPassword && Google Auth
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;

  signOut() async {
    await _auth.signOut();
    await auth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const ProfilePic(),
          const SizedBox(height: 20),
          ProfileMenu(
            text: "My Orders",
            icon: const Icon(Icons.shopping_bag, color: Color(0xFFC21010)),
            press: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MyOrders(),
                ),
              ),
            },
          ),
          ProfileMenu(
            text: "Delivery Details",
            icon: const Icon(Icons.location_city, color: Color(0xFFC21010)),
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddDeliveryDetails(),
                ),
              );
            },
          ),
          ProfileMenu(
            text: "Payment Methods",
            icon: const Icon(Icons.payment, color: Color(0xFFC21010)),
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddPaymentMethod(),
                ),
              );
            },
          ),
          ProfileMenu(
            text: "Log Out",
            icon: const Icon(Icons.logout, color: Color(0xFFC21010)),
            press: () async {
              await signOut();
              await Fluttertoast.showToast(msg: "You have been logged out!");
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                return const front();
              }), ModalRoute.withName('/'));
            },
          ),
        ],
      ),
    );
  }
}
