class CartModel {
  String? productImageUrl;
  String? productName;
  String? productPrice;

  CartModel({
    required this.productImageUrl,
    required this.productName,
    required this.productPrice,
  });

  factory CartModel.fromMap(map) {
    return CartModel(
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
