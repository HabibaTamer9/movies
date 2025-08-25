import 'package:flutter/material.dart';
import 'package:movies/pages/data.dart';
import 'package:movies/widget/content_text.dart';
import 'package:movies/widget/decoration.dart';
import 'package:movies/widget/list_title.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../widget/card_list.dart';

class Trailer extends StatefulWidget {
  const Trailer({super.key, required this.movie, required this.similar,});
  final Map movie ;
  final List similar;

  @override
  State<Trailer> createState() => _TrailerState();
}

class _TrailerState extends State<Trailer> {

  // Future<void> review() async {
  //   var response = await http.get(Uri.parse("https://api.themoviedb.org/3/tv/${widget.movie['id']}/reviews?api_key=$appApi"));
  //   if(response.statusCode == 200) {
  //     var body = jsonDecode(response.body);
  //     var list = body["results"];
  //   }
  // }
  final YoutubePlayerController _controller = YoutubePlayerController(initialVideoId: video['key'],
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
    ),
  );

  Duration _videoDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final newDuration = _controller.metadata.duration;
      if (newDuration != _videoDuration) {
        setState(() {
          _videoDuration = newDuration;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Color(0xff021e2c),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: height * 0.6,
                    width: width,
                    decoration: BackGround().homeDecoration(),
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    child: player
                ),
                Positioned(
                  top: height * 0.42,
                  left: width * 0.05,
                  right: 2,
                  bottom: 0,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width,
                          margin: EdgeInsets.only(bottom: 12),
                          child: ContentText(
                            text: widget.movie["title"],
                            white: true,
                            size: width * 0.09,
                          ),
                        ),
                        Row(
                          children: [
                            ContentText(
                              text: "⭐  ${double.parse(
                                  widget.movie["vote_average"].toString())
                                  .toStringAsFixed(1)}",
                              white: true,
                            ),
                            SizedBox(width: 10,),
                            ContentText(
                              text: "from ${widget.movie["vote_count"]} users",
                              white: false,
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.005,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ContentText(
                              text: "🌍  Language : ${widget
                                  .movie["original_language"]}",
                              white: false,
                              size: width * 0.045,
                            ),
                            SizedBox(height: height * 0.005,),
                            ContentText(
                              text: "⏱  Time :  ${formatDuration(
                                  _videoDuration)} min",
                              white: false,
                              size: width * 0.045,
                            ),
                            SizedBox(width: 10,),
                          ],
                        ),
                        SizedBox(height: 20,),
                        ListTitle(name: "Related movies ",),
                        SizedBox(height: 10,),
                        CardList(movie: widget.similar),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
