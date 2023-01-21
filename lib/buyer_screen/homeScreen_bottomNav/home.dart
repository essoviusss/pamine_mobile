// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/category/cart_button/cart_button.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/feed.dart';
import 'package:pamine_mobile/buyer_screen/homeScreen_bottomNav/profile.dart';
import 'package:pamine_mobile/buyer_screen/home_screen.dart';
import 'package:pamine_mobile/model/livestream_model.dart';
import 'package:anim_search_app_bar/anim_search_app_bar.dart';
import '../../methods/firestore_methods.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../utils/fontsize.dart';

// ignore: camel_case_types
class homePage extends StatelessWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    SizeConfig().init(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFFC21010),
          )),
      body: SafeArea(
        child: Column(
          children: [
            AnimSearchAppBar(
              appBar: AppBar(
                backgroundColor: const Color(0xFFC21010),
                title: Container(
                  margin: EdgeInsets.only(left: widthVar / 25),
                  child: Text(
                      "Hi, ${FirebaseAuth.instance.currentUser!.displayName}!"),
                ),
                leading: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const profilePage())),
                  child: Container(
                    margin: EdgeInsets.only(
                      left: widthVar / 45,
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        FirebaseAuth.instance.currentUser!.photoURL!,
                      ),
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.only(left: widthVar / 25),
                    child: const CartButton(),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFFC21010),
              cancelButtonText: "Cancel",
              hintText: 'Search',
              iconColor: const Color(0xFFC21010),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                top: heightVar / 60,
                left: widthVar / 25,
              ),
              child: const Text(
                'Live Users',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            StreamBuilder<dynamic>(
              stream: FirebaseFirestore.instance
                  .collection('livestream')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasData) {
                  return Expanded(
                    child: SizedBox(
                      width: widthVar / 1,
                      child: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            LiveStream post = LiveStream.fromMap(
                                snapshot.data?.docs[index].data());

                            return InkWell(
                              onTap: () async {
                                await FirestoreMethods()
                                    .updateViewCount(post.channelId!, true);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Feed(
                                      isBroadcaster: false,
                                      channelId: post.channelId!,
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
                                            aspectRatio: 1 / 1,
                                            child: Image.network(
                                              post.image!,
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
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  post.username!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  post.title!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                                                                  fontSize: 12,
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
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
