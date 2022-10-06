import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PinProduct {
  CollectionReference sellerProd = FirebaseFirestore.instance
      .collection("seller_info")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("products");

  Future<void> pinSellerProduct(
      {CollectionReference? reference,
      Map<String, dynamic>? data,
      String? docName}) {
    return reference!.doc(docName).update(data!);
  }
}
