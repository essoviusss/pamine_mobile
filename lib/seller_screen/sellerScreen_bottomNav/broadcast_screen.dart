// ignore_for_file: use_build_context_synchronously, must_be_immutable, prefer_interpolation_to_compose_strings, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pamine_mobile/config/appId.dart';
import 'package:pamine_mobile/model/livestream_model.dart';
import 'package:pamine_mobile/seller_screen/seller_home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:http/http.dart' as http;

import '../../methods/firestore_methods.dart';
import '../../model/product_model.dart';
import '../../provider/user_provider.dart';
import '../../widgets/custom_textfield.dart';

class BroadcastScreen extends StatefulWidget {
  bool? isBroadcaster = true;
  final String channelId;
  BroadcastScreen({
    Key? key,
    required this.isBroadcaster,
    required this.channelId,
  }) : super(key: key);

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  late final RtcEngine _engine;
  List<int> remoteUid = [];
  bool switchCamera = true;
  bool isMuted = false;
  bool isScreenSharing = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _initEngine();
    });
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

  String baseUrl = "https://pamine-server.herokuapp.com";
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
    if (token != null) {
      if (defaultTargetPlatform == TargetPlatform.android &&
          widget.isBroadcaster == true) {
        await [Permission.microphone, Permission.camera].request();
      }
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

  void _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((err) {
      debugPrint('switchCamera $err');
    });
  }

  void onToggleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    await _engine.muteLocalAudioStream(isMuted);
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    if (FirebaseAuth.instance.currentUser!.uid == widget.channelId) {
      await FirestoreMethods().endLiveStream(widget.channelId);
      await FirestoreMethods().endLiveStream1(widget.channelId);
    } else {
      await FirestoreMethods().updateViewCount(widget.channelId, false);
    }
    Navigator.pushReplacementNamed(context, seller_home.id);
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

  Future<void> deleteNewList() async {
    CollectionReference newList =
        FirebaseFirestore.instance.collection("livestream");

    final list = newList
        .doc(widget.channelId)
        .collection("new_mined_products_list")
        .get();
    await list.then((value) => value.docs.forEach((element) {
          element.reference.delete();
        }));
  }

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    final user = Provider.of<GoogleProvider>(context).user;
    final size = MediaQuery.of(context).size;

    //rowheader
    Widget rowHeader({int? flex, String? text}) {
      return Expanded(
        flex: flex!,
        child: Container(
          margin: EdgeInsets.only(top: heightVar / 40),
          height: heightVar / 20,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            color: Colors.red,
          ),
          child: Center(
            child: Text(
              text!,
              style: const TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 15),
            ),
          ),
        ),
      );
    }

    //row content
    Widget rowContent({int? flex, String? text, Widget? widget}) {
      return Expanded(
        flex: flex!,
        child: Container(
          height: heightVar / 13,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: widthVar / 50, vertical: heightVar / 40),
            child: Center(
              child: widget ??
                  Text(
                    text!,
                    textScaleFactor: 1,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
            ),
          ),
        ),
      );
    }

    //To do...
    //create a list that can be renewed every livestream
    //create a list of all buyers who mined products outside the livestream

    //build
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
                  return Expanded(
                    child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          LiveStream post = LiveStream.fromMap(
                              snapshot.data?.docs[index].data());
                          return Center(
                            child: Text(
                              '${post.viewers} watching',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }),
                  );
                }),
            Wrap(
              spacing: widthVar / 8,
              children: [
                //pinned product
                Container(
                  margin: EdgeInsets.only(top: heightVar / 15),
                  padding: EdgeInsets.only(left: widthVar / 40),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("livestream")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
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
                        return Container(
                          height: heightVar / 30,
                          color: Colors.purple.withOpacity(0.6),
                          child: Container(
                            alignment: Alignment.center,
                            width: widthVar / 1.5,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Wrap(
                                    spacing: 20,
                                    children: [
                                      Text(
                                        "Product: ${snapshot.data?['productName']}",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      Text(
                                        "Price: ₱${snapshot.data?['productPrice']}",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      Text(
                                        "Category: ${snapshot.data?['productCategory']}",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic),
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
                //leave and list button
                Column(
                  children: [
                    //leave button
                    Container(
                      margin: EdgeInsets.only(top: heightVar / 20),
                      padding: EdgeInsets.only(right: widthVar / 40),
                      child: IconButton(
                        onPressed: () {
                          deleteNewList();
                          _leaveChannel();
                        },
                        icon: const Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding: EdgeInsets.only(top: heightVar / 3),
                      ),
                    ),
                    //view list button
                    InkWell(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: heightVar / 1,
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
                                      "Buyer's List",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: heightVar / 60),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        rowHeader(flex: 2, text: "Buyer Name"),
                                        rowHeader(
                                            flex: 2, text: "Product Name"),
                                        rowHeader(flex: 1, text: "Price")
                                      ],
                                    ),
                                    StreamBuilder<dynamic>(
                                      stream: FirebaseFirestore.instance
                                          .collection('livestream')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection("new_mined_products_list")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        }
                                        return Expanded(
                                          child: ListView.builder(
                                              itemCount:
                                                  snapshot.data.docs.length,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    rowContent(
                                                      flex: 2,
                                                      text: snapshot
                                                              .data!.docs[index]
                                                          ['buyerName'],
                                                    ),
                                                    rowContent(
                                                      flex: 2,
                                                      text: snapshot
                                                              .data!.docs[index]
                                                          ['productName'],
                                                    ),
                                                    rowContent(
                                                      flex: 1,
                                                      text:
                                                          "₱${snapshot.data!.docs[index]['productPrice']}",
                                                    ),
                                                  ],
                                                );
                                              }),
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
                            .collection("livestream")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("new_mined_products_list")
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          int count = snapshot.data!.docs.length;

                          return Badge(
                            badgeColor: Colors.blue,
                            animationDuration: const Duration(seconds: 1),
                            badgeContent: Text('$count'),
                            child: const Icon(
                              Icons.shopping_bag,
                              color: Colors.white,
                              size: 55,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Stack(
                  children: [
                    //comments and buttons
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
                                      controller: _myController,
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: (context, index) =>
                                          Container(
                                        margin: EdgeInsets.only(
                                            top: 8, right: widthVar / 2),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            border: Border.all(
                                                color: Colors.transparent,
                                                width: 3.0),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10.0)),
                                            boxShadow: const [
                                              BoxShadow(
                                                  blurRadius: 10,
                                                  color: Colors.transparent,
                                                  offset: Offset(1, 3))
                                            ]),
                                        child: ListTile(
                                          dense: true,
                                          contentPadding: const EdgeInsets.only(
                                              left: 10,
                                              right: 0.0,
                                              top: 0,
                                              bottom: 10),
                                          visualDensity: const VisualDensity(
                                              horizontal: 0, vertical: -4),
                                          title: Text(
                                            snapshot.data.docs[index]
                                                ['username'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: snapshot.data.docs[index]
                                                          ['uid'] ==
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                  ? const Color.fromARGB(
                                                      255, 99, 9, 3)
                                                  : Colors.blue,
                                            ),
                                          ),
                                          subtitle: Text(
                                            snapshot.data.docs[index]
                                                ['message'],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    );
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
                                  if (FirebaseAuth.instance.currentUser!.uid ==
                                      widget.channelId)
                                    InkWell(
                                      onTap: _switchCamera,
                                      child: const Icon(
                                        Icons.cameraswitch,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  SizedBox(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(right: widthVar / 20),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: onToggleMute,
                                    child: Icon(
                                      isMuted ? Icons.mic_off : Icons.mic_none,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                  SizedBox(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(right: widthVar / 20),
                                    ),
                                  ),
                                  InkWell(
                                    child: const Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            color: Colors.white,
                                            height: heightVar / 2,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  SizedBox(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: heightVar / 60),
                                                    ),
                                                  ),
                                                  Stack(
                                                    children: [
                                                      const Center(
                                                        child: Text(
                                                          "Pin a product",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: IconButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          icon: const Icon(
                                                              Icons.cancel),
                                                        ),
                                                      ),
                                                    ],
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
                                                            'seller_info')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .collection("products")
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
                                                            if (post.productStatus ==
                                                                "none") {
                                                              return InkWell(
                                                                onTap: () {
                                                                  CollectionReference
                                                                      pinProd =
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "livestream");

                                                                  pinProd
                                                                      .doc(FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid)
                                                                      .collection(
                                                                          "pinned_item")
                                                                      .doc(
                                                                          "pinnedItem")
                                                                      .set(
                                                                    {
                                                                      "productName":
                                                                          post.productName,
                                                                      "productCategory":
                                                                          post.productCategory,
                                                                      "productPrice":
                                                                          post.productPrice,
                                                                      "productDescription":
                                                                          post.productDescription,
                                                                      "productImageUrl":
                                                                          post.productImageUrl,
                                                                      "productStatus":
                                                                          "pinned",
                                                                    },
                                                                  ).then(
                                                                    (value) {
                                                                      Fluttertoast
                                                                          .showToast(
                                                                              msg: "Product Pinned");
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  );
                                                                },
                                                                child: Card(
                                                                  child:
                                                                      Container(
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
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                AspectRatio(
                                                                                  aspectRatio: 1 / 1,
                                                                                  child: Image.network(post.productImageUrl!),
                                                                                ),
                                                                                SizedBox(
                                                                                  child: Padding(padding: EdgeInsets.only(top: heightVar / 99)),
                                                                                ),
                                                                                Text(
                                                                                  post.productName!,
                                                                                  style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(post.productPrice!, style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Container(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.3),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Center(
                                                                                child: IconButton(
                                                                                  splashColor: Colors.blue,
                                                                                  icon: const Icon(Icons.add),
                                                                                  iconSize: 60,
                                                                                  color: Colors.red,
                                                                                  onPressed: () {
                                                                                    CollectionReference pinProd = FirebaseFirestore.instance.collection("livestream");

                                                                                    pinProd.doc(FirebaseAuth.instance.currentUser!.uid).collection("pinned_item").doc("pinnedItem").set(
                                                                                      {
                                                                                        "productName": post.productName,
                                                                                        "productCategory": post.productCategory,
                                                                                        "productPrice": post.productPrice,
                                                                                        "productDescription": post.productDescription,
                                                                                        "productImageUrl": post.productImageUrl,
                                                                                        "productStatus": "pinned",
                                                                                      },
                                                                                    ).then(
                                                                                      (value) {
                                                                                        Fluttertoast.showToast(msg: "Product Pinned");
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              return Container();
                                                            }
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
                                  )
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
                    //end of chat
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _renderVideo(user) {
    _joinChannel();
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
