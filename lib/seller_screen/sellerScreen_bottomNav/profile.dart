// ignore_for_file: use_build_context_synchronously, camel_case_types, depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pamine_mobile/seller_screen/profile_components/profilecontents.dart';

import '../../screens/front.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final _auth = FirebaseAuth.instance;

signOut() async {
  await _auth.signOut();
  await auth.signOut();
  await _googleSignIn.signOut();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("My Profile")),
          backgroundColor: Colors.red,
        ),
        body: const Body());
  }
}
