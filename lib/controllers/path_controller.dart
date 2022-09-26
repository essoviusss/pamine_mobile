import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pamine_mobile/buyer_screen/home_screen.dart';
import 'package:pamine_mobile/seller_screen/approval_screen.dart';
import 'package:pamine_mobile/seller_screen/seller_home.dart';
import 'package:pamine_mobile/seller_screen/seller_verification.dart';
import '../screens/splashScreen.dart';

// ignore: camel_case_types
class pathController extends StatefulWidget {
  const pathController({Key? key}) : super(key: key);
  static const String id = 'pathController';

  @override
  State<pathController> createState() => _pathControllerState();
}

// ignore: camel_case_types
class _pathControllerState extends State<pathController> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    final FirebaseAuth auth = FirebaseAuth.instance;
    return StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              auth.currentUser != null) {
            final bool signedIn = snapshot.hasData;
            return signedIn
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(auth.currentUser?.uid)
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        if (snapshot.data?['role'] == "Buyer" &&
                            snapshot.data?['uid'] == auth.currentUser?.uid) {
                          return const home_screen();
                        } else if (snapshot.data?['uid'] ==
                                auth.currentUser!.uid &&
                            snapshot.data?['role'] == "Seller") {
                          final String isSubmit = snapshot.data?['role'];
                          return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("seller_info")
                                  .doc(auth.currentUser!.uid)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                final bool? isSubmitted = snapshot.data?.exists;
                                if (isSubmit == "Seller" &&
                                    isSubmitted == false) {
                                  return const seller_verification();
                                } else if (snapshot.data?['status'] ==
                                    "not verified") {
                                  return const approval_screen();
                                } else if (snapshot.data?['status'] ==
                                    "verified") {
                                  return const seller_home();
                                } else {
                                  return const seller_verification();
                                }
                              });
                        } else {
                          return const seller_verification();
                        }
                      } else {
                        return const SplashScreen();
                      }
                    })
                : const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingAnimationWidget.waveDots(
              color: Colors.blue,
              size: 50,
            );
          }
          return const SplashScreen();
        });
  }
}
