// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        if (snapshot.connectionState == ConnectionState.active &&
            auth.currentUser != null) {
          final bool isWaiting = snapshot.hasData;
          return isWaiting
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("seller_info")
                      .doc(auth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.data?['status'] == "not verified") {
                      return const approval_screen();
                    } else {
                      return const seller_home();
                    }
                  },
                )
              : const seller_verification();
        }
        return const seller_verification();
      },
    );
  }
}
