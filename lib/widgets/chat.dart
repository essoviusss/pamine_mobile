import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pamine_mobile/methods/firestore_methods.dart';
import 'custom_textfield.dart';

class Chat extends StatefulWidget {
  final String channelId;
  const Chat({
    Key? key,
    required this.channelId,
  }) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _needsScroll = false;

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  final ScrollController _myController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width > 600 ? size.width * 0.25 : double.infinity,
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
                if (snapshot.connectionState == ConnectionState.none) {
                  return const CircularProgressIndicator();
                }
                Timer(
                    const Duration(milliseconds: 500),
                    () => _myController
                        .jumpTo(_myController.position.maxScrollExtent));
                return ListView.builder(
                  controller: _myController,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        border:
                            Border.all(color: Colors.transparent, width: 3.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 10,
                              color: Colors.transparent,
                              offset: Offset(1, 3))
                        ]),
                    child: ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.only(
                          left: 10, right: 0.0, top: 0, bottom: 10),
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -4),
                      title: Text(
                        snapshot.data.docs[index]['username'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: snapshot.data.docs[index]['uid'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? const Color.fromARGB(255, 99, 9, 3)
                              : Colors.blue,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data.docs[index]['message'],
                        style: const TextStyle(color: Colors.white),
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
          const SizedBox(
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
          ),
        ],
      ),
    );
  }
}
