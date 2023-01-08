// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:pamine_mobile/seller_screen/profile_components/profilemenu.dart';
import 'package:pamine_mobile/seller_screen/profile_components/profilepage_contents/buyerslist.dart';
import 'package:pamine_mobile/seller_screen/profile_components/profilepage_contents/myproducts.dart';
import 'package:pamine_mobile/seller_screen/profile_components/profilepic.dart';

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
            text: "My Shop",
            icon: const Icon(Icons.shop_2, color: Colors.red),
            press: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MyProducts(),
                ),
              ),
            },
          ),
          ProfileMenu(
            text: "Transactions",
            icon: const Icon(Icons.list, color: Colors.red),
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BuyersList(),
                ),
              );
            },
          ),
          ProfileMenu(
            text: "Product Reviews",
            icon: const Icon(Icons.sell, color: Colors.red),
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: const Icon(Icons.logout, color: Colors.red),
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
