import 'package:flutter/material.dart';

class ChoosePaymentMethod extends StatefulWidget {
  const ChoosePaymentMethod({super.key});

  @override
  State<ChoosePaymentMethod> createState() => _ChoosePaymentMethodState();
}

class _ChoosePaymentMethodState extends State<ChoosePaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
