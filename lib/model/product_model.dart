class Products {
  String? productName;
  String? productCategory;
  String? productPrice;
  String? productQuantity;
  String? productDescription;
  String? productImageUrl;
  String? productStatus;

  Products({
    this.productName,
    this.productCategory,
    this.productPrice,
    this.productQuantity,
    this.productDescription,
    this.productImageUrl,
    this.productStatus,
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
    };
  }
}
