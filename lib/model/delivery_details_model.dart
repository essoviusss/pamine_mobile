class DeliveryDetailsModel {
  String? fullName;
  String? cpNumber;
  String? shippingAddress;

  DeliveryDetailsModel({
    this.fullName,
    this.cpNumber,
    this.shippingAddress,
  });

  factory DeliveryDetailsModel.fromMap(map) {
    return DeliveryDetailsModel(
      fullName: map['fullName'],
      cpNumber: map['cpNumber'],
      shippingAddress: map['ShippingAddress'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'cpNumber': cpNumber,
      'shippingAddress': shippingAddress,
    };
  }
}
