import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_button/counter_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/cart.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/cart_button/cart_button.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/viewshop.dart';
import 'package:pamine_mobile/model/cart_model.dart';

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
  int qtyValue = 1;
  bool isExceeded = true;
  String? businessName;
  String? logoUrl;
  String? sellerUid;
  int? subtotal;

  addToCart() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    CartModel cartModel = CartModel();

    cartModel.productImageUrl = widget.productImageUrl;
    cartModel.productName = widget.productName;
    cartModel.productPrice = int.parse(widget.productPrice);
    cartModel.productQuantity = qtyValue;
    cartModel.subtotal = subtotal;
    cartModel.sellerUid = widget.sellerUid;

    await firebaseFirestore
        .collection("buyer_info")
        .doc(user?.uid)
        .collection("cart")
        .doc()
        .set(cartModel.toMap())
        .then(
            (value) => {Fluttertoast.showToast(msg: "Product added to cart")});
  }

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    subtotal = qtyValue * int.parse(widget.productPrice);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: const Color(0xFFC21010),
        title: const Text("Description"),
        actions: const [
          CartButton(),
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
                      businessName = snapshot.data?['businessName'];
                      logoUrl = snapshot.data?['logoUrl'];
                      sellerUid = snapshot.data?['uid'];
                      if (snapshot.connectionState == ConnectionState.none) {
                        Fluttertoast.showToast(msg: "waiting...");
                      } else {
                        return Expanded(
                          child: Row(
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
                                      backgroundImage: NetworkImage(
                                          snapshot.data?['logoUrl']),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: widthVar / 50,
                              ),
                              Column(
                                children: [
                                  snapshot.data?['dtiRegistered'] == "Yes"
                                      ? Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          spacing: widthVar / 50,
                                          children: [
                                            const Icon(
                                              Icons.verified,
                                              color: Color(0xFFC21010),
                                            ),
                                            Text(
                                              snapshot.data?['businessName'],
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          snapshot.data?['businessName'],
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
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
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFC21010)),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(
                            horizontal: widthVar / 20,
                            vertical: heightVar / 60),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ViewShop(
                            businessName: businessName,
                            logoUrl: logoUrl,
                            sellerUid: sellerUid,
                          ),
                        ),
                      );
                    },
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
            Container(
              margin:
                  EdgeInsets.only(left: widthVar / 25, right: widthVar / 25),
              alignment: Alignment.centerLeft,
              child: Row(
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
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Only ${widget.productQuantity} item/s left",
                        style: const TextStyle(
                            color: Colors.red, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
              ),
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
                textAlign: TextAlign.justify,
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
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("seller_info")
                    .doc(widget.sellerUid)
                    .collection("products")
                    .doc()
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.none) {
                    print("Waiting...");
                  } else {
                    return CounterButton(
                      loading: false,
                      onChange: (int val) {
                        if (val > int.parse(widget.productQuantity)) {
                          setState(() {
                            Fluttertoast.showToast(
                                msg: "Total Quantity Exceeded");
                          });
                        }

                        setState(() {
                          qtyValue = val;
                        });
                      },
                      count: qtyValue,
                      countColor: const Color(0xFFC21010),
                      buttonColor: const Color(0xFFC21010),
                      progressColor: const Color(0xFFC21010),
                    );
                  }
                  return Container();
                },
              ),
            ),
            SizedBox(
              width: widthVar / 30,
            ),
            Expanded(
              child:
                  qtyValue > int.parse(widget.productQuantity) || qtyValue < 1
                      ? TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.grey),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: widthVar / 8,
                                  vertical: heightVar / 50),
                            ),
                          ),
                          onPressed: null,
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFC21010)),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: widthVar / 8,
                                  vertical: heightVar / 50),
                            ),
                          ),
                          onPressed: () {
                            if (isAddedToCart) {
                              setState(() {
                                isAddedToCart = false;
                                addToCart();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Cart(
                                          sellerUid: widget.sellerUid,
                                        )));
                              });
                            }
                          },
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
            ),
          ],
        ),
      ],
    );
  }
}
