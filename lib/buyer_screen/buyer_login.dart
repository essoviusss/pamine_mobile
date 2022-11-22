// ignore_for_file: avoid_print, duplicate_ignore, camel_case_types, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:pamine_mobile/buyer_screen/home_screen.dart';
import 'package:pamine_mobile/model/buyer_user_model.dart';
import 'buyer_signup.dart';

class buyer_login extends StatefulWidget {
  const buyer_login({Key? key}) : super(key: key);
  static const String id = "buyer_login";

  @override
  State<buyer_login> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<buyer_login> {
  final _formKey = GlobalKey<FormState>();

  //EmailandPassword Auth
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const home_screen())),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
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

    ProviderModel providerModel = ProviderModel();

    providerModel.uid = user?.uid;
    providerModel.displayName = user?.displayName;
    providerModel.email = user?.email;
    providerModel.role = "Buyer";

    await firebaseFirestore
        .collection("users")
        .doc(user?.uid)
        .set(providerModel.toMap())
        .then((value) {
      Fluttertoast.showToast(msg: "Google Authentication Successful");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const home_screen()));
    });
  }

  bool isChecked = false;
  bool isCheckedTerms = false;
  bool buttonDone = false;
  bool isObscured = true;

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
              Container(
                //logo
                height: heightVar / 3,
                width: widthVar / 1,
                margin: EdgeInsets.only(top: heightVar / 6.5),
                child: Center(
                  child: Image.asset('assets/images/login_logo.png'),
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
                    fillColor: Colors.white,
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
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(width: 0, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: heightVar / 60,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: widthVar / 6),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    MSHCheckbox(
                      size: 20,
                      value: isChecked,
                      colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                          checkedColor: Colors.red,
                          uncheckedColor: Colors.white),
                      style: MSHCheckboxStyle.stroke,
                      onChanged: (selected) {
                        setState(() {
                          isChecked = selected;
                        });
                        if (isCheckedTerms == true && buttonDone == true) {
                          setState(() {
                            isChecked = true;
                          });
                        } else if (isCheckedTerms == false &&
                            buttonDone == false) {
                          setState(() {
                            isChecked = false;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      width: widthVar / 40,
                    ),
                    const Text(
                      "Agree to Terms & Conditions",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
              //Login Button
              Container(
                margin: EdgeInsets.only(top: heightVar / 40),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xff193251)),
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
                    if (isChecked == false) {
                      showBarModalBottomSheet(
                        expand: true,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return Container(
                              height: double.infinity,
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: heightVar / 40,
                                    ),
                                    const Center(
                                      child: Text(
                                        "Terms and Conditions",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: widthVar / 25,
                                          right: widthVar / 25,
                                          top: heightVar / 60),
                                      child: Column(
                                        children: [
                                          Text(
                                            "\t\t\t\t\tThis page contains the Terms and Conditions of Service "
                                            "(hence, the 'Terms') for our application, which is provided "
                                            "together with any related products and services. These Terms "
                                            "are an addition to our privacy statement (the 'Policy'), which "
                                            "is incorporated herein by reference."
                                            "\n\n"
                                            "\t\t\t\t\tPa-Mine is responsible for delivering the application and the offered services and "
                                            "products. The terms 'client', 'user', 'you', and 'your' refer to the user logged into this "
                                            "application and agreeing to be bound by the terms and conditions of the Company "
                                            "'ourselves', 'we', 'ours', and 'us' refer to our parent and holding companies. The "
                                            "terminology 'Terms' 'Privacy Policy' 'Cookie Statement' 'Accessibility Disclaimer', "
                                            "and other guidelines or agreements referenced herein and/or offered by us from time to "
                                            "'time' is referred to herein Any use of the aforementioned terms or other words, "
                                            "whether they are written in the singular, plural, capitalized, or with he/she or they, is "
                                            "understood to be referring to the same thing."
                                            "\n\n"
                                            "\t\t\t\t\tAll of the terms herein refer to the offer, acceptance, and consideration of payment "
                                            "necessary to carry out the process of our assistance to the user in the most suitable "
                                            "manner for the specific purpose of addressing the client's needs in relation to the "
                                            "delivery of Pa-Mine's stated services, in accordance with and subject to, prevailing laws "
                                            "applicable to Pa-Mine. Any use of the aforementioned language, as well as any "
                                            "additional words in the singular, plural, capitalization, or with the pronouns he/she or "
                                            "they, is understood to be interchangeable and to be referring to the same thing. "
                                            "\n\n"
                                            "\t\t\t\t\tTherefore, by using this application, you agree to be bound by these Terms, all "
                                            "applicable laws, and regulations and accept that you are in charge of adhering to any "
                                            "local laws that may be in force. This application cannot be used or accessed by you if "
                                            "you disagree with any of these terms. The relevant copyright and trademark laws "
                                            "protect the materials in this application. "
                                            "\n",
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontSize: 12),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Services Offered.",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Pa-Mine is a live streaming application where sellers showcase their products through "
                                            "live streams, allowing customers to buy products in real time. Additionally, there is an "
                                            "online marketplace where items that are not being streamed live are listed. Pa-Mine "
                                            "hereby agrees to provide its live stream and online marketplace platform services (the "
                                            "'Services'), subject to the following Terms, to I visitors who browse the application, (ii) "
                                            "buyers and sellers of items registered into the application, and (iii) any other users who "
                                            "have opened an account. "
                                            "\n\n"
                                            "Please remember that certain providers may be located in or have facilities that are "
                                            "located in a different jurisdiction than either you or us. Therefore, if you elect to "
                                            "proceed with a transaction that involves the products or services of a third-party service "
                                            "provider, then your information may become subject to the laws of the jurisdiction(s) in "
                                            "which that service provider or its facilities are located."
                                            "\n",
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontSize: 12),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Account Registration, Verification, and Safety.",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "You must register for an account and fill out all of the required fields on the registration "
                                            "form before using our Services. You must provide true and accurate information, and "
                                            "you hereby agree to keep the password you chose when making your account private "
                                            "and not to disclose it to anyone else. "
                                            "\n\n"
                                            "You are required to notify us right away if you lose it or disclose it. You are solely in "
                                            "charge of monitoring the activity on your account, protecting the confidentiality of your "
                                            "password, and notifying us right away in the event that your account is breached or "
                                            "used without your permission.",
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: heightVar / 40,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                MSHCheckbox(
                                                  size: 20,
                                                  value: isCheckedTerms,
                                                  colorConfig: MSHColorConfig
                                                      .fromCheckedUncheckedDisabled(
                                                    checkedColor: Colors.red,
                                                  ),
                                                  style:
                                                      MSHCheckboxStyle.stroke,
                                                  onChanged: (selected) {
                                                    setState(() {
                                                      isCheckedTerms = selected;
                                                    });
                                                    if (isCheckedTerms ==
                                                        true) {
                                                      print("true");
                                                    } else if (isCheckedTerms ==
                                                        false) {
                                                      print('false');
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                  width: widthVar / 40,
                                                ),
                                                const Text(
                                                  "Accept Terms & Conditions",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: isCheckedTerms == true
                                                ? TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<
                                                                      Color>(
                                                                  const Color(
                                                                      0xffC21010)),
                                                      padding:
                                                          MaterialStateProperty
                                                              .all<EdgeInsets>(
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                widthVar / 10,
                                                            vertical: 10),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        buttonDone = true;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      "Done",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                : TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  Colors.grey),
                                                      padding:
                                                          MaterialStateProperty
                                                              .all<EdgeInsets>(
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                widthVar / 10,
                                                            vertical: 10),
                                                      ),
                                                    ),
                                                    onPressed: null,
                                                    child: const Text(
                                                      "Done",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                          ),
                                          SizedBox(
                                            height: heightVar / 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                            ;
                          });
                        },
                      );
                    } else if (isChecked == true) {
                      await signInWithGoogle();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
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
                          builder: (context) => const buyer_signup()),
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
