import 'package:flutter/material.dart';
import 'package:movies/data.dart';

class ContentText extends StatelessWidget {
  const ContentText(
      {super.key, required this.text, required this.white, this.size});

  final String text;
  final bool white;

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: white ? Colors.white : Colors.grey,
          fontSize: size ?? width * 0.05,
          fontWeight: FontWeight.w600),
    );
  }
}
