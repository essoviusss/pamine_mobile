import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onTap;
  const CustomTextField({
    Key? key,
    required this.controller,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      width: widthVar / 2.2,
      height: heightVar / 16,
      padding: EdgeInsets.only(right: widthVar / 50, left: widthVar / 60),
      child: TextField(
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.comment),
          hintText: 'Comments....',
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.red),
          contentPadding: EdgeInsets.all(15),
          isDense: true,
          filled: true,
          fillColor: Color(0xffF7F5F2),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            borderSide: BorderSide(width: 0, color: Colors.white),
          ),
        ),
        onSubmitted: onTap,
        controller: controller,
      ),
    );
  }
}
