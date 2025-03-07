part of 'services.dart';

class MovieServices {
  static Future<List<Movie>> getMovies(int page, {http.Client? client}) async {
    String url =
        "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page";

    client ??= http.Client();

    var response = await client.get(Uri.parse(url));

    if (response.statusCode != 200) {
      return [];
    }

    var data = json.decode(response.body) as Map<String, dynamic>;
    List<dynamic> result = data['results'] ?? [];

    return result
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<MovieDetail>? getDetails(Movie? movie,
      {int? movieID, http.Client? client}) async {
    String url =
        "https://api.themoviedb.org/3/movie/${movieID ?? movie?.id}?api_key=$apiKey&language=en-US";

    client ??= http.Client();

    var response = await client.get(Uri.parse(url));

    if (response.statusCode != 200) {
      return MovieDetail(null);
    }

    var data = json.decode(response.body) as Map<String, dynamic>;
    List<dynamic> genres = data['genres'] ?? [];
    String language = "Unknown";

    switch (data['original_language'].toString()) {
      case 'ja':
        language = "Japanese";
        break;
      case 'id':
        language = "Indonesian";
        break;
      case 'ko':
        language = "Korean";
        break;
      case 'en':
        language = "English";
        break;
    }

    return movieID != null
        ? MovieDetail(Movie.fromJson(data),
            language: language,
            genres: genres
                .map((e) => (e as Map<String, dynamic>)['name'].toString())
                .toList())
        : MovieDetail(movie,
            language: language,
            genres: genres
                .map((e) => (e as Map<String, dynamic>)['name'].toString())
                .toList());
  }

  static Future<List<Credit>> getCredits(int movieID,
      {http.Client? client}) async {
    String url =
        "https://api.themoviedb.org/3/movie/$movieID/credits?api_key=$apiKey";

    client ??= http.Client();

    var response = await client.get(Uri.parse(url));

    if (response.statusCode != 200) {
      return [];
    }

    var data = json.decode(response.body) as Map<String, dynamic>;
    List<dynamic> cast = data['cast'] ?? [];

    return cast
        .map((e) => Credit(
            name: (e as Map<String, dynamic>)['name'] ?? 'Unknown',
            profilePath: e['profile_path'] ?? ''))
        .take(8)
        .toList();
  }
}
