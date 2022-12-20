class CartModel {
  String? productId;
  String? productImageUrl;
  String? productName;
  int? productPrice;
  int? commision;
  int? productQuantity;
  int? subtotal;
  String? sellerUid;

  CartModel({
    this.productId,
    this.productImageUrl,
    this.productName,
    this.productPrice,
    this.commision,
    this.productQuantity,
    this.subtotal,
    this.sellerUid,
  });

  factory CartModel.fromMap(map) {
    return CartModel(
      productId: map['productId'],
      productImageUrl: map['productImageUrl'],
      productName: map['productName'],
      productPrice: map['productPrice'],
      commision: map['commision'],
      productQuantity: map['productQuantity'],
      subtotal: map['subtotal'],
      sellerUid: map['sellerUid'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productImageUrl': productImageUrl,
      'productName': productName,
      'productPrice': productPrice,
      'commision': commision,
      'productQuantity': productQuantity,
      'subtotal': subtotal,
      'sellerUid': sellerUid,
    };
  }
}
