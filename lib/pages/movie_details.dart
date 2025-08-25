import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies/pages/trailer.dart';
import 'package:movies/widget/content_text.dart';
import 'package:movies/widget/decoration.dart';

import 'data.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key, required this.movie, required this.i, required this.runtime, required this.genres, this.listName});
  final List movie ;
  final String? listName ;
  final int i ;
  final int runtime ;
  final List genres ;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  String message = "Start watch";
  getVideo() async{
    var response = await http.get(Uri.parse("https://api.themoviedb.org/3/movie/${widget.movie[widget.i]["id"]}/videos?api_key=$appApi"));
    if(response.statusCode == 200){
      var body = jsonDecode(response.body );
      var list = body["results"];
      for(var item in list){
        if(item["type"] == "Trailer" && item["site"] == "YouTube"){
          video = item ;
          break;
        }
      }
      if(video.isEmpty){
        for(var item in list){
          if(item["type"] == "Teaser" && item["site"] == "YouTube"){
            setState(() {});
            video = item ;
            break;
          }
        }
      }
      if(video.isEmpty) {
        setState(() {
          message = "Soon";
        });
      }
    }else {
      setState(() {
        message = "Soon";
      });
    }
    await getSimilarMovies();
  }
  List similar = [];
  Future<void> getSimilarMovies() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=$appApi&with_genres=${widget.genres[widget.genres.length-1]["id"]}&language=en-US&page=1'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      similar = data['results'];
    }
  }
  waiting()async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    await getVideo();
    Navigator.of(context).pop();
  }
  String image = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff021e2c),
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Hero(
              tag: "movie_${widget.movie[widget.i]["id"]}_${widget.listName}",
              child: Container(
                height: height * 0.5,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage("https://image.tmdb.org/t/p/w500/${widget.movie[widget.i]["backdrop_path"]}"),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: height*0.75,
                width: width,
                decoration: BackGround().homeDecoration(),
              ),
            ),
            Positioned(
              top: height*0.05,
              left: width*0.05,
              right: width*0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white60,),
                    onPressed: () { Navigator.pop(context);},
                  ),
                ],
              ),
            ),
            Positioned(
              top: height*0.45,
              left: width*0.05,
              right: 2,
              bottom: height*0.1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width : width,
                      margin: EdgeInsets.only(bottom: 12),
                      child: Wrap(
                        children: [
                          Hero(
                            tag: "movie_${widget.movie[widget.i]["title"]}_${widget.listName}",
                            child: ContentText(
                              text: widget.movie[widget.i]["title"],
                              white: true,
                              size: width*0.09,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ContentText(
                              text: widget.movie[widget.i]["release_date"].toString().substring(0, 4),
                              white: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      children: [
                        ContentText(text: "Genres: ", white: true,),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: ContentText(
                            text: " ${widget.genres.map((g) => g['name']).join(' , ')}",
                            white: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height*0.005,),
                    Row(
                      children: [
                        ContentText(
                          text: "⭐  ${double.parse(widget.movie[widget.i]["vote_average"].toString()).toStringAsFixed(1)}",
                          white: true,
                        ),
                        SizedBox(width: 10,),
                        ContentText(
                          text: "from ${widget.movie[widget.i]["vote_count"]} users",
                          white: false,
                        ),
                      ],
                    ),
                    SizedBox(height: height*0.005,),
                    ContentText(
                      text: "🌍  Language : ${widget.movie[widget.i]["original_language"]}",
                      white: false,
                    ),
                    SizedBox(height: height*0.005,),
                    ContentText(
                      text: "⏱  Time : ${widget.runtime} minutes",
                      white: false,
                    ),
                    SizedBox(height: height*0.04,),
                    ContentText(
                      text: widget.movie[widget.i]["overview"],
                      white: false,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: height * 0.02,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(child: CircularProgressIndicator()),
                    );
                    await getVideo();
                    Navigator.of(context).pop();
                    if(message != "Soon"){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Trailer(movie: widget.movie[widget.i],similar: similar,)));
                    }
                  },
                  child: Container(
                    height: 50,
                    width: width * 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff075a61),
                          Colors.purple
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
