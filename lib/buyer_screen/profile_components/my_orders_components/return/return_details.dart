import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ReturnDetails extends StatefulWidget {
  final String? productId;
  final String? productImageUrl;
  final String? productName;
  final int? subtotal;
  final int? quantity;
  final String? sellerUid;
  final String? shopName;
  final String? buyerName;
  const ReturnDetails({
    super.key,
    required this.productId,
    required this.productImageUrl,
    required this.productName,
    required this.subtotal,
    required this.quantity,
    required this.sellerUid,
    required this.shopName,
    required this.buyerName,
  });

  @override
  State<ReturnDetails> createState() => _ReturnDetailsState();
}

class _ReturnDetailsState extends State<ReturnDetails> {
  String? reason;
  final imagePicker = ImagePicker();
  File? logo;
  String? rUrl;
  final DropdownEditingController<String>? resController =
      DropdownEditingController();

  final ref = FirebaseFirestore.instance;
  Future imagePickerMethod2() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pick == null) return logo = File(pick!.path);
    var croppedImage = await ImageCropper()
        .cropImage(sourcePath: pick.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
    ]);
    if (croppedImage != null) {
      setState(() {
        logo = File(croppedImage.path);
      });
    }
  }

  uploadImage2() async {
    final authID = FirebaseAuth.instance.currentUser;
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${authID?.uid}/images")
        .child("post_$postID");
    await ref.putFile(logo!);
    rUrl = await ref.getDownloadURL();
  }

  returnRefund() async {
    await uploadImage2();
    ref
        .collection("seller_info")
        .doc(widget.sellerUid)
        .collection("returns")
        .doc(widget.productId)
        .set(
      {
        "productId": widget.productId,
        "buyerName": widget.buyerName,
        "productName": widget.productName,
        "productImageUrl": widget.productImageUrl,
        "quantity": widget.quantity,
        "returnDetails": resController?.value,
        "rURl": rUrl,
        "returnStatus": "none"
      },
      SetOptions(merge: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(
            left: widthVar / 25, right: widthVar / 25, top: heightVar / 60),
        child: Column(
          children: [
            const Text(
              "Return/Refund Item",
              style: TextStyle(
                  color: Color(0xFFC21010),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            TextDropdownFormField(
              controller: resController,
              options: const [
                "Wrong Item",
                "Damaged Item",
                "Incomplete Item",
                "Defective Item"
              ],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  labelText: "Return Details"),
              dropdownHeight: heightVar / 4,
            ),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: widthVar / 20, vertical: 0),
              margin: EdgeInsets.only(top: heightVar / 30),
              child: GestureDetector(
                onTap: imagePickerMethod2,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  dashPattern: const [10, 4],
                  strokeCap: StrokeCap.round,
                  color: Colors.black,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        logo == null
                            ? Column(
                                children: [
                                  const Icon(
                                    Icons.image,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Select photo',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade500,
                                    ),
                                  )
                                ],
                              )
                            : SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Image.file(
                                  logo!,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(
                        horizontal: widthVar / 10, vertical: 12),
                  ),
                ),
                onPressed: () {
                  returnRefund();
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
