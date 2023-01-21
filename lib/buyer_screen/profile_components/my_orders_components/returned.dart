import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Returned extends StatefulWidget {
  const Returned({super.key});

  @override
  State<Returned> createState() => _ReturnedState();
}

class _ReturnedState extends State<Returned> {
  final transacList = FirebaseFirestore.instance
      .collectionGroup("transactionList")
      .where("buyerUid", isEqualTo: FirebaseAuth.instance.currentUser?.uid);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<dynamic>(
        stream: transacList.snapshots(),
        builder: (context, snapshot) {
          int? itemCount = snapshot.data?.docs.length;
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("waiting...");
          } else if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return Expanded(
                  child: Container(),
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
