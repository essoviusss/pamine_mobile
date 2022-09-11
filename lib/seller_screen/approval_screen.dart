// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class approval_screen extends StatefulWidget {
  const approval_screen({super.key});

  @override
  State<approval_screen> createState() => _approval_screenState();
}

class _approval_screenState extends State<approval_screen> {
  @override
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Waiting for Admin Approval...',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: heightVar / 50),
            child: Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: Colors.blue,
                size: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
