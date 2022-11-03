import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("seller_info")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          LoadingAnimationWidget.waveDots(
            color: Colors.blue,
            size: 50,
          );
        } else {
          return Row(
            children: [
              SizedBox(
                width: widthVar / 15,
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: 115,
                width: 115,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data?['logoUrl']),
                    ),
                    Positioned(
                      right: -16,
                      bottom: 0,
                      child: SizedBox(
                        height: 46,
                        width: 46,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 231, 231, 231),
                          ),
                          onPressed: () {},
                          child: const Icon(
                            Icons.add_a_photo,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: widthVar / 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  snapshot.data?['dtiRegistered'] == "Yes"
                      ? Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: widthVar / 50,
                          children: [
                            const Icon(
                              Icons.verified,
                              color: Colors.red,
                            ),
                            Text(
                              snapshot.data?['businessName'],
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Text(
                          snapshot.data?['businessName'],
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                  Text(
                    "Owner: ${snapshot.data?['businessOwnerName']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${snapshot.data?['phoneNumber']}",
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
