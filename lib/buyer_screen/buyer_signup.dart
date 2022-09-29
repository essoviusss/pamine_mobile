// ignore_for_file: non_constant_identifier_names, camel_case_types
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pamine_mobile/buyer_screen/buyer_login.dart';
import 'package:pamine_mobile/model/buyer_user_model.dart';

class buyer_signup extends StatefulWidget {
  const buyer_signup({Key? key}) : super(key: key);

  @override
  State<buyer_signup> createState() => _buyer_signupState();
}

class _buyer_signupState extends State<buyer_signup> {
  //function
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final fullnameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmpasswordEditingController = TextEditingController();

  void SignUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.displayName = fullnameEditingController.text;
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.role = "Buyer";

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account Created Successfully");
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const buyer_login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffC7CDE4),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Image logo
              Container(
                height: heightVar / 5.5,
                margin: EdgeInsets.only(top: heightVar / 4.5),
                child: Image.asset('assets/images/signup_logo.png'),
              ),
              //Input field
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: widthVar / 6, vertical: 0),
                child: TextFormField(
                  controller: fullnameEditingController,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    fullnameEditingController.text = value!;
                  },
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    RegExp regex = RegExp(
                        r"^([a-zA-Z]{2,}\s[a-zA-z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)");
                    if (value!.isEmpty) {
                      return ("Please Enter a Valid Name");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Invalid name");
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    hintText: "Full Name",
                    hintStyle:
                        const TextStyle(fontSize: 15.0, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(15),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(width: 0, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: heightVar / 80),
                padding:
                    EdgeInsets.symmetric(horizontal: widthVar / 6, vertical: 0),
                child: TextFormField(
                  controller: emailEditingController,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    emailEditingController.text = value!;
                  },
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
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    hintText: "Email Address",
                    hintStyle:
                        const TextStyle(fontSize: 15.0, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(15),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(width: 0, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: heightVar / 80),
                padding:
                    EdgeInsets.symmetric(horizontal: widthVar / 6, vertical: 0),
                child: TextFormField(
                  controller: passwordEditingController,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    passwordEditingController.text = value!;
                  },
                  keyboardType: TextInputType.visiblePassword,
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
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_open),
                    hintText: "Password",
                    hintStyle:
                        const TextStyle(fontSize: 15.0, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(15),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(width: 0, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: heightVar / 80),
                padding:
                    EdgeInsets.symmetric(horizontal: widthVar / 6, vertical: 0),
                child: TextFormField(
                  controller: confirmpasswordEditingController,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    confirmpasswordEditingController.text = value!;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{8,}$');
                    if (value!.isEmpty) {
                      return ("Please Enter Your Password");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Invalid Password");
                    }
                    if (passwordEditingController.text !=
                        confirmpasswordEditingController.text) {
                      return ("Password input don't match");
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: "Confirm Password",
                    hintStyle:
                        const TextStyle(fontSize: 15.0, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(15),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(width: 0, color: Colors.white),
                    ),
                  ),
                ),
              ),
              //Button Signup
              Container(
                margin: EdgeInsets.only(top: heightVar / 50),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xff193251)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: widthVar / 3.9, vertical: 10),
                    ),
                  ),
                  onPressed: () {
                    SignUp(emailEditingController.text,
                        passwordEditingController.text);
                  },
                  child: const Text(
                    'Signup',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              //Below button
              Container(
                padding: EdgeInsets.only(bottom: heightVar / 80),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const buyer_login()),
                    );
                  },
                  child: const Text("Already have an account? Login",
                      style: TextStyle(color: Colors.blue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
