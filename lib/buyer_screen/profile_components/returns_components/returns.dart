import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/returns_components/accepted.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/returns_components/rejected.dart';
import 'package:pamine_mobile/buyer_screen/profile_components/returns_components/request.dart';
import 'package:pamine_mobile/seller_screen/sellerScreen_bottomNav/notification_components/accepted.dart';

class ReturnsCancellations extends StatefulWidget {
  const ReturnsCancellations({super.key});

  @override
  State<ReturnsCancellations> createState() => _ReturnsCancellationsState();
}

class _ReturnsCancellationsState extends State<ReturnsCancellations> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFC21010),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text("Returns/Cancellations"),
          bottom: const TabBar(
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            )),
            tabs: [
              Tab(
                child: Text(
                  "Requests",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text("Processing",
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              Tab(
                child: Text("Rejected",
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Requests(),
            ReturnAccepted(),
            ReturnRejected(),
          ],
        ),
      ),
    );
  }
}
