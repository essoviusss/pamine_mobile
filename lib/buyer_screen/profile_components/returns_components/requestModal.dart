import 'package:flutter/material.dart';

class RequestModal extends StatefulWidget {
  final String? businessName,
      buyerName,
      buyerUid,
      cpNum,
      logoUrl,
      modeOfPayment,
      transactionId,
      sellerUid,
      statId,
      returnDetails,
      rUrl;
  final List? itemList;
  final int? totalCommision, totalSale, transactionTotalPrice;

  const RequestModal({
    super.key,
    required this.businessName,
    required this.buyerName,
    required this.buyerUid,
    required this.cpNum,
    required this.logoUrl,
    required this.modeOfPayment,
    required this.transactionId,
    required this.itemList,
    required this.totalCommision,
    required this.totalSale,
    required this.transactionTotalPrice,
    required this.sellerUid,
    required this.statId,
    required this.returnDetails,
    required this.rUrl,
  });

  @override
  State<RequestModal> createState() => _RequestModalState();
}

class _RequestModalState extends State<RequestModal> {
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(
            left: widthVar / 25, right: widthVar / 25, top: heightVar / 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: heightVar / 60,
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "Return Details",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Transaction Id: ${widget.transactionId!}"),
                        Text("Buyer Name: ${widget.buyerName!}"),
                        Text(
                            "Buyer Name: ₱${widget.transactionTotalPrice!}.00"),
                        const Text("Status: Pending"),
                        SizedBox(
                          height: heightVar / 60,
                        ),
                        const Text(
                          "Ordered items:",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.itemList?.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                left: widthVar / 25,
                                right: widthVar / 25,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: heightVar / 80,
                                  ),
                                  Row(
                                    children: [
                                      Image.network(
                                        widget.itemList?[index]
                                            ['productImageUrl'],
                                        height: 60,
                                        width: 60,
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Product Name: ${widget.itemList?[index]['productName'].toString()}"),
                                              Text(
                                                  "Quantity: ${widget.itemList?[index]['productQuantity'].toString()}"),
                                              Text(
                                                  "Item Price: ₱${widget.itemList?[index]['productPrice'].toString()}.00"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: heightVar / 60,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            Text(
              "Return Details: ${widget.returnDetails!}",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: heightVar / 60,
            ),
            Image.network(widget.rUrl!),
            SizedBox(
              height: heightVar / 60,
            ),
          ],
        ),
      ),
    );
  }
}
