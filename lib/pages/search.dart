import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies/pages/data.dart';
import 'package:movies/pages/movie_details.dart';
import 'package:movies/widget/background.dart';
import 'package:http/http.dart' as http;

class Search extends SearchDelegate {
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
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xff05364e), // الخلفية
        iconTheme: IconThemeData(color: Colors.white), // الأيقونات
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70), // لون الـ hint
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.white), // لون الكتابة
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    fetchSearch(query);
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BackGround().decoration(),
        ),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            mainAxisExtent: 230
          ),
          itemCount: resultSearch.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () async {
                await getMovieDetails(resultSearch[i]["id"]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetails(
                      movie: resultSearch,
                      i: i,
                      runtime: runtime,
                      genres: genres,
                      listName: "resultSearch",
                    )
                  )
                );
              },
              child: Container(
                width: width * 0.3,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: "movie_${resultSearch[i]["id"]}_resultSearch",
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        height: height * 0.2,
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w500/${resultSearch[i]["backdrop_path"]}",
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child; // الصورة خلصت تحميل
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
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
                      tag: "movie_${resultSearch[i]["title"]}_resultSearch",
                      child: Text(
                        resultSearch[i]["title"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      "⭐ ${resultSearch[i]["vote_average"]}",
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
          }
        )
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    fetchSearch(query);
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BackGround().decoration(),
        )
      ],
    );
  }
}
