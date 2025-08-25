import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies/pages/data.dart';

class HomeSlider extends StatelessWidget {
  const HomeSlider({super.key, required this.onChange});
  final Function(int index , CarouselPageChangedReason) onChange ;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: movies.map((item){
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(item.images),
              ),
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: height*0.5,
          aspectRatio: 16/9,
          viewportFraction: 1.05,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(seconds: 3),
          autoPlayCurve: Curves.fastOutSlowIn,
          onPageChanged: onChange,
          scrollDirection: Axis.horizontal,
        )
    );
  }
}
