// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import 'category/categories.dart';
import 'category/marketplace.dart';

class categoryPage extends StatefulWidget {
  const categoryPage({Key? key}) : super(key: key);
  static String id = "Videos";

  @override
  State<categoryPage> createState() => _categoryPageState();
}

class _categoryPageState extends State<categoryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFC21010),
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text("Discover"),
          ),
          bottom: const TabBar(
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            )),
            tabs: [
              Tab(
                child: Text("Search"),
              ),
              Tab(
                child: Text("Marketplace"),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Categories(),
            Marketplace(
              productCategory: '',
              productDescription: '',
              productImageUrl: '',
              productName: '',
              productPrice: '',
              productQuantity: '',
              sellerUid: '',
            ),
          ],
        ),
      ),
    );
  }
}
