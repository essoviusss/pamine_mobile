import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);
  final Widget icon;
  final String text;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    double heightVar = MediaQuery.of(context).size.height;
    double widthVar = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 20),
            Expanded(
                child: Text(
              text,
              style: const TextStyle(color: Colors.black),
            )),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFC21010),
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}
