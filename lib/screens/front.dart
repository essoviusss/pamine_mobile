import 'package:flutter/material.dart';
import 'package:pamine_mobile/buyer_screen/buyer_login.dart';
import 'package:pamine_mobile/seller_screen/seller_login.dart';

// ignore: camel_case_types
class front extends StatelessWidget {
  const front({Key? key}) : super(key: key);
  static const String id = 'front';
  static const routeName = '/front';

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffC7CDE4),
      body: Column(
        children: [
          Container(
            //logo
            height: heightVar / 2,
            width: widthVar / 1,
            margin: EdgeInsets.only(top: heightVar / 10),
            child: Center(
              child: Image.asset('assets/images/wel_logo.png'),
            ),
          ),
          Container(
            //Button 1
            margin: EdgeInsets.only(top: heightVar / 15),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xff193251)),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(
                      horizontal: widthVar / 12, vertical: heightVar / 65),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const seller_login()),
                );
              },
              child: const Text(
                'I am a Seller!',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    letterSpacing: 2),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: heightVar / 60),
            //Button 2
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xff193251)),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(
                      horizontal: widthVar / 12, vertical: heightVar / 65),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const buyer_login()),
                );
              },
              child: const Text(
                'I am a Buyer!',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    letterSpacing: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
