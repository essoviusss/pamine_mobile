import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/buyer_screen/buyer_login.dart';
import 'package:pamine_mobile/buyer_screen/home_screen.dart';
import 'package:pamine_mobile/screens/front.dart';
import 'package:pamine_mobile/seller_screen/seller_home.dart';
import 'package:pamine_mobile/seller_screen/seller_login.dart';
import 'package:pamine_mobile/splashScreen.dart';
import 'path_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const pathController(),
      routes: {
        pathController.id: (context) => const pathController(),
        front.id: (context) => const front(),
        buyer_login.id: (context) => const buyer_login(),
        home_screen.id: (context) => const home_screen(),
        seller_login.id: (context) => const seller_login(),
        seller_home.id: (context) => const seller_home(),
      },
    );
  }
}
