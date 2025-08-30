import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class Movie {
  String title;
  String images;

  Movie(this.title, this.images);
}

String appApi = "e5ad62e9c717f4015e22c0dfc8eda432";

double height = 0;

double width = 0;

size(context) {
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
}

fetchPopular() async {
  var response = await http.get(Uri.parse(
      "https://api.themoviedb.org/3/movie/popular?api_key=e5ad62e9c717f4015e22c0dfc8eda432"));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    popularMovies = body["results"];
    print("1");
  } else {
    popularMovies = movies;
  }
}

fetchNew() async {
  var response = await http.get(Uri.parse(
      "https://api.themoviedb.org/3/movie/now_playing?api_key=e5ad62e9c717f4015e22c0dfc8eda432"));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    newMovies = body["results"];
    print("2");
  } else {
    newMovies = movies;
  }
}

fetchTop() async {
  var response = await http.get(Uri.parse(
      "https://api.themoviedb.org/3/movie/top_rated?api_key=e5ad62e9c717f4015e22c0dfc8eda432"));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    topMovies = body["results"];
    print("3");
  } else {
    topMovies = movies;
  }
}

fetchData() async {
  await fetchNew();
  await fetchPopular();
  await fetchTop();
  print("4");
}

List popularMovies = [];

List newMovies = [];

List topMovies = [];

List resultSearch = [];

Map video = {};

List<Movie> movies = [
  Movie(
    "Legend of the blue sea",
    "https://i.pinimg.com/736x/df/47/76/df47763fa38fae7d534be4772248f29a.jpg",
  ),
  Movie(
    "The Thing",
    "https://i.pinimg.com/1200x/e5/2e/f9/e52ef9ec231fc0f68fe46c4a69c814ab.jpg",
  ),
  Movie(
    "The Great Wall 2",
    "https://i.pinimg.com/736x/38/15/25/3815257e6928b72bc4066c6b3d93d1ba.jpg",
  ),
  Movie(
    "Brave",
    "https://i.pinimg.com/736x/93/d4/ab/93d4ab4c3bf7952ebe9e5ec23aa1b4c9.jpg",
  ),
];
List moviesImage = [
  "https://i.pinimg.com/1200x/e5/2e/f9/e52ef9ec231fc0f68fe46c4a69c814ab.jpg",
  "https://i.pinimg.com/736x/38/15/25/3815257e6928b72bc4066c6b3d93d1ba.jpg",
  "https://i.pinimg.com/736x/93/d4/ab/93d4ab4c3bf7952ebe9e5ec23aa1b4c9.jpg",
];

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return "$minutes:$seconds";
}

String formatTime(int duration) {
  final int hours = (duration / 60).toInt();
  final minutes = duration % 60;
  return "$hours h $minutes m";
}
