// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/product_management/add_products.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/product_management/product_list.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text("Product Management"),
          ),
          bottom: const TabBar(
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            )),
            tabs: [
              Tab(
                child: Text("Add Products"),
              ),
              Tab(
                child: Text("Product List"),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AddProducts(),
            ProductList(),
          ],
        ),
      ),
    );
  }
}
