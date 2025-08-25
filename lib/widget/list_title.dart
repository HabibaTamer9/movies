import 'package:flutter/material.dart';

class ListTitle extends StatelessWidget {
  const ListTitle({super.key, required this.name});
  final String name ;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600
      ),
    );
  }
}
