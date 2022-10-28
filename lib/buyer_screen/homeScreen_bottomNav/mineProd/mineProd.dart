import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  CollectionReference mine = FirebaseFirestore.instance
      .collection("buyer_info")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("mined_products");

  CollectionReference list =
      FirebaseFirestore.instance.collection("seller_info");

  CollectionReference newList =
      FirebaseFirestore.instance.collection("livestream");

  Future<void> mineProd({
    CollectionReference? reference,
    Map<String, dynamic>? data,
  }) {
    return reference!.doc().set(data!);
  }

  Future<void> mineProdList({
    CollectionReference? reference,
    Map<String, dynamic>? data,
  }) {
    return reference!.doc().set(data!);
  }

  Future<void> newmineProdList({
    CollectionReference? reference,
    Map<String, dynamic>? data,
  }) {
    return reference!.doc().set(data!);
  }
}
