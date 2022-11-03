// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/profilecontents.dart';

// ignore: camel_case_types
class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

// ignore: camel_case_types
class _profilePageState extends State<profilePage> {
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(
          child: Text(
            "My Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color(0xFFC21010),
      ),
      body: const Body(),
    );
  }
}
