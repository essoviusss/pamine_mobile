class CartModel {
  String? productImageUrl;
  String? productName;
  int? productPrice;
  int? productQuantity;
  int? subtotal;
  String? sellerUid;

  CartModel({
    this.productImageUrl,
    this.productName,
    this.productPrice,
    this.productQuantity,
    this.subtotal,
    this.sellerUid,
  });

  factory CartModel.fromMap(map) {
    return CartModel(
      productImageUrl: map['productImageUrl'],
      productName: map['productName'],
      productPrice: map['productPrice'],
      productQuantity: map['productQuantity'],
      subtotal: map['subtotal'],
      sellerUid: map['sellerUid'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'productImageUrl': productImageUrl,
      'productName': productName,
      'productPrice': productPrice,
      'productQuantity': productQuantity,
      'subtotal': subtotal,
      'sellerUid': sellerUid,
    };
  }
}
