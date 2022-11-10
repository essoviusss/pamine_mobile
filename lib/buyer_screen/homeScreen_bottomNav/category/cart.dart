import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/checkout.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/viewcarttab/inlivecart.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/viewcarttab/offlivecart.dart';

class Cart extends StatefulWidget {
  const Cart({
    super.key,
  });

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int value = 0;
  bool positive = false;
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFFC21010),
        title: const Text("My Cart"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: heightVar / 60, left: widthVar / 25),
              child: AnimatedToggleSwitch<bool>.dual(
                current: positive,
                first: false,
                second: true,
                dif: 50.0,
                borderColor: Colors.transparent,
                borderWidth: 5.0,
                height: 55,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1.5),
                  ),
                ],
                onChanged: (b) => setState(() => positive = b),
                colorBuilder: (b) =>
                    b ? const Color(0xFFC21010) : const Color(0xFFC21010),
                iconBuilder: (value) => value
                    ? const Icon(
                        Icons.shopping_bag,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                textBuilder: (value) => value
                    ? const Center(
                        child: Text(
                        'Mined Items',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                    : const Center(
                        child: Text('Cart Items',
                            style: TextStyle(fontWeight: FontWeight.bold))),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: heightVar / 100, left: widthVar / 25),
              alignment: Alignment.centerLeft,
              child: positive == true
                  ? const Text(
                      "Toggle button to view cart items",
                      style: TextStyle(
                          color: Colors.red, fontStyle: FontStyle.italic),
                    )
                  : const Text(
                      "Toggle button to view mined items",
                      style: TextStyle(
                          color: Colors.red, fontStyle: FontStyle.italic),
                    ),
            ),
            positive == true ? const InLiveCart() : const OffLiveCart(),
          ],
        ),
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFC21010)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: widthVar / 3.9, vertical: heightVar / 60),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CheckOut(),
                      ),
                    );
                  },
                  child: const Text(
                    'Checkout',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
