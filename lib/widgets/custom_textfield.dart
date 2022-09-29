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
      margin: const EdgeInsets.only(left: 0),
      child: TextField(
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.comment),
          hintText: 'Comments....',
          hintStyle: const TextStyle(fontSize: 15.0, color: Colors.red),
          contentPadding: const EdgeInsets.all(15),
          isDense: true,
          filled: true,
          fillColor: const Color(0xffF7F5F2),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide(width: 0, color: Colors.white),
          ),
        ),
        onSubmitted: onTap,
        controller: controller,
      ),
    );
  }
}
