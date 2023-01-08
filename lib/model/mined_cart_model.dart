class MinedCartModel {
  String? productId;
  String? productImageUrl;
  String? productName;
  int? productPrice;
  int? commission;
  int? productQuantity;
  int? subtotal;
  String? sellerUid;

  MinedCartModel({
    this.productId,
    this.productImageUrl,
    this.productName,
    this.productPrice,
    this.commission,
    this.productQuantity,
    this.subtotal,
    this.sellerUid,
  });

  factory MinedCartModel.fromMap(map) {
    return MinedCartModel(
      productId: map['productId'],
      productImageUrl: map['productImageUrl'],
      productName: map['productName'],
      productPrice: map['productPrice'],
      commission: map['commission'],
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
      'commission': commission,
      'productQuantity': productQuantity,
      'subtotal': subtotal,
      'sellerUid': sellerUid,
    };
  }
}
