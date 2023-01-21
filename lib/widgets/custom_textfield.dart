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
      width: widthVar / 1.5,
      height: heightVar / 18,
      padding: EdgeInsets.only(right: widthVar / 70, left: widthVar / 70),
      child: TextField(
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
          prefixIcon: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
          hintText: 'Comments....',
          hintStyle: const TextStyle(fontSize: 15.0, color: Colors.white),
          contentPadding: const EdgeInsets.all(15),
          isDense: true,
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(width: 2, color: Colors.white),
          ),
        ),
        onSubmitted: onTap,
        controller: controller,
      ),
    );
  }
}
