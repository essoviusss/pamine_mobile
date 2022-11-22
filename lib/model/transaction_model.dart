// ignore_for_file: non_constant_identifier_names
class Transactions {
  String? BuyerName;
  var TransactionDate;
  int? TransactionTotalPrice;
  String? TransactionId;

  Transactions({
    this.BuyerName,
    this.TransactionDate,
    this.TransactionId,
    this.TransactionTotalPrice,
  });
  factory Transactions.fromMap(map) {
    return Transactions(
      BuyerName: map['BuyerName'],
      TransactionDate: map['TransactionDate'],
      TransactionTotalPrice: map['TransactionTotalPrice'],
      TransactionId: map['TransactionId'],
    );
  }
  //send
  Map<String, dynamic> toMap() {
    return {
      "BuyerName": BuyerName,
      "TransactionDate": TransactionDate,
      "TransactionTotalPrice": TransactionTotalPrice,
      "TransactionId": TransactionId,
    };
  }
}
