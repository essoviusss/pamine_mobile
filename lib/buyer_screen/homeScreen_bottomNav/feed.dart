// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pamine_mobile/buyer_screen/home_screen.dart';
import 'package:pamine_mobile/config/appId.dart';
import 'package:http/http.dart' as http;
import 'package:pamine_mobile/methods/firestore_methods.dart';
import 'package:pamine_mobile/model/livestream_model.dart';
import 'package:pamine_mobile/model/product_model.dart';
import 'package:pamine_mobile/widgets/chat.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
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
    if (widget.isBroadcaster) {
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

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    final user = Provider.of<GoogleProvider>(context).user;
    final size = MediaQuery.of(context).size;
    String? productName,
        productCategory,
        productPrice,
        productDescription,
        productImageUrl,
        productStatus;
    bool? isPinned;
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
                Container(
                  margin: EdgeInsets.only(top: heightVar / 15),
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
                        isPinned = !snapshot.data!.exists;
                        productName = snapshot.data?['productName'];
                        productCategory = snapshot.data?['productCategory'];
                        productPrice = snapshot.data?['productPrice'];
                        productDescription =
                            snapshot.data?['productDescription'];
                        productImageUrl = snapshot.data?['productImageUrl'];
                        productStatus = snapshot.data?['productStatus'];
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
                                            backgroundColor:
                                                productStatus == "pinned"
                                                    ? MaterialStateProperty.all<
                                                            Color>(
                                                        const Color(0xFFC21010))
                                                    : MaterialStateProperty.all<
                                                        Color>(Colors.blue),
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
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                              Widget mineButton = TextButton(
                                                child: const Text("Confirm"),
                                                onPressed: () {
                                                  if (isClicked) {
                                                    setState(() {
                                                      isClicked = false;
                                                    });

                                                    //mine the product
                                                    Navigator.of(context).pop();
                                                    FirebaseService().mineProd(
                                                      data: {
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
                                                      reference:
                                                          FirebaseService()
                                                              .mine,
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
                                                                Text(
                                                                  snapshot.data?[
                                                                      'productName'],
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Text(
                                                                    snapshot.data?[
                                                                        'productPrice'],
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
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
                                              : const Text(
                                                  'CONFIRM',
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
                                  //cart button
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
                                                                            Text(post.productPrice!,
                                                                                style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
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
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        int count = snapshot.data!.docs.length;

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
