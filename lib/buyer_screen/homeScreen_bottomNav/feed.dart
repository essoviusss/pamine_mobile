// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings, unused_import

import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:animated_icon/animate_icon.dart';
import 'package:animated_icon/animate_icons.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pamine_mobile/buyer_screen/home_screen.dart';
import 'package:pamine_mobile/config/appId.dart';
import 'package:http/http.dart' as http;
import 'package:pamine_mobile/methods/firestore_methods.dart';
import 'package:pamine_mobile/model/livestream_model.dart';
import 'package:pamine_mobile/model/product_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';
import '../../widgets/custom_textfield.dart';
import 'mineProd/mineProd.dart';

class Feed extends StatefulWidget {
  final String channelId;
  final bool isBroadcaster;
  const Feed({
    Key? key,
    required this.isBroadcaster,
    required this.channelId,
  }) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  bool isClicked = true;
  late final RtcEngine _engine;
  List<int> remoteUid = [];

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  void _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    _addListeners();

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadcaster == true) {
      _engine.setClientRole(ClientRole.Broadcaster);
    } else {
      _engine.setClientRole(ClientRole.Audience);
    }
    _joinChannel();
  }

  String baseUrl = "https://pamine-token.herokuapp.com";
  String? token;

  Future<void> getToken() async {
    final res = await http.get(
      Uri.parse(baseUrl +
          '/rtc/' +
          widget.channelId +
          '/publisher/userAccount/' +
          FirebaseAuth.instance.currentUser!.uid +
          '/'),
    );
    if (res.statusCode == 200) {
      setState(() {
        token = res.body;
        token = jsonDecode(token!)['rtcToken'];
      });
    } else {
      debugPrint('Failed to fetch the token');
    }
  }

  void _joinChannel() async {
    await getToken();
    if (defaultTargetPlatform == TargetPlatform.android &&
        widget.isBroadcaster == true) {
      await [Permission.microphone, Permission.camera].request();
    }
    await _engine.joinChannelWithUserAccount(
      token,
      widget.channelId,
      FirebaseAuth.instance.currentUser!.uid,
    );
  }

  void _addListeners() {
    _engine.setEventHandler(
        RtcEngineEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
      debugPrint('joinChannelSuccess $channel $uid $elapsed');
    }, userJoined: (uid, elapsed) {
      debugPrint('userJoined $uid $elapsed');
      setState(() {
        remoteUid.add(uid);
      });
    }, userOffline: (uid, reason) {
      debugPrint('userOffline $uid $reason');
      setState(() {
        remoteUid.removeWhere((element) => element == uid);
      });
    }, leaveChannel: (stats) {
      debugPrint('leaveChannel $stats');
      setState(() {
        remoteUid.clear();
      });
    }, tokenPrivilegeWillExpire: (token) async {
      await getToken();
      await _engine.renewToken(token);
    }));
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    if (FirebaseAuth.instance.currentUser!.uid == widget.channelId) {
      await FirestoreMethods().endLiveStream(widget.channelId);
    } else {
      await FirestoreMethods().updateViewCount(widget.channelId, false);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const home_screen(),
        ));
  }

  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _needsScroll = false;

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  final ScrollController _myController = ScrollController();

  updateStatus() async {
    CollectionReference update =
        FirebaseFirestore.instance.collection("livestream");

    await update
        .doc(widget.channelId)
        .collection("pinned_item")
        .doc("pinnedItem")
        .update({
      "productStatus": FirebaseAuth.instance.currentUser!.uid,
    });
  }

  updataStatusCancelled() async {
    CollectionReference update =
        FirebaseFirestore.instance.collection("livestream");

    await update
        .doc(widget.channelId)
        .collection("pinned_item")
        .doc("pinnedItem")
        .update({
      "productStatus": "pinned",
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    final user = Provider.of<GoogleProvider>(context).user;
    final size = MediaQuery.of(context).size;
    String? productId,
        productName,
        productCategory,
        productDescription,
        productImageUrl,
        productStatus;
    int? productPrice, commission, productOrigPrice;
    return WillPopScope(
      onWillPop: () async {
        await _leaveChannel();
        return Future.value(true);
      },
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: heightVar / 1,
              child: _renderVideo(user),
            ),
            StreamBuilder<dynamic>(
              stream: FirebaseFirestore.instance
                  .collection('livestream')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      LiveStream post =
                          LiveStream.fromMap(snapshot.data?.docs[index].data());
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25))),
                        margin: EdgeInsets.only(
                            left: widthVar / 3.5,
                            right: widthVar / 3.5,
                            top: heightVar / 180),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            Text(
                              '${post.viewers} watching',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
            Wrap(
              spacing: widthVar / 8,
              children: [
                Container(
                  margin: EdgeInsets.only(top: heightVar / 12),
                  padding: EdgeInsets.only(left: widthVar / 40),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("livestream")
                          .doc(widget.channelId)
                          .collection("pinned_item")
                          .doc("pinnedItem")
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          return const CircularProgressIndicator();
                        }
                        if (!snapshot.data!.exists) {
                          return SizedBox(
                            width: widthVar / 1.5,
                            child: const Text(""),
                          );
                        }
                        productId = snapshot.data?['productId'];
                        productName = snapshot.data?['productName'];
                        productCategory = snapshot.data?['productCategory'];
                        productPrice = snapshot.data?['productPrice'];
                        commission = snapshot.data?['commission'];
                        productOrigPrice = snapshot.data?['productOrigPrice'];
                        productImageUrl = snapshot.data?['productImageUrl'];
                        productStatus = snapshot.data?['productStatus'];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment(0.8, 1),
                              colors: <Color>[
                                Color(0xffca485c),
                                Color(0xffe16b5c),
                                Color(0xfff39060),
                                Color(0xffffb56b),
                              ], // Gradient from https://learnui.design/tools/gradient-generator.html
                              tileMode: TileMode.mirror,
                            ),
                          ),
                          height: heightVar / 18,
                          child: Container(
                            alignment: Alignment.center,
                            width: widthVar / 1.5,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: widthVar / 60,
                                  ),
                                  CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 4, 4),
                                    child: AnimateIcon(
                                      key: UniqueKey(),
                                      onTap: () {},
                                      iconType: IconType.continueAnimation,
                                      height: 30,
                                      width: 30,
                                      color: Colors.white,
                                      animateIcon: AnimateIcons.bell,
                                    ),
                                  ),
                                  SizedBox(
                                    width: widthVar / 50,
                                  ),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 20,
                                    children: [
                                      Text(
                                        "Product: ${snapshot.data?['productName']}",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Price: ₱${snapshot.data?['productPrice']}",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  margin: EdgeInsets.only(top: heightVar / 20),
                  padding: EdgeInsets.only(right: widthVar / 40),
                  child: IconButton(
                    onPressed: () {
                      _leaveChannel();
                    },
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
            //comments
            Row(
              children: [
                Stack(
                  children: [
                    BottomAppBar(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Container(
                        width: widthVar / 1,
                        margin: EdgeInsets.only(top: heightVar / 2.2),
                        color: Colors.transparent,
                        height: heightVar / 2,
                        child: SizedBox(
                          width: size.width > 600
                              ? size.width * 0.25
                              : double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: StreamBuilder<dynamic>(
                                  stream: FirebaseFirestore.instance
                                      .collection('livestream')
                                      .doc(widget.channelId)
                                      .collection('comments')
                                      .orderBy('createdAt', descending: false)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.none) {
                                      return const CircularProgressIndicator();
                                    }
                                    Timer(
                                        const Duration(milliseconds: 500),
                                        () => _myController.jumpTo(_myController
                                            .position.maxScrollExtent));
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        controller: _myController,
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              height: heightVar / 15,
                                              margin: EdgeInsets.only(
                                                  top: 5, right: widthVar / 2),
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                border: Border.all(
                                                    color: Colors.transparent,
                                                    width: 3.0),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(25)),
                                              ),
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: widthVar / 30,
                                                    right: widthVar / 30),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data.docs[index]
                                                          ['username'],
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: snapshot.data.docs[
                                                                        index]
                                                                    ['uid'] ==
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid
                                                            ? Colors.black
                                                            : Colors.red,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data.docs[index]
                                                          ['message'],
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        });
                                  },
                                ),
                              ),
                              const SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                ),
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  CustomTextField(
                                    controller: _chatController,
                                    onTap: (val) {
                                      FirestoreMethods().chat(
                                        _chatController.text,
                                        widget.channelId,
                                        context,
                                      );
                                      setState(() {
                                        _chatController.text = "";
                                      });
                                    },
                                  ),
                                  //mine button
                                  StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("livestream")
                                        .doc(widget.channelId)
                                        .collection("pinned_item")
                                        .doc("pinnedItem")
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      bool isPinned = snapshot.data!.exists;
                                      if (isPinned) {
                                        return TextButton(
                                          style: ButtonStyle(
                                            backgroundColor: productStatus ==
                                                    "pinned"
                                                ? MaterialStateProperty.all<
                                                        Color>(
                                                    const Color(0xFFC21010))
                                                : productStatus ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                    ? MaterialStateProperty.all<
                                                        Color>(Colors.blue)
                                                    : MaterialStateProperty.all<
                                                        Color>(Colors.grey),
                                            padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                              EdgeInsets.symmetric(
                                                  horizontal: widthVar / 12,
                                                  vertical: 15),
                                            ),
                                          ),
                                          onPressed: () async {
                                            //1st click update status to buyer UID
                                            if (snapshot
                                                    .data?['productStatus'] ==
                                                "pinned") {
                                              await updateStatus();
                                            }
                                            //2nd click confirmation
                                            else if (snapshot
                                                    .data?["productStatus"] ==
                                                FirebaseAuth.instance
                                                    .currentUser!.uid) {
                                              Widget cancelButton = TextButton(
                                                child: const Text("Cancel"),
                                                onPressed: () {
                                                  updataStatusCancelled();
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                              Widget mineButton = TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.blue),
                                                  padding: MaterialStateProperty
                                                      .all<EdgeInsets>(
                                                    EdgeInsets.symmetric(
                                                        horizontal:
                                                            widthVar / 12,
                                                        vertical: 15),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Confirm",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  if (isClicked) {
                                                    setState(() {
                                                      isClicked = false;
                                                    });

                                                    //mine the product
                                                    //buyer's list
                                                    Navigator.of(context).pop();
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "buyer_info")
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .collection(
                                                            "mined_products")
                                                        .doc(widget.channelId)
                                                        .collection(
                                                            "minedProducts")
                                                        .doc(productId)
                                                        .set({
                                                      "productId": productId,
                                                      "productName":
                                                          productName,
                                                      "productCategory":
                                                          productCategory,
                                                      "productPrice":
                                                          productPrice,
                                                      "commission": commission,
                                                      "productOrigPrice":
                                                          productOrigPrice,
                                                      "productImageUrl":
                                                          productImageUrl,
                                                      "productStatus": "mined",
                                                      "sellerUid":
                                                          widget.channelId,
                                                    });
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "buyer_info")
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .collection(
                                                            "mined_products")
                                                        .doc(widget.channelId)
                                                        .set({
                                                      "sellerUid":
                                                          widget.channelId
                                                    });
                                                    //gen mine product list
                                                    FirebaseService()
                                                        .mineProdList(
                                                      data: {
                                                        "buyerName":
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .displayName,
                                                        "productName":
                                                            productName,
                                                        "productCategory":
                                                            productCategory,
                                                        "productPrice":
                                                            productPrice,
                                                        "productDescription":
                                                            productDescription,
                                                        "productImageUrl":
                                                            productImageUrl,
                                                        "productStatus":
                                                            "mined",
                                                      },
                                                      reference: FirebaseService()
                                                          .list
                                                          .doc(widget.channelId)
                                                          .collection(
                                                              "mined_products_list"),
                                                    );

                                                    //live list only
                                                    FirebaseService()
                                                        .newmineProdList(
                                                      data: {
                                                        "buyerName":
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .displayName,
                                                        "productName":
                                                            productName,
                                                        "productCategory":
                                                            productCategory,
                                                        "productPrice":
                                                            productPrice,
                                                        "productDescription":
                                                            productDescription,
                                                        "productImageUrl":
                                                            productImageUrl,
                                                        "productStatus":
                                                            "mined",
                                                      },
                                                      reference: FirebaseService()
                                                          .newList
                                                          .doc(widget.channelId)
                                                          .collection(
                                                              "new_mined_products_list"),
                                                    );

                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "livestream")
                                                        .doc(widget.channelId)
                                                        .collection(
                                                            "pinned_item")
                                                        .doc("pinnedItem")
                                                        .delete();
                                                  }
                                                  Timer(
                                                      const Duration(
                                                          seconds: 2), () {
                                                    setState(() {
                                                      isClicked = true;
                                                    });
                                                  });
                                                },
                                              );

                                              // set up the AlertDialog
                                              AlertDialog alert = AlertDialog(
                                                title: const Text(
                                                    "Would you like to Mine the product?"),
                                                content: Card(
                                                  child: Container(
                                                    height: heightVar / 2.8,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 3.0,
                                                          color: Colors
                                                              .grey.shade300),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  5.0)),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Column(
                                                              children: [
                                                                AspectRatio(
                                                                  aspectRatio:
                                                                      1 / 1,
                                                                  child: Image.network(
                                                                      snapshot.data?[
                                                                          'productImageUrl']),
                                                                ),
                                                                SizedBox(
                                                                  child: Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: heightVar /
                                                                              99)),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets.only(
                                                                      left: widthVar /
                                                                          25),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    snapshot.data?[
                                                                        'productName'],
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets.only(
                                                                      left: widthVar /
                                                                          25),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      "Price: ₱$productPrice.00",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  cancelButton,
                                                  mineButton,
                                                ],
                                              );

                                              // show the dialog
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return alert;
                                                },
                                              );
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Product is already mined!");
                                            }
                                          },
                                          child: productStatus == "pinned"
                                              ? const Text(
                                                  'MINE',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              : productStatus ==
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                  ? const Text(
                                                      'CONFIRM',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )
                                                  : const Text(
                                                      'MINE',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                        );
                                      } else {
                                        return TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.grey),
                                            padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                              EdgeInsets.symmetric(
                                                  horizontal: widthVar / 12,
                                                  vertical: 15),
                                            ),
                                          ),
                                          onPressed: null,
                                          child: const Text(
                                            'MINE',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  //mined items
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: heightVar / 2,
                                            color: Colors.white,
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: heightVar / 60),
                                                    ),
                                                  ),
                                                  const Text(
                                                    'Mined Items',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: heightVar / 60),
                                                    ),
                                                  ),
                                                  StreamBuilder<dynamic>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'buyer_info')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .collection(
                                                            "mined_products")
                                                        .doc(widget.channelId)
                                                        .collection(
                                                            "minedProducts")
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const CircularProgressIndicator();
                                                      }
                                                      return Expanded(
                                                        child: GridView.builder(
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                            childAspectRatio:
                                                                ((widthVar /
                                                                        2.2) /
                                                                    (heightVar /
                                                                        3.8)),
                                                            crossAxisCount: 2,
                                                            mainAxisSpacing: 5,
                                                            crossAxisSpacing: 5,
                                                          ),
                                                          shrinkWrap: true,
                                                          itemCount: snapshot
                                                              .data.docs.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            Products post =
                                                                Products.fromMap(
                                                                    snapshot
                                                                        .data
                                                                        .docs[
                                                                            index]
                                                                        .data());
                                                            return Card(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      width:
                                                                          3.0,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300),
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          5.0)),
                                                                ),
                                                                child: Stack(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            AspectRatio(
                                                                              aspectRatio: 1 / 1,
                                                                              child: Image.network(post.productImageUrl!),
                                                                            ),
                                                                            SizedBox(
                                                                              child: Padding(padding: EdgeInsets.only(top: heightVar / 99)),
                                                                            ),
                                                                            Container(
                                                                              margin: EdgeInsets.only(left: widthVar / 25),
                                                                              child: Text(
                                                                                post.productName!,
                                                                                style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              margin: EdgeInsets.only(left: widthVar / 25),
                                                                              child: Text("₱${post.productPrice!}.00", style: const TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("buyer_info")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection("mined_products")
                                          .doc(widget.channelId)
                                          .collection("minedProducts")
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        int? count = snapshot.data?.docs.length;
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          print("waiting...");
                                        }
                                        if (snapshot.hasData) {
                                          return Badge(
                                            animationDuration:
                                                const Duration(seconds: 1),
                                            badgeContent: Text('$count'),
                                            child: const Icon(
                                              Icons.shopping_bag,
                                              color: Colors.white,
                                              size: 55,
                                            ),
                                          );
                                        }
                                        return Container();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _renderVideo(user) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: FirebaseAuth.instance.currentUser!.uid == widget.channelId
          ? const RtcLocalView.SurfaceView(
              zOrderMediaOverlay: true,
              zOrderOnTop: true,
            )
          : remoteUid.isNotEmpty
              ? kIsWeb
                  ? RtcRemoteView.SurfaceView(
                      uid: remoteUid[0],
                      channelId: widget.channelId,
                    )
                  : RtcRemoteView.TextureView(
                      uid: remoteUid[0],
                      channelId: widget.channelId,
                    )
              : Container(),
    );
  }
}
