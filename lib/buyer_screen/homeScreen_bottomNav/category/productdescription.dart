import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/cart.dart';

class ProductDescription extends StatefulWidget {
  final String productImageUrl;
  final String productName;
  final String productPrice;
  final String productQuantity;
  final String productDescription;
  final String productCategory;
  final String sellerUid;
  const ProductDescription({
    super.key,
    required this.productImageUrl,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productDescription,
    required this.productCategory,
    required this.sellerUid,
  });

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool heart = false;
  bool isClicked = false;
  bool isAddedToCart = true;

  CollectionReference cart = FirebaseFirestore.instance
      .collection("buyer_info")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("cart");

  addToCart() async {
    cart.doc().set({
      "productName": widget.productName,
      "productPrice": widget.productPrice,
      "productImageUrl": widget.productImageUrl,
    }).then((value) {
      Fluttertoast.showToast(msg: "Product Added to Cart");
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: const Color(0xFFC21010),
        title: const Text("Description"),
        actions: [
          //There is a null check error here, will fix later
          Container(
            margin: EdgeInsets.only(right: widthVar / 40),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Cart(),
                  ),
                );
              },
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("buyer_info")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("cart")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  int count = snapshot.data!.docs.length;

                  return Badge(
                    badgeColor: const Color.fromARGB(255, 158, 158, 158),
                    position: BadgePosition.topEnd(top: 0, end: -3),
                    animationDuration: const Duration(seconds: 1),
                    badgeContent: Text('$count'),
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 35,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: heightVar / 50,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: widthVar / 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: const Color.fromARGB(255, 202, 202, 202),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.productImageUrl,
                  height: heightVar / 2.5,
                  width: widthVar / 1.1,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            Container(
              margin:
                  EdgeInsets.only(left: widthVar / 25, right: widthVar / 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("seller_info")
                        .doc(widget.sellerUid)
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.none) {
                        Fluttertoast.showToast(msg: "waiting...");
                      } else {
                        return Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 70,
                              width: 70,
                              child: Stack(
                                fit: StackFit.expand,
                                clipBehavior: Clip.none,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(snapshot.data?['logoUrl']),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: widthVar / 50,
                            ),
                            Column(
                              children: [
                                Text(
                                  snapshot.data?['businessName'],
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.pin_drop_outlined,
                                      size: 20,
                                    ),
                                    Text(
                                      snapshot.data?['address'],
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                  SizedBox(
                    width: widthVar / 10,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(
                            horizontal: widthVar / 20,
                            vertical: heightVar / 60),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "View Shop",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            Container(
              margin:
                  EdgeInsets.only(left: widthVar / 25, right: widthVar / 25),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Product Name: ${widget.productName}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: heightVar / 150,
                  ),
                  Text(
                    "Product Price: ₱${widget.productPrice}.00",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: heightVar / 100,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: widthVar / 1.9,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (isClicked == false) {
                      setState(() {
                        heart = true;
                        isClicked = true;
                      });
                    } else {
                      setState(() {
                        heart = false;
                        isClicked = false;
                      });
                    }
                  },
                  icon: heart == false
                      ? const Icon(
                          Icons.favorite_border_sharp,
                          color: Colors.red,
                          size: 50,
                        )
                      : const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 50,
                        ),
                ),
                Text(
                  "Only ${widget.productQuantity} item/s left",
                  style: const TextStyle(
                      color: Colors.red, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            SizedBox(
              height: heightVar / 100,
            ),
            Container(
              margin:
                  EdgeInsets.only(left: widthVar / 25, right: widthVar / 25),
              alignment: Alignment.centerLeft,
              child: Text(
                "Description: \n\t\t\t\t - ${widget.productDescription}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(
              height: heightVar / 50,
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Wrap(
          children: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(
                      horizontal: widthVar / 7, vertical: heightVar / 60),
                ),
              ),
              onPressed: () {
                if (isAddedToCart) {
                  setState(() {
                    isAddedToCart = false;
                    addToCart();
                  });
                }
              },
              child: const Text(
                'Add to Cart',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
