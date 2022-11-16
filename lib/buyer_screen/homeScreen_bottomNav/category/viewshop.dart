import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/viewshoptabs/shopproducts.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/viewshoptabs/shopsoldproducts.dart';

class ViewShop extends StatefulWidget {
  final String? businessName;
  final String? logoUrl;
  final String? sellerUid;
  const ViewShop({
    super.key,
    required this.businessName,
    required this.logoUrl,
    required this.sellerUid,
  });

  @override
  State<ViewShop> createState() => _ViewShopState();
}

class _ViewShopState extends State<ViewShop> {
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC21010),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(widget.businessName!),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("seller_info")
            .doc(widget.sellerUid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("waiting...");
          }
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: widthVar / 25, top: heightVar / 60),
                        alignment: Alignment.centerLeft,
                        height: 115,
                        width: 115,
                        child: Stack(
                          fit: StackFit.expand,
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(widget.logoUrl!),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: widthVar / 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: heightVar / 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text(
                              "Owner: ${snapshot.data?['businessOwnerName']}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${snapshot.data?['phoneNumber']}",
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: heightVar / 60,
                  ),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const TabBar(
                          indicatorColor: Color(0xFFC21010),
                          labelColor: Color(0xFFC21010),
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            Tab(text: 'Products'),
                            Tab(text: 'Sold Products'),
                          ],
                        ),
                        Container(
                          height: heightVar / 1.5, //height of TabBarView
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.grey, width: 0.5))),
                          child: TabBarView(
                            children: <Widget>[
                              ShopProducts(
                                sellerUid: widget.sellerUid!,
                              ),
                              const ShopSoldProducts(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
