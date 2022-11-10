import 'package:flutter/material.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/checkout_cart_components/checkout_in_live.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/checkout_cart_components/checkout_off_live.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

bool? option1 = false;
bool? option2 = false;

class _CheckOutState extends State<CheckOut> {
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC21010),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text("Checkout"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: heightVar / 60, left: widthVar / 25, right: widthVar / 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cart to Checkout",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: heightVar / 100,
              ),
              Container(
                margin: EdgeInsets.only(top: heightVar / 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: option1 == true
                                ? const Color(0xFFC21010)
                                : Colors.grey),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Container(
                        color: option1 == true
                            ? Colors.red.withOpacity(0.1)
                            : Colors.transparent,
                        child: Row(
                          children: [
                            SizedBox(
                              width: widthVar / 25,
                            ),
                            RoundCheckBox(
                              isChecked: option1,
                              size: 30,
                              checkedColor: const Color(0xFFC21010),
                              onTap: (selected) =>
                                  setState((() => option1 = selected)),
                            ),
                            SizedBox(
                              width: widthVar / 15,
                            ),
                            const CheckoutInLive(),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: const Icon(
                                  Icons.more_vert,
                                  color: Color(0xFFC21010),
                                  size: 35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: heightVar / 60,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: option2 == true
                                ? const Color(0xFFC21010)
                                : Colors.grey),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Container(
                        color: option2 == true
                            ? Colors.red.withOpacity(0.1)
                            : Colors.transparent,
                        child: Row(
                          children: [
                            SizedBox(
                              width: widthVar / 25,
                            ),
                            RoundCheckBox(
                              isChecked: option2,
                              size: 30,
                              checkedColor: const Color(0xFFC21010),
                              onTap: (selected) =>
                                  setState((() => option2 = selected)),
                            ),
                            SizedBox(
                              width: widthVar / 15,
                            ),
                            const CheckoutOffLive(),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: const Icon(
                                  Icons.more_vert,
                                  color: Color(0xFFC21010),
                                  size: 35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: heightVar / 60,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: heightVar / 60,
              ),
              const Text("Shipping Address",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                height: heightVar / 100,
              ),
              Container(
                width: double.infinity,
                height: heightVar / 8,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: heightVar / 60,
              ),
              const Text("Payment Methods",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                height: heightVar / 100,
              ),
              Container(
                width: double.infinity,
                height: heightVar / 6,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: heightVar / 50,
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Column(
          children: [
            SizedBox(
              height: heightVar / 50,
            ),
            Container(
              margin: EdgeInsets.only(right: widthVar / 25),
              alignment: Alignment.centerRight,
              child: const Text(
                "Total Price: ₱0.00",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            SizedBox(
              height: heightVar / 50,
            ),
            Row(
              children: [
                option1 == true || option2 == true
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFFC21010)),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    horizontal: widthVar / 3.9,
                                    vertical: heightVar / 60),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Place Order',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.grey),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    horizontal: widthVar / 3.9,
                                    vertical: heightVar / 60),
                              ),
                            ),
                            onPressed: null,
                            child: const Text(
                              'Place Order',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
