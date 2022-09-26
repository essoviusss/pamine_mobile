// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pamine_mobile/screens/front.dart';
import 'package:pamine_mobile/screens/splashScreen.dart';
import 'package:pamine_mobile/seller_screen/approval_screen.dart';
import 'package:pamine_mobile/seller_screen/seller_home.dart';
import 'package:pamine_mobile/seller_screen/seller_verification.dart';

class approval_controller extends StatefulWidget {
  const approval_controller({super.key});

  @override
  State<approval_controller> createState() => _approval_controllerState();
}

class _approval_controllerState extends State<approval_controller> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingAnimationWidget.waveDots(
            color: Colors.blue,
            size: 50,
          );
        }
        if (snapshot.connectionState == ConnectionState.active &&
            auth.currentUser != null) {
          final bool isWaiting = snapshot.hasData;
          return isWaiting
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(auth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final String isSubmitted = snapshot.data?['role'];
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("seller_info")
                              .doc(auth.currentUser!.uid)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (isSubmitted == "Seller" &&
                                snapshot.data?.exists == false) {
                              return const seller_verification(); //add streambuilder later
                            } else if (snapshot.data?['status'] ==
                                "not verified") {
                              return const approval_screen(); //add streambuilder later
                            } else if (snapshot.data?['status'] == "verified") {
                              return const seller_home(); //add streambuilder later
                            } else if (snapshot.data?['status'] == "rejected") {
                              Fluttertoast.showToast(
                                  msg: "Application Rejected");
                              return const front();
                            } else {
                              return const SplashScreen();
                            }
                          });
                    }
                    return const SplashScreen();
                  },
                )
              : const SplashScreen();
        }
        return const SplashScreen();
      },
    );
  }
}
