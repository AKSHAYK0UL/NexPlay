import 'package:flutter/material.dart';
import 'package:nex_movies/Screens/AnimeDetailScreen.dart';
import '../Screens/MovieDetailScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GridviewWidgetAnime extends StatelessWidget {
  final poster;
  final name;
  final pics;
  final type;
  final desp;
  final youtubelink;
  final releaseDate;
  final downurls;
  final rating;
  final id;
  final conttrollerClear;
  GridviewWidgetAnime({
    required this.id,
    required this.conttrollerClear,
    required this.rating,
    required this.downurls,
    required this.poster,
    required this.name,
    required this.pics,
    required this.type,
    required this.desp,
    required this.releaseDate,
    required this.youtubelink,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(AnimeDetailScreen.routeName, arguments: {
          'name': name,
          'poster': poster,
          'type': type,
          'desp': desp,
          'youtubelink': youtubelink,
          'releaseDate': releaseDate,
          'pics': pics,
          'download': downurls,
          'rating': rating,
          'id': id,
        });

        FocusScope.of(context).unfocus();
        conttrollerClear.clear();
      },
      borderRadius: BorderRadius.circular(15),
      splashColor: Colors.grey,
      child: Card(
        color: Colors.blue.shade50,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: GridTile(
            header: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.035,
              width: double.infinity,
              color: Colors.black54,
              child: Text(
                "Released on $releaseDate",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            footer: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.06,
              color: Colors.black54,
              width: double.infinity,
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            child: FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.fill,
              child: CachedNetworkImage(
                imageUrl: poster,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
