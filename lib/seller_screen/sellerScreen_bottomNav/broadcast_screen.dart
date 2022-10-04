// ignore_for_file: use_build_context_synchronously, must_be_immutable, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/config/appId.dart';
import 'package:pamine_mobile/model/livestream_model.dart';
import 'package:pamine_mobile/seller_screen/seller_home.dart';
import 'package:pamine_mobile/widgets/chat.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:http/http.dart' as http;

import '../../methods/firestore_methods.dart';
import '../../model/product_model.dart';
import '../../provider/user_provider.dart';

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
    } else {
      await FirestoreMethods().updateViewCount(widget.channelId, false);
    }
    Navigator.pushReplacementNamed(context, seller_home.id);
  }

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    final user = Provider.of<GoogleProvider>(context).user;
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
            Container(
              alignment: Alignment.topRight,
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
            Row(
              children: [
                Stack(
                  children: [
                    BottomAppBar(
                      color: Colors.transparent,
                      child: Container(
                        width: widthVar / 1.5,
                        margin: EdgeInsets.only(top: heightVar / 2.2),
                        color: Colors.transparent,
                        height: heightVar / 2,
                        child: Chat(
                          channelId: widget.channelId,
                        ),
                      ),
                    ),
                    if (FirebaseAuth.instance.currentUser!.uid ==
                        widget.channelId)
                      Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(bottom: heightVar / 27),
                        margin: EdgeInsets.only(left: widthVar / 2),
                        child: Row(
                          children: [
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
                                padding: EdgeInsets.only(right: widthVar / 20),
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
                                padding: EdgeInsets.only(right: widthVar / 20),
                              ),
                            ),
                            InkWell(
                              child: const Icon(
                                Icons.add,
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
                                                      top: heightVar / 60)),
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
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.topRight,
                                                  child: IconButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    icon: const Icon(
                                                        Icons.cancel),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: heightVar / 60)),
                                            ),
                                            StreamBuilder<dynamic>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('seller_info')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .collection("products")
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                }
                                                return Expanded(
                                                  child: GridView.builder(
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      childAspectRatio:
                                                          ((widthVar / 2.2) /
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
                                                              snapshot.data
                                                                  .docs[index]
                                                                  .data());

                                                      return Card(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                width: 3.0,
                                                                color: Colors
                                                                    .grey
                                                                    .shade300),
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
                                                                            post.productImageUrl!),
                                                                      ),
                                                                      SizedBox(
                                                                        child: Padding(
                                                                            padding:
                                                                                EdgeInsets.only(top: heightVar / 99)),
                                                                      ),
                                                                      Text(
                                                                        post.productName!,
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      Text(
                                                                          post
                                                                              .productPrice!,
                                                                          style: const TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold)),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.3),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          IconButton(
                                                                        splashColor:
                                                                            Colors.blue,
                                                                        icon: const Icon(
                                                                            Icons.add),
                                                                        iconSize:
                                                                            60,
                                                                        color: Colors
                                                                            .red,
                                                                        onPressed:
                                                                            () {},
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
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
                            )
                          ],
                        ),
                      ),
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
