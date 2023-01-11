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
      width: widthVar / 2,
      height: heightVar / 18,
      padding: EdgeInsets.only(right: widthVar / 50, left: widthVar / 50),
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
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(width: 0, color: Colors.white),
          ),
        ),
        onSubmitted: onTap,
        controller: controller,
      ),
    );
  }
}
