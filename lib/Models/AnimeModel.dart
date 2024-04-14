import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Anime Structure
class AnimeModel {
  String posterUrl;
  String movieName;
  List movieImage;
  String movieType;
  String movieDescription;
  DateTime addedOn;
  String id;
  List downloadUrls;
  String youtubeUrl;
  String releasedOn;
  num rating;
  AnimeModel({
    required this.youtubeUrl,
    required this.rating,
    required this.releasedOn,
    required this.posterUrl,
    required this.movieName,
    required this.movieImage,
    required this.movieType,
    required this.movieDescription,
    required this.addedOn,
    required this.downloadUrls,
    required this.id,
  });
}

// All Function/Method for Anime
class AnimeFunctionClass with ChangeNotifier {
  final dataBaseRef = FirebaseDatabase.instance.ref();

  //all Anime will stored in this list when we fetchData from database
  List<AnimeModel> movieslist = [];

  //Anime list is reversed order
  List<AnimeModel> get getmovielist {
    final reverseList = movieslist.reversed.toList();
    return [...reverseList];
  }

//Add Anime to firebase database
  Future<void> addnewmovie(AnimeModel _newmovie) async {
    final recNode = dataBaseRef.child('Anime').push();
    final nodeKey = recNode.key!;
    try {
      await recNode.set(
        {
          'posterUrl': _newmovie.posterUrl,
          'movieName': _newmovie.movieName,
          'movieImage': _newmovie.movieImage,
          'movieType': _newmovie.movieType,
          'movieDescription': _newmovie.movieDescription,
          'addedOn': _newmovie.addedOn.toString(),
          'downloadUrls': _newmovie.downloadUrls,
          'releasedOn': _newmovie.releasedOn,
          'rating': _newmovie.rating,
          'youtubeUrl': _newmovie.youtubeUrl,
        },
      );

      final _newFlim = AnimeModel(
        rating: _newmovie.rating,
        releasedOn: _newmovie.releasedOn,
        youtubeUrl: _newmovie.youtubeUrl,
        posterUrl: _newmovie.posterUrl,
        movieName: _newmovie.movieName,
        movieImage: _newmovie.movieImage,
        movieType: _newmovie.movieType,
        movieDescription: _newmovie.movieDescription,
        addedOn: _newmovie.addedOn,
        downloadUrls: _newmovie.downloadUrls,
        id: nodeKey,
      );
      movieslist.add(_newFlim);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

//Fetch all Anime from firebase database
  Future<void> FetchData() async {
    final Url = Uri.parse(
      'https://movies-4c160-default-rtdb.asia-southeast1.firebasedatabase.app/Anime.json',
    );
    try {
      final response = await http.get(Url);
      final extracteddata = json.decode(response.body) as Map<String, dynamic>;
      final List<AnimeModel> LoadMovies = [];
      extracteddata.forEach(
        (key, MovieData) {
          LoadMovies.add(
            AnimeModel(
              id: key,
              posterUrl: MovieData['posterUrl'],
              movieName: MovieData['movieName'],
              movieImage: MovieData['movieImage'],
              movieType: MovieData['movieType'],
              movieDescription: MovieData['movieDescription'],
              addedOn: DateTime.now(),
              downloadUrls: MovieData['downloadUrls'],
              rating: MovieData['rating'],
              releasedOn: MovieData['releasedOn'],
              youtubeUrl: MovieData['youtubeUrl'],
            ),
          );
        },
      );
      movieslist = LoadMovies;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //Search for Anime
  List<AnimeModel> foundUser = [];
  void search(String searchKeyword) {
    List<AnimeModel> searchReasult = [];
    if (searchKeyword.isEmpty) {
      searchReasult = getmovielist;
    } else {
      searchReasult = getmovielist
          .where(
            (user) => user.movieName.toLowerCase().contains(
                  searchKeyword.toLowerCase(),
                ),
          )
          .toList();
    }
    foundUser = searchReasult;
    notifyListeners();
  }

  // AnimeModel get
  List<AnimeModel> get getfound {
    return [...foundUser];
  }

  //Get Anime by Firebase Id
  AnimeModel getByid(String id) {
    return movieslist.firstWhere(
      (movie) {
        return movie.id == id;
      },
    );
  }

  //Edit Anime data
  Future<void> editMovie(String id, AnimeModel editmovieData) async {
    await dataBaseRef.child('Anime/$id').update({
      'posterUrl': editmovieData.posterUrl,
      'movieName': editmovieData.movieName,
      'movieImage': editmovieData.movieImage,
      'movieType': editmovieData.movieType,
      'movieDescription': editmovieData.movieDescription,
      'addedOn': editmovieData.addedOn.toString(),
      'downloadUrls': editmovieData.downloadUrls,
      'releasedOn': editmovieData.releasedOn,
      'rating': editmovieData.rating,
      'youtubeUrl': editmovieData.youtubeUrl,
    });
    await FetchData();
    notifyListeners();
  }
// Delete Anime From firebase database

  Future<void> deleteMovie(String id) async {
    final existingmovieIndex = movieslist.indexWhere((movie) => movie.id == id);
    movieslist.removeAt(existingmovieIndex);
    await dataBaseRef.child('Anime/$id').remove();
    notifyListeners();
    ;
  }
}
