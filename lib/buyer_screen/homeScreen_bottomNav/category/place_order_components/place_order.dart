import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/home.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/my_orders_components/my_orders.dart';

class PlaceOrder extends StatefulWidget {
  final int? grandTotal;
  const PlaceOrder({super.key, required this.grandTotal});

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  @override
  Widget build(BuildContext context) {
    double heigthVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC21010),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text("Payment Processing"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: heigthVar / 9,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  spreadRadius: 0.1,
                  blurStyle: BlurStyle.normal,
                  color: Colors.grey,
                  blurRadius: 10,
                  offset: Offset(4, 8), // Shadow position
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: widthVar / 12),
            height: heigthVar / 1.7,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: heigthVar / 60,
                ),
                const Icon(
                  Icons.receipt_long_rounded,
                  color: Color(0xFFC21010),
                  size: 70,
                ),
                const Text(
                  "Your order is being processed!!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 96, 96, 96)),
                ),
                SizedBox(
                  height: heigthVar / 90,
                ),
                Column(
                  children: [
                    Text("Your order amounting ₱${widget.grandTotal}.00 has"),
                    const Text("been submitted to the seller")
                  ],
                ),
                SizedBox(
                  height: heigthVar / 17,
                ),
                const Icon(
                  Icons.check_circle,
                  size: 150,
                  color: Color(0xFFC21010),
                ),
                Column(
                  children: [
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          "Waiting for seller's approval...",
                          textStyle: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                      totalRepeatCount: 100000,
                      pause: const Duration(milliseconds: 0),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: false,
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.only(
                        bottom: heigthVar / 60,
                        left: widthVar / 25,
                        right: widthVar / 25),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const homePage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Back to home",
                              style: TextStyle(color: Color(0xFFC21010)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xFFC21010)),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.symmetric(
                                      horizontal: widthVar / 20,
                                      vertical: heigthVar / 60),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const MyOrders(),
                                  ),
                                );
                              },
                              child: const Text(
                                "View Order",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
