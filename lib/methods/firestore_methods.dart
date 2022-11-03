// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/methods/storage_methods.dart';
import 'package:pamine_mobile/model/livestream_model.dart';
import 'package:uuid/uuid.dart';
import '../utils/utils.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storageMethods = StorageMethods();
  final _auth = FirebaseAuth.instance;

  Future<String> startLiveStream(BuildContext context, String title,
      Uint8List? image, List? selectedItems) async {
    String? channelId = "";
    try {
      if (title.isNotEmpty && image != null && selectedItems != null) {
        if (!((await _firestore
                .collection('livestream')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .get())
            .exists)) {
          String thumbnailUrl = await _storageMethods.uploadImageToStorage(
            'livestream-thumbnails',
            image,
            FirebaseAuth.instance.currentUser!.uid,
          );

          channelId = FirebaseAuth.instance.currentUser?.uid;

          LiveStream liveStream = LiveStream(
              title: title,
              image: thumbnailUrl,
              uid: _auth.currentUser!.uid,
              username: _auth.currentUser!.displayName!,
              viewers: 0,
              channelId: channelId!,
              startedAt: DateTime.now(),
              category: selectedItems);

          await _firestore
              .collection('livestream')
              .doc(channelId)
              .set(liveStream.toMap());
        } else {
          showSnackBar(
              context, 'Two Livestreams cannot start at the same time.');
        }
      } else {
        showSnackBar(context, 'Please enter all the fields');
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
    }
    return channelId!;
  }

  Future<void> chat(String text, String id, BuildContext context) async {
    CollectionReference userBuyer =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot snapshot =
        await userBuyer.doc(FirebaseAuth.instance.currentUser!.uid).get();
    String displayName = snapshot['displayName'];
    try {
      String commentId = const Uuid().v1();
      await _firestore
          .collection('livestream')
          .doc(id)
          .collection('comments')
          .doc(commentId)
          .set({
        'username':
            FirebaseAuth.instance.currentUser!.displayName == displayName
                ? FirebaseAuth.instance.currentUser!.displayName
                : displayName,
        'message': text,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'createdAt': DateTime.now(),
        'commentId': commentId,
      });
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> updateViewCount(String id, bool isIncrease) async {
    try {
      await _firestore.collection('livestream').doc(id).update({
        'viewers': FieldValue.increment(isIncrease ? 1 : -1),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> endLiveStream(String channelId) async {
    try {
      QuerySnapshot snap = await _firestore
          .collection('livestream')
          .doc(channelId)
          .collection('comments')
          .get();

      for (int i = 0; i < snap.docs.length; i++) {
        await _firestore
            .collection('livestream')
            .doc(channelId)
            .collection('comments')
            .doc(
              ((snap.docs[i].data()! as dynamic)['commentId']),
            )
            .delete();
      }

      await _firestore.collection('livestream').doc(channelId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
