import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddPaymentMethod extends StatelessWidget {
  const AddPaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC21010),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text("Payment Methods"),
      ),
      body: Container(
        height: heightVar / 5,
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
        margin: EdgeInsets.only(
            top: heightVar / 50, left: widthVar / 25, right: widthVar / 25),
      ),
      persistentFooterButtons: [
        Column(
          children: [
            Center(
              child: IconButton(
                iconSize: 70,
                onPressed: () {},
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey,
                ),
              ),
            ),
            const Text("Add Payment Method")
          ],
        ),
      ],
    );
  }
}
