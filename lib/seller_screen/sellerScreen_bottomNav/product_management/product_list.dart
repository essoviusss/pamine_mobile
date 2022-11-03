// ignore_for_file: invalid_return_type_for_catch_error, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pamine_mobile/model/product_model.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productCategoryController =
      TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productQuantityController =
      TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();

  CollectionReference prod = FirebaseFirestore.instance
      .collection("seller_info")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("products");

  Future<void> deleteProd(String prodID) async {
    await prod.doc(prodID).delete().then((value) {
      Fluttertoast.showToast(msg: "Product Deleted!");
    }).catchError(
      (error) => print("Failed to delete user: $error"),
    );
  }

  File? productImage;
  final imagePicker = ImagePicker();
  String? downloadUrl;
  CroppedFile? croppedImage;

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pick == null) return productImage = File(pick!.path);
    croppedImage = await ImageCropper()
        .cropImage(sourcePath: pick.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
    ]);
    if (croppedImage != null) {
      setState(() {
        productImage = File(croppedImage!.path);
      });
    }
  }

  uploadImage() async {
    final authID = FirebaseAuth.instance.currentUser;
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${authID?.uid}/images")
        .child("post_$postID");
    await ref.putFile(productImage!);
    downloadUrl = await ref.getDownloadURL();
  }

  updateProd(String prodId) async {
    await uploadImage();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore
        .collection("seller_info")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("products")
        .doc(prodId)
        .update({
      "productName": productNameController.text,
      "productCategory": productCategoryController.text,
      "productPrice": productPriceController.text,
      "productQuantity": productQuantityController.text,
      "productDescription": productDescriptionController.text,
      "productImageUrl": downloadUrl,
      "productStatus": "none",
    }).then((value) {
      Fluttertoast.showToast(msg: "Product Updated");
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.03),
          StreamBuilder(
            stream: prod.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: ((widthVar / 2.2) / (heightVar / 3.8)),
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    Products post =
                        Products.fromMap(snapshot.data!.docs[index].data());

                    return Card(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 3.0, color: Colors.grey.shade300),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child:
                                          Image.network(post.productImageUrl!),
                                    ),
                                    SizedBox(
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              top: heightVar / 99)),
                                    ),
                                    Text(
                                      post.productName!,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("₱${post.productPrice!}.00",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: heightVar / 150),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Edit Button
                                  IconButton(
                                    splashColor: Colors.blue,
                                    icon: const Icon(Icons.edit),
                                    color: Colors.red,
                                    onPressed: () {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: heightVar / 1,
                                            color: Colors.white,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: heightVar / 50,
                                                  ),
                                                  const Center(
                                                    child: Text(
                                                      'Update Product',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                widthVar / 15,
                                                            vertical: 0),
                                                    margin: EdgeInsets.only(
                                                        top: heightVar / 30),
                                                    child: TextFormField(
                                                      controller:
                                                          productNameController,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return ("Field Required");
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Product Name",
                                                        hintStyle: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors
                                                                .red.shade300),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(15),
                                                        isDense: true,
                                                        filled: true,
                                                        fillColor: const Color
                                                                .fromARGB(
                                                            255, 229, 229, 229),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 0,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                widthVar / 15,
                                                            vertical: 0),
                                                    margin: EdgeInsets.only(
                                                        top: heightVar / 80),
                                                    child: TextFormField(
                                                      controller:
                                                          productCategoryController,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return ("Field Required");
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Product Category",
                                                        hintStyle: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors
                                                                .red.shade300),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(15),
                                                        isDense: true,
                                                        filled: true,
                                                        fillColor: const Color
                                                                .fromARGB(
                                                            255, 229, 229, 229),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 0,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                widthVar / 15,
                                                            vertical: 0),
                                                    margin: EdgeInsets.only(
                                                        top: heightVar / 80),
                                                    child: TextFormField(
                                                      controller:
                                                          productPriceController,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return ("Field Required");
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Product Price (PHP)",
                                                        hintStyle: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors
                                                                .red.shade300),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(15),
                                                        isDense: true,
                                                        filled: true,
                                                        fillColor: const Color
                                                                .fromARGB(
                                                            255, 229, 229, 229),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 0,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                widthVar / 15,
                                                            vertical: 0),
                                                    margin: EdgeInsets.only(
                                                        top: heightVar / 80),
                                                    child: TextFormField(
                                                      controller:
                                                          productQuantityController,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return ("Field Required");
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Product Quantity",
                                                        hintStyle: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors
                                                                .red.shade300),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(15),
                                                        isDense: true,
                                                        filled: true,
                                                        fillColor: const Color
                                                                .fromARGB(
                                                            255, 229, 229, 229),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 0,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                widthVar / 15,
                                                            vertical: 0),
                                                    margin: EdgeInsets.only(
                                                        top: heightVar / 80),
                                                    child: TextFormField(
                                                      minLines: 5,
                                                      maxLines: 5,
                                                      controller:
                                                          productDescriptionController,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return ("Field Required");
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Description....",
                                                        hintStyle: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors
                                                                .red.shade300),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(15),
                                                        isDense: true,
                                                        filled: true,
                                                        fillColor: const Color
                                                                .fromARGB(
                                                            255, 229, 229, 229),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 0,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                widthVar / 15,
                                                            vertical: 0),
                                                    margin: EdgeInsets.only(
                                                        top: heightVar / 30),
                                                    child: GestureDetector(
                                                      onTap: imagePickerMethod,
                                                      child: DottedBorder(
                                                        borderType:
                                                            BorderType.RRect,
                                                        radius: const Radius
                                                            .circular(10),
                                                        dashPattern: const [
                                                          10,
                                                          4
                                                        ],
                                                        strokeCap:
                                                            StrokeCap.round,
                                                        color: Colors.red,
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 150,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              productImage ==
                                                                      null
                                                                  ? Column(
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .image,
                                                                          color:
                                                                              Colors.red,
                                                                          size:
                                                                              40,
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                15),
                                                                        Text(
                                                                          'Select product image',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.grey.shade500,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                  : SizedBox(
                                                                      height:
                                                                          150,
                                                                      width: double
                                                                          .infinity,
                                                                      child: Image
                                                                          .file(
                                                                        productImage!,
                                                                      ),
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: heightVar / 20),
                                                    child: TextButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    Colors.red),
                                                        padding:
                                                            MaterialStateProperty
                                                                .all<
                                                                    EdgeInsets>(
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  widthVar / 12,
                                                              vertical: 12),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        updateProd(snapshot
                                                            .data!
                                                            .docs[index]
                                                            .id);
                                                      },
                                                      child: const Text(
                                                        'Update',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: heightVar / 10,
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: widthVar / 12)),
                                  ),
                                  //Delete Button
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      Widget cancelButton = TextButton(
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      );
                                      Widget deleteButton = TextButton(
                                        child: const Text("Delete"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          deleteProd(
                                              snapshot.data!.docs[index].id);
                                        },
                                      );

                                      // set up the AlertDialog
                                      AlertDialog alert = AlertDialog(
                                        title: const Text("Confirmation!"),
                                        content: const Text(
                                            "Would you like to delete this Product?"),
                                        actions: [
                                          cancelButton,
                                          deleteButton,
                                        ],
                                      );

                                      // show the dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                    },
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
    );
  }
}
