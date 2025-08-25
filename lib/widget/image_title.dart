import 'package:flutter/material.dart';
import 'package:movies/pages/data.dart';

class ImageTitle extends StatelessWidget {
  const ImageTitle({super.key, required this.selectedMovie});
  final int selectedMovie;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width : width,
          margin: EdgeInsets.only(bottom: 12),
          child: Text(
            movies[selectedMovie].title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: movies.asMap().entries.map((entry) {
            return Container(
              width: 10.0,
              height: 10.0,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selectedMovie == entry.key
                    ? Color(0xff044668)
                    : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
