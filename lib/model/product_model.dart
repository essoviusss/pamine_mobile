class Products {
  String? productName;
  String? productCategory;
  String? productPrice;
  String? productDescription;
  String? productImageUrl;

  Products({
    this.productName,
    this.productCategory,
    this.productPrice,
    this.productDescription,
    this.productImageUrl,
  });

  factory Products.fromMap(map) {
    return Products(
      productName: map["productName"],
      productCategory: map["productCategory"],
      productPrice: map["productPrice"],
      productDescription: map["productDescription"],
      productImageUrl: map["productImageUrl"],
    );
  }
  //send
  Map<String, dynamic> toMap() {
    return {
      "productName": productName,
      "productCategory": productCategory,
      "productPrice": productPrice,
      "productDescription": productDescription,
      "productImageUrl": productImageUrl,
    };
  }
}
