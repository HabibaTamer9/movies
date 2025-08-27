import 'package:flutter/material.dart';
import 'package:movies/pages/data.dart';
import 'package:movies/pages/search.dart';
import 'package:movies/widget/card_list.dart';
import 'package:movies/widget/background.dart';
import 'package:movies/widget/image_title.dart';
import 'package:movies/widget/list_title.dart';
import 'package:movies/widget/slider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController controller = PageController();
  int selectedMovie = 0;

  ScrollController scrollController = ScrollController();
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    scrollController.addListener(() {
      double offset = scrollController.offset;
      double newOpacity = (offset / 200).clamp(0.0, 1.0);
      setState(() {
        opacity = newOpacity;
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size(context);
    return Scaffold(
      backgroundColor: Color(0xff021e2c),
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            //slider
            HomeSlider(
              onChange: (index, changer) {
                setState(() {
                  selectedMovie = index;
                });
              },
            ),
            //title $ indicator
            Positioned(
              top: height * 0.35,
              left: width * 0.05,
              child: ImageTitle(selectedMovie: selectedMovie),
            ),
            //backGround animation
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: height * 0.5,
              width: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xff021e2c).withOpacity(opacity),
                    Colors.transparent,
                  ],
                  stops: [2.0, 0.0],
                ),
              ),
            ),
            //AppBar
            Positioned(
              top: height * 0.05,
              left: width * 0.05,
              right: width * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.menu,
                    color: Colors.white60,
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              showSearch(context: context, delegate: Search());
                            });
                          },
                          icon: Icon(
                            Icons.search,
                            color: Colors.white60,
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.notifications_none,
                        color: Colors.white60,
                      ),
                    ],
                  )
                ],
              ),
            ),
            //backGround color
            Positioned(
              bottom: 0,
              child: Container(
                height: height * 0.7,
                width: width,
                decoration: BackGround().homeDecoration(),
              ),
            ),
            //lists
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: height * 0.9,
                padding: EdgeInsets.only(
                  left: width * 0.04,
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.35,
                      ),
                      ListTitle(name: "Top Rate"),
                      CardList(
                        movie: topMovies,
                        listName: "Top_Rate",
                      ),
                      ListTitle(name: "Popular"),
                      CardList(
                        movie: popularMovies,
                        listName: "Popular",
                      ),
                      ListTitle(name: "New"),
                      CardList(
                        movie: newMovies,
                        listName: "New",
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
