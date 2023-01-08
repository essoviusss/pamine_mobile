// ignore_for_file: non_constant_identifier_names
class TransactionModel {
  String? transactionId;
  int? transactionTotalPrice;
  var transactionDate;
  int? totalCommision;
  int? totalSale;
  String? buyerName;
  String? modeOfPayment;
  String? cpNum;
  String? shippingAddress;
  String? status;
  String? buyerUid;
  List? itemList = [];

  TransactionModel({
    this.transactionId,
    this.transactionTotalPrice,
    this.transactionDate,
    this.totalCommision,
    this.totalSale,
    this.buyerName,
    this.modeOfPayment,
    this.cpNum,
    this.shippingAddress,
    this.status,
    this.buyerUid,
    this.itemList,
  });
  factory TransactionModel.fromMap(map) {
    return TransactionModel(
      transactionId: map['transactionId'],
      transactionTotalPrice: map['transactionTotalPrice'],
      transactionDate: map['transactionDate'],
      totalCommision: map['totalCommission'],
      totalSale: map['totalSale'],
      buyerName: map['buyerName'],
      modeOfPayment: map['modeOfPayment'],
      cpNum: map['cpNum'],
      shippingAddress: map['shippingAddress'],
      status: map['status'],
      buyerUid: map['buyerUid'],
      itemList: map['itemList'],
    );
  }
  //send
  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'transactionTotalPrice': transactionTotalPrice,
      'transactionDate': transactionDate,
      'totalCommission': totalCommision,
      'totalSale': totalSale,
      'buyerName': buyerName,
      'modeOfPayment': modeOfPayment,
      'cpNum': cpNum,
      'shippingAddress': shippingAddress,
      'status': status,
      'buyerUid': buyerUid,
      'itemList': itemList,
    };
  }
}
