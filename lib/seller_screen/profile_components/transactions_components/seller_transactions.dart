import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SellerTransactions extends StatefulWidget {
  const SellerTransactions({super.key});

  @override
  State<SellerTransactions> createState() => _SellerTransactionsState();
}

class _SellerTransactionsState extends State<SellerTransactions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text("Transactions"),
        backgroundColor: Colors.red,
      ),
      body: Container(),
    );
  }
}
