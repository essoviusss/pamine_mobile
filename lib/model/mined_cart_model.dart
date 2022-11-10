class MinedCartModel {
  String? productImageUrl;
  String? productName;
  int? productPrice;

  MinedCartModel({
    this.productImageUrl,
    this.productName,
    this.productPrice,
  });

  factory MinedCartModel.fromMap(map) {
    return MinedCartModel(
      productImageUrl: map['productImageUrl'],
      productName: map['productName'],
      productPrice: map['productPrice'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'productImageUrl': productImageUrl,
      'productName': productName,
      'productPrice': productPrice,
    };
  }
}
