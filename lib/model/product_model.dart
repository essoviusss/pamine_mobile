import 'package:firebase_auth/firebase_auth.dart';

class Products {
  String? productName;
  String? productCategory;
  String? productPrice;
  String? productQuantity;
  String? productDescription;
  String? productImageUrl;
  String? productStatus;
  String? sellerUid;

  Products({
    this.productName,
    this.productCategory,
    this.productPrice,
    this.productQuantity,
    this.productDescription,
    this.productImageUrl,
    this.productStatus,
    this.sellerUid,
  });

  factory Products.fromMap(map) {
    return Products(
      productName: map["productName"],
      productCategory: map["productCategory"],
      productPrice: map["productPrice"],
      productQuantity: map['productQuantity'],
      productDescription: map["productDescription"],
      productImageUrl: map["productImageUrl"],
      productStatus: map['productStatus'],
      sellerUid: map['sellerUid'],
    );
  }
  //send
  Map<String, dynamic> toMap() {
    return {
      "productName": productName,
      "productCategory": productCategory,
      "productPrice": productPrice,
      "productQuantity": productQuantity,
      "productDescription": productDescription,
      "productImageUrl": productImageUrl,
      "productStatus": productStatus,
      "sellerUid": sellerUid,
    };
  }
}
