import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/delivery_details_components/add_delivery_details.dart';
import 'package:pamine_mobile/model/delivery_details_model.dart';

class DeliveryDetails extends StatefulWidget {
  const DeliveryDetails({super.key});

  @override
  State<DeliveryDetails> createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  final firestore = FirebaseFirestore.instance
      .collection("buyer_info")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("delivery_details");
  String autocompletePlace = "";
  String address = "";
  final TextEditingController _buyerName = TextEditingController();
  final TextEditingController _buyerCpNum = TextEditingController();
  TextEditingController? _shippingAddress;

  uploadDeliveryDetails() async {
    DeliveryDetailsModel deliveryDetailsModel = DeliveryDetailsModel();

    deliveryDetailsModel.fullName = _buyerName.text;
    deliveryDetailsModel.cpNumber = _buyerCpNum.text;
    deliveryDetailsModel.shippingAddress = _shippingAddress?.text;

    await firestore.doc().set(deliveryDetailsModel.toMap()).then((value) {
      Fluttertoast.showToast(msg: "New Delivery Details Added");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AddDeliveryDetails(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC21010),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text("Delivery Details"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: heightVar / 50,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: widthVar / 25),
            child: const Text(
              "Delivery Details",
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFC21010),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: widthVar / 25, vertical: 0),
            margin: EdgeInsets.only(top: heightVar / 70),
            child: TextFormField(
              controller: _buyerName,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Field Required");
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Full Name",
                hintStyle:
                    TextStyle(fontSize: 15.0, color: Colors.red.shade300),
                contentPadding: const EdgeInsets.all(15),
                isDense: true,
                filled: true,
                fillColor: const Color.fromARGB(255, 229, 229, 229),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(width: 0, color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: widthVar / 25, vertical: 0),
            margin: EdgeInsets.only(top: heightVar / 70),
            child: TextFormField(
              controller: _buyerCpNum,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Field Required");
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Contact Number",
                hintStyle:
                    TextStyle(fontSize: 15.0, color: Colors.red.shade300),
                contentPadding: const EdgeInsets.all(15),
                isDense: true,
                filled: true,
                fillColor: const Color.fromARGB(255, 229, 229, 229),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(width: 0, color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: widthVar / 25, vertical: 0),
            margin: EdgeInsets.only(top: heightVar / 70),
            child: TextFormField(
              controller: _shippingAddress = TextEditingController(
                  text: autocompletePlace == ""
                      ? address
                      : address == ""
                          ? autocompletePlace
                          : address),
              minLines: 5,
              maxLines: 5,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Field Required");
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
                            apiKey: "AIzaSyCa_s2VTCGuakM-E21dI9fzMc2gEPXGY5A",
                            canPopOnNextButtonTaped: true,
                            currentLatLng: const LatLng(29.121599, 76.396698),
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
                                      result.result.formattedAddress ?? "";
                                });
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.pin_drop_sharp,
                    size: 30,
                    color: Color(0xFFC21010),
                  ),
                ),
                hintText: "Shipping Address",
                hintStyle:
                    TextStyle(fontSize: 15.0, color: Colors.red.shade300),
                contentPadding: const EdgeInsets.all(15),
                isDense: true,
                filled: true,
                fillColor: const Color.fromARGB(255, 229, 229, 229),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(width: 0, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFC21010)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: widthVar / 3.9, vertical: heightVar / 60),
                    ),
                  ),
                  onPressed: () {
                    uploadDeliveryDetails();
                  },
                  child: const Text(
                    'Add Details',
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
