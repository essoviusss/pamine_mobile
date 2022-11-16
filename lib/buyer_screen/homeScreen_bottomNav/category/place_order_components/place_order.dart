import 'package:flutter/material.dart';

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
        title: const Text("Payment Receipt"),
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
                  Icons.receipt,
                  color: Colors.red,
                  size: 70,
                ),
                const Text(
                  "Payment Success",
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
                  height: heigthVar / 40,
                ),
                const Icon(
                  Icons.check_circle,
                  size: 150,
                  color: Colors.red,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
