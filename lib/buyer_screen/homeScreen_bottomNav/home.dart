// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/feed.dart';
import 'package:pamine_mobile/model/livestream_model.dart';

import '../../methods/firestore_methods.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../utils/fontsize.dart';

// ignore: camel_case_types
class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

// ignore: camel_case_types
class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC21010),
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text("Home Screen"),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(
            top: 10,
          ),
          child: Column(
            children: [
              const Text(
                'Live Users',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              StreamBuilder<dynamic>(
                  stream: FirebaseFirestore.instance
                      .collection('livestream')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return Expanded(
                      child: SizedBox(
                        width: widthVar / 1,
                        child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              LiveStream post = LiveStream.fromMap(
                                  snapshot.data.docs[index].data());

                              return InkWell(
                                onTap: () async {
                                  await FirestoreMethods()
                                      .updateViewCount(post.channelId, true);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Feed(
                                        isBroadcaster: false,
                                        channelId: post.channelId,
                                      ),
                                    ),
                                  );
                                },
                                child: Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      height: heightVar / 6,
                                      width: widthVar * 1.4,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: heightVar / 5,
                                            width: widthVar / 2.2,
                                            child: AspectRatio(
                                              aspectRatio: 16 / 9,
                                              child: Image.network(
                                                post.image,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: SizedBox(
                                              height: heightVar / 5,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    post.username,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Text(
                                                    post.title,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                      '${post.viewers} watching'),
                                                  Text(
                                                    'Started ${timeago.format(post.startedAt.toDate())}',
                                                  ),
                                                  Wrap(
                                                    children: post.category!
                                                        .map((e) => Chip(
                                                              label: Text(
                                                                e,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                              ),
                                                            ))
                                                        .toList(),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.more_vert,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
