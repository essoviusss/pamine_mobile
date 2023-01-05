import 'package:flutter/material.dart';

class LiveDetails extends StatefulWidget {
  const LiveDetails({super.key});

  @override
  State<LiveDetails> createState() => _LiveDetailsState();
}

class _LiveDetailsState extends State<LiveDetails> {
  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.orange.shade200,
            border: Border.all(color: Colors.transparent),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          width: double.infinity,
          child: Container(
            margin: EdgeInsets.only(
              left: widthVar / 35,
              right: widthVar / 35,
              top: heightVar / 60,
              bottom: heightVar / 60,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Live Streaming",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: heightVar / 20,
                ),
                Row(
                  children: [
                    Text(
                      "Total Likes",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "0",
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: heightVar / 20,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: heightVar / 60,
        ),
        Container(
          height: heightVar / 10,
          color: Colors.blue,
        ),
      ],
    );
  }
}
