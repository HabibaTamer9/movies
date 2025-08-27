import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies/pages/movie_details.dart';
import 'package:http/http.dart' as http;

import '../pages/data.dart';

class CardList extends StatefulWidget {
  const CardList({super.key, required this.movie, this.listName});

  final List movie;

  final String? listName;

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  late int runtime;

  late List genres;

  Future<void> getMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$appApi&language=en-US'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      runtime = data['runtime'] ?? 0;
      genres = data['genres'] ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.3,
      width: width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.movie.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () async {
                await getMovieDetails(widget.movie[i]["id"]);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MovieDetails(
                              movie: widget.movie,
                              i: i,
                              runtime: runtime,
                              genres: genres,
                              listName: widget.listName,
                            )));
              },
              child: Container(
                width: width * 0.3,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: "movie_${widget.movie[i]["id"]}_${widget.listName}",
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        height: height * 0.2,
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w500/${widget.movie[i]["backdrop_path"]}",
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null)
                              return child; // الصورة خلصت تحميل
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(Icons.broken_image,
                                  size: 40, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                    Hero(
                      tag:
                          "movie_${widget.movie[i]["title"]}_${widget.listName}",
                      child: Text(
                        widget.movie[i]["title"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      "⭐ ${widget.movie[i]["vote_average"]}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
