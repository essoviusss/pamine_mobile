import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pamine_mobile/model/product_model.dart';
import 'package:pamine_mobile/seller_screen/seller_home.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final DropdownEditingController<String>? productCategoryController =
      DropdownEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productQuantityController =
      TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  int? productPrice;
  int? productQuantity;

  bool isClick = true;

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

  void addProducts() async {
    if (_formKey.currentState!.validate()) {
      await addProductsToFireStore();
    }
  }

  addProductsToFireStore() async {
    await uploadImage();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    user != null;

    Products products = Products();

    products.productName = productNameController.text;
    products.productCategory = productCategoryController?.value;
    products.productPrice = productPrice;
    products.productQuantity = productQuantity;
    products.productDescription = productDescriptionController.text;
    products.productImageUrl = downloadUrl!;
    products.productStatus = "none";
    products.sellerUid = user!.uid;

    await firebaseFirestore
        .collection("seller_info")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("products")
        .doc()
        .set(products.toMap(), SetOptions(merge: true))
        .then((value) {
      Fluttertoast.showToast(msg: "Product Added");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const seller_home()));
    });
  }

  @override
  Widget build(BuildContext context) {
    double heigthVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;

    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: widthVar / 15, vertical: 0),
                  margin: EdgeInsets.only(top: heigthVar / 30),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_sharp,
                        color: Colors.red,
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(right: widthVar / 40),
                        ),
                      ),
                      const Text(
                        "Product Details",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: widthVar / 15, vertical: 0),
                  margin: EdgeInsets.only(top: heigthVar / 30),
                  child: TextFormField(
                    controller: productNameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Field Required");
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Product Name",
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.red.shade300),
                      contentPadding: const EdgeInsets.all(15),
                      isDense: true,
                      filled: true,
                      fillColor: const Color.fromARGB(255, 229, 229, 229),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(width: 0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: widthVar / 15, vertical: 0),
                  margin: EdgeInsets.only(top: heigthVar / 80),
                  child: TextDropdownFormField(
                    controller: productCategoryController,
                    options: const [
                      "Clothes",
                      "Jeans",
                      "Shoes",
                      "Appliances",
                      "Gadgets",
                      "Kitchenwares",
                      "Bedsheets"
                    ],
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      hintText: "Product Category",
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.red.shade300),
                      contentPadding: const EdgeInsets.all(15),
                      isDense: true,
                      filled: true,
                      fillColor: const Color.fromARGB(255, 229, 229, 229),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(width: 0, color: Colors.white),
                      ),
                    ),
                    dropdownHeight: 120,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: widthVar / 15, vertical: 0),
                  margin: EdgeInsets.only(top: heigthVar / 80),
                  child: TextFormField(
                    onChanged: (value) {
                      productPrice = int.parse(value);
                    },
                    controller: productPriceController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Field Required");
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Product Price (PHP)",
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.red.shade300),
                      contentPadding: const EdgeInsets.all(15),
                      isDense: true,
                      filled: true,
                      fillColor: const Color.fromARGB(255, 229, 229, 229),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(width: 0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: widthVar / 15, vertical: 0),
                  margin: EdgeInsets.only(top: heigthVar / 80),
                  child: TextFormField(
                    onChanged: (value) {
                      productQuantity = int.parse(value);
                    },
                    controller: productQuantityController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Field Required");
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Product Quantity",
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.red.shade300),
                      contentPadding: const EdgeInsets.all(15),
                      isDense: true,
                      filled: true,
                      fillColor: const Color.fromARGB(255, 229, 229, 229),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(width: 0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: widthVar / 15, vertical: 0),
                  margin: EdgeInsets.only(top: heigthVar / 80),
                  child: TextFormField(
                    minLines: 5,
                    maxLines: 5,
                    controller: productDescriptionController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Field Required");
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Description....",
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.red.shade300),
                      contentPadding: const EdgeInsets.all(15),
                      isDense: true,
                      filled: true,
                      fillColor: const Color.fromARGB(255, 229, 229, 229),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(width: 0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: widthVar / 15, vertical: 0),
                  margin: EdgeInsets.only(top: heigthVar / 30),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.image,
                        color: Colors.red,
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(right: widthVar / 40),
                        ),
                      ),
                      const Text(
                        "Product Image",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: widthVar / 15, vertical: 0),
                  margin: EdgeInsets.only(top: heigthVar / 30),
                  child: GestureDetector(
                    onTap: imagePickerMethod,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      dashPattern: const [10, 4],
                      strokeCap: StrokeCap.round,
                      color: Colors.red,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            productImage == null
                                ? Column(
                                    children: [
                                      const Icon(
                                        Icons.image,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        'Select product image',
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
                                      productImage!,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(top: heigthVar / 20),
                  ),
                )
              ],
            ),
          ),
        ),
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: widthVar / 12, vertical: 12),
                    ),
                  ),
                  onPressed: () {
                    if (isClick) {
                      setState(() {
                        isClick = false;
                      });
                      addProducts();
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
