// ignore_for_file: avoid_print, duplicate_ignore, camel_case_types, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pamine_mobile/controllers/approval_controller.dart';
import 'package:pamine_mobile/model/seller_user_model.dart';
import 'package:pamine_mobile/seller_screen/seller_verification.dart';
import 'seller_signup.dart';

class seller_login extends StatefulWidget {
  const seller_login({Key? key}) : super(key: key);
  static const String id = "seller_login";

  @override
  State<seller_login> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<seller_login> {
  //key
  final _formKey = GlobalKey<FormState>();

  //EmailAndPassword Auth
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? role;

  Future<void> getRole() async {
    CollectionReference userRole =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot snapshot =
        await userRole.doc(FirebaseAuth.instance.currentUser!.uid).get();
    role = snapshot['role'];
  }

  void signIn(String email, String password) async {
    if (role == "Seller") {
      if (_formKey.currentState!.validate()) {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const approval_controller())),
                })
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      }
    } else {
      Fluttertoast.showToast(msg: "No account found!");
    }
  }

  //Google Auth
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await auth
            .signInWithCredential(authCredential)
            .then((value) => {postUIDtoFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  postUIDtoFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;

    ProviderModel providerModel = ProviderModel(displayName: '', uid: '');

    providerModel.uid = user!.uid;
    providerModel.displayName = user.displayName!;
    providerModel.email = user.email;
    providerModel.role = "Seller";

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(providerModel.toMap())
        .then(
      (value) {
        Fluttertoast.showToast(msg: "Google Authentication Successful");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const approval_controller()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                //logo
                height: heightVar / 3,
                width: widthVar / 1,
                margin: EdgeInsets.only(top: heightVar / 6.5),
                child: Center(
                  child: Image.asset('assets/images/seller_login_logo.png'),
                ),
              ),
              //Input field 1
              Container(
                margin: EdgeInsets.only(top: heightVar / 25),
                padding:
                    EdgeInsets.symmetric(horizontal: widthVar / 6, vertical: 0),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter Your Email");
                    } else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ("Please Enter a valid Email");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _emailController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'Email Address',
                    hintStyle:
                        const TextStyle(fontSize: 15.0, color: Colors.grey),
                    contentPadding: const EdgeInsets.all(15),
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xffF7F5F2),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(width: 0, color: Colors.white),
                    ),
                  ),
                ),
              ),
              //Input field 2
              Container(
                margin: EdgeInsets.only(top: heightVar / 75),
                padding:
                    EdgeInsets.symmetric(horizontal: widthVar / 6, vertical: 0),
                child: TextFormField(
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{8,}$');
                    if (value!.isEmpty) {
                      return ("Please Enter Your Password");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Invalid Password");
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _passwordController.text = value!;
                  },
                  textInputAction: TextInputAction.done,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: 'Password',
                    hintStyle:
                        const TextStyle(fontSize: 15.0, color: Colors.grey),
                    contentPadding: const EdgeInsets.all(15),
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xffF7F5F2),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(width: 0, color: Colors.white),
                    ),
                  ),
                ),
              ),
              //Login Button
              Container(
                margin: EdgeInsets.only(top: heightVar / 40),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffC21010)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: widthVar / 3.7, vertical: 10),
                    ),
                  ),
                  onPressed: () async {
                    signIn(_emailController.text, _passwordController.text);
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: heightVar / 90),
                child: TextButton(
                  onPressed: () async {
                    await signInWithGoogle();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffF7F5F2)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: widthVar / 7.4, vertical: 10),
                    ),
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/google.png',
                        scale: 1.5,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: widthVar / 30),
                        child: const Text(
                          "Sign in with Google",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Below button
              Container(
                margin: EdgeInsets.only(bottom: heightVar / 80),
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: widthVar / 12, vertical: heightVar / 100),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const seller_signup()),
                    );
                  },
                  child: const Center(
                    child: Text("Don't have an account? Sign Up",
                        style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
