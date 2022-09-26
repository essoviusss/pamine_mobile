// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/methods/storage_methods.dart';
import 'package:pamine_mobile/model/livestream_model.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import '../utils/utils.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storageMethods = StorageMethods();

  Future<String> startLiveStream(
      BuildContext context, String title, Uint8List? image) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    String? channelId = FirebaseAuth.instance.currentUser?.uid;
    try {
      if (title.isNotEmpty && image != null) {
        if (!((await _firestore
                .collection('livestream')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .get())
            .exists)) {
          String thumbnailUrl = await _storageMethods.uploadImageToStorage(
            'livestream-thumbnails',
            image,
            user.user.uid!,
          );

          LiveStream liveStream = LiveStream(
            title: title,
            image: thumbnailUrl,
            uid: user.user.uid!,
            username: user.user.displayName!,
            viewers: 0,
            channelId: channelId!,
            startedAt: DateTime.now(),
          );

          _firestore
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
}
