class MinedCartModel {
  String? productImageUrl;
  String? productName;
  int? productPrice;
  String? sellerUid;

  MinedCartModel({
    this.productImageUrl,
    this.productName,
    this.productPrice,
    this.sellerUid,
  });

  factory MinedCartModel.fromMap(map) {
    return MinedCartModel(
        productImageUrl: map['productImageUrl'],
        productName: map['productName'],
        productPrice: map['productPrice'],
        sellerUid: map['sellerUid']);
  }
  Map<String, dynamic> toMap() {
    return {
      'productImageUrl': productImageUrl,
      'productName': productName,
      'productPrice': productPrice,
      'sellerUid': sellerUid,
    };
  }
}
