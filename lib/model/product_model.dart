class Products {
  String? productId;
  String? productName;
  String? productCategory;
  int? productPrice;
  int? productCommission;
  int? productQuantity;
  String? productDescription;
  String? productImageUrl;
  String? productStatus;
  String? sellerUid;

  Products({
    this.productId,
    this.productName,
    this.productCategory,
    this.productPrice,
    this.productCommission,
    this.productQuantity,
    this.productDescription,
    this.productImageUrl,
    this.productStatus,
    this.sellerUid,
  });
  //receive
  factory Products.fromMap(map) {
    return Products(
      productId: map["productId"],
      productName: map["productName"],
      productCategory: map["productCategory"],
      productPrice: map["productPrice"],
      productCommission: map['productCommission'],
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
      "productId": productId,
      "productName": productName,
      "productCategory": productCategory,
      "productPrice": productPrice,
      "productCommission": productCommission,
      "productQuantity": productQuantity,
      "productDescription": productDescription,
      "productImageUrl": productImageUrl,
      "productStatus": productStatus,
      "sellerUid": sellerUid,
    };
  }
}
