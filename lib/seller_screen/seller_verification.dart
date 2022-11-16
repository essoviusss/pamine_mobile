import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:pamine_mobile/model/seller_user_model.dart';
import 'package:pamine_mobile/seller_screen/approval_screen.dart';

// ignore: camel_case_types
class seller_verification extends StatefulWidget {
  const seller_verification({
    super.key,
  });
  static String id = "seller_verification";

  @override
  State<seller_verification> createState() => _seller_verificationState();
}

// ignore: camel_case_types
class _seller_verificationState extends State<seller_verification> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _businessOwnerController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _address = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _dtiNumberController = TextEditingController();
  final TextEditingController _dtiExpDateController = TextEditingController();
  String? taxStatus;

  String autocompletePlace = "";
  String address = "";

  File? image;
  File? id;
  final idPicker = ImagePicker();
  final imagePicker = ImagePicker();
  String? permitUrl, idUrl;

  //Image Picker
  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        image = File(pick.path);
      } else {
        showSnackBar("No file selected", const Duration(seconds: 1));
      }
    });
  }

  Future imagePickerMethod1() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        id = File(pick.path);
      } else {
        showSnackBar("No file selected", const Duration(seconds: 1));
      }
    });
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future uploadImage() async {
    final authID = FirebaseAuth.instance.currentUser;
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${authID?.uid}/images")
        .child("post_$postID");
    await ref.putFile(image!);
    permitUrl = await ref.getDownloadURL();
    Reference ref1 = FirebaseStorage.instance
        .ref()
        .child("${authID?.uid}/images")
        .child("post1_$postID");
    await ref1.putFile(id!);
    idUrl = await ref.getDownloadURL();
  }

  //Add
  void addDetails() async {
    if (_formKey.currentState!.validate()) {
      addDetailsToFireStore();
    }
  }

  addDetailsToFireStore() async {
    if (taxStatus == "Yes") {
      await uploadImage();
    } else {
      uploadImage();
    }
    await uploadImage2();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    AddModel addModel = AddModel();

    addModel.logoUrl = downloadUrl;
    addModel.businessName = _businessController.text;
    addModel.businessOwnerName = _businessOwnerController.text;
    addModel.phoneNumber = _phoneNumberController.text;
    addModel.address = _addressController.text;
    addModel.zipCode = _zipCodeController.text;
    addModel.dtiRegistered = taxStatus;
    addModel.dtiCertNumber = _dtiNumberController.text;
    addModel.permitExpDate = _dtiExpDateController.text;
    addModel.uid = user?.uid;
    addModel.status = "not verified";
    addModel.permitUrl = permitUrl;
    addModel.idUrl = idUrl;

    await firebaseFirestore
        .collection("seller_info")
        .doc(user?.uid)
        .set(addModel.toMap())
        .then((value) {
      Fluttertoast.showToast(msg: "Application Submitted");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const approval_screen()));
    });
  }

  //Date Picker
  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _dtiExpDateController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  File? logo;
  final imagePicker1 = ImagePicker();
  String? downloadUrl;
  CroppedFile? croppedImage;

  Future imagePickerMethod2() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pick == null) return logo = File(pick!.path);
    croppedImage = await ImageCropper()
        .cropImage(sourcePath: pick.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
    ]);
    if (croppedImage != null) {
      setState(() {
        logo = File(croppedImage!.path);
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
    downloadUrl = await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    double heigthVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: const Center(child: Text("Seller's Verification")),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: widthVar / 5, vertical: 0),
                margin: EdgeInsets.only(top: heigthVar / 30),
                child: GestureDetector(
                  onTap: imagePickerMethod2,
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
                                      'Select Business Logo',
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
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: widthVar / 10, vertical: 0),
                margin: EdgeInsets.only(top: heigthVar / 30),
                child: TextFormField(
                  controller: _businessController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter your Business Name");
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.business),
                    hintText: "Business Name",
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                    contentPadding: EdgeInsets.all(15),
                    isDense: true,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: widthVar / 10, vertical: 0),
                margin: EdgeInsets.only(top: heigthVar / 80),
                child: TextFormField(
                  controller: _businessOwnerController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter your Business Name");
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: "Business Owner Name",
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                    contentPadding: EdgeInsets.all(15),
                    isDense: true,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: widthVar / 10, vertical: 0),
                margin: EdgeInsets.only(top: heigthVar / 80),
                child: TextFormField(
                  controller: _phoneNumberController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter your Phone Number ");
                    } else if (!RegExp('^(09)\\d{9}').hasMatch(value)) {
                      return ("Invalid Phone Number");
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.numbers),
                    hintText: "Phone Number",
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                    contentPadding: EdgeInsets.all(15),
                    isDense: true,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: widthVar / 10, vertical: 0),
                margin: EdgeInsets.only(top: heigthVar / 80),
                child: TextFormField(
                  maxLines: 2,
                  minLines: 2,
                  controller: _addressController = TextEditingController(
                      text: _addressController.text == ""
                          ? address
                          : address == ""
                              ? _addressController.text
                              : autocompletePlace),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter your Address");
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MapLocationPicker(
                                  apiKey:
                                      "AIzaSyCa_s2VTCGuakM-E21dI9fzMc2gEPXGY5A",
                                  canPopOnNextButtonTaped: true,
                                  currentLatLng:
                                      const LatLng(29.121599, 76.396698),
                                  onNext: (GeocodingResult? result) {
                                    if (result != null) {
                                      setState(() {
                                        address = result.formattedAddress ?? "";
                                      });
                                    }
                                  },
                                  onSuggestionSelected:
                                      (PlacesDetailsResponse? result) {
                                    if (result != null) {
                                      setState(() {
                                        autocompletePlace =
                                            result.result.formattedAddress ??
                                                "";
                                      });
                                    }
                                  },
                                );
                              },
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                        )),
                    hintText: "Address",
                    hintStyle:
                        const TextStyle(fontSize: 15.0, color: Colors.grey),
                    contentPadding: EdgeInsets.all(15),
                    isDense: true,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: widthVar / 10, vertical: 0),
                margin: EdgeInsets.only(top: heigthVar / 80),
                child: TextFormField(
                  controller: _zipCodeController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter your Zip Code");
                      // ignore: unnecessary_string_escapes
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.code),
                    hintText: "Zip Code",
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                    contentPadding: EdgeInsets.all(15),
                    isDense: true,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: widthVar / 10, vertical: 0),
                margin: EdgeInsets.only(top: heigthVar / 80),
                child: Row(
                  children: [
                    const Text('DTI Registered:              '),
                    Expanded(
                      child: DropdownButtonFormField(
                        validator: (value) {
                          if (value == null) {
                            return "Select DTI status";
                          }
                          return null;
                        },
                        value: taxStatus,
                        hint: const Text('Select'),
                        items: <String>['Yes', 'No']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            taxStatus = value as String?;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              if (taxStatus == "Yes")
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: widthVar / 10, vertical: 0),
                      margin: EdgeInsets.only(top: heigthVar / 80),
                      child: TextFormField(
                        controller: _dtiNumberController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter your DTI Number");
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.numbers_sharp),
                          hintText: "DTI Certificate Number",
                          hintStyle:
                              TextStyle(fontSize: 15.0, color: Colors.grey),
                          contentPadding: EdgeInsets.all(15),
                          isDense: true,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: widthVar / 10, vertical: 0),
                      margin: EdgeInsets.only(top: heigthVar / 80),
                      child: TextFormField(
                        controller: _dtiExpDateController,
                        textInputAction: TextInputAction.done,
                        onTap: () {
                          _selectDate();
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Expiry Date");
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month),
                          hintText: "Permit Expiry Date",
                          hintStyle:
                              TextStyle(fontSize: 15.0, color: Colors.grey),
                          contentPadding: EdgeInsets.all(15),
                          isDense: true,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: widthVar / 10, vertical: 0),
                      margin: EdgeInsets.only(top: heigthVar / 80),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: widthVar / 10, vertical: 0),
                      margin: EdgeInsets.only(top: heigthVar / 80),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal: widthVar / 10, vertical: 10),
                          ),
                        ),
                        onPressed: () {
                          imagePickerMethod();
                        },
                        child: const Text('Insert Picture of DTI Permit',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: widthVar / 1,
                          height: heigthVar / 5,
                          child: Expanded(
                              child: image == null
                                  ? const Center(
                                      child: Text(
                                      "No Image Selected",
                                    ))
                                  : Image.file(image!)),
                        ),
                        Container(
                          child: image == null
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      image = null;
                                    });
                                  },
                                ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: widthVar / 10, vertical: 0),
                      margin: EdgeInsets.only(top: heigthVar / 80),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal: widthVar / 10, vertical: 10),
                          ),
                        ),
                        onPressed: () {
                          imagePickerMethod1();
                        },
                        child: const Text('Insert Government ID Picture',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: widthVar / 1,
                          height: heigthVar / 5,
                          child: Expanded(
                              child: id == null
                                  ? const Center(
                                      child: Text("No Image Selected"))
                                  : Image.file(id!)),
                        ),
                        Container(
                          child: id == null
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(
                                      () {
                                        id = null;
                                      },
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: widthVar / 3.9, vertical: 10),
                    ),
                  ),
                  onPressed: () {
                    addDetails();
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
