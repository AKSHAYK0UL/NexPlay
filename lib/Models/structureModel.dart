import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Movie Structure
class MovieModel {
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
  MovieModel({
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

// All Function/Method for Movies
class MovieFunctionClass with ChangeNotifier {
  final dataBaseRef = FirebaseDatabase.instance.ref();
  //all moveies will stored in this list when we fetchData from database
  List<MovieModel> movieslist = [];

  //Movie list is reversed order
  List<MovieModel> get getmovielist {
    final reverseList = movieslist.reversed.toList();
    return [...reverseList];
  }

//Add movie to firebase database
  Future<void> addnewmovie(MovieModel _newmovie) async {
    final recNode = dataBaseRef.child('Movies').push();
    final nodeKey = recNode.key!;
    try {
      await recNode.set({
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
      });
      final _newFlim = MovieModel(
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

//Fetch all Movies from firebase database
  Future<void> FetchData() async {
    final Url = Uri.parse(
      'https://movies-4c160-default-rtdb.asia-southeast1.firebasedatabase.app/Movies.json',
    );
    try {
      final response = await http.get(Url);
      final extracteddata = json.decode(response.body) as Map<String, dynamic>;
      final List<MovieModel> LoadMovies = [];
      extracteddata.forEach(
        (key, MovieData) {
          LoadMovies.add(
            MovieModel(
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

  //Search for Movie
  List<MovieModel> foundUser = [];
  void search(String searchKeyword) {
    List<MovieModel> searchReasult = [];
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

  // MovieModel get
  List<MovieModel> get getfound {
    return [...foundUser];
  }

  //Get Movies by Firebase Id
  MovieModel getByid(String id) {
    return movieslist.firstWhere(
      (movie) {
        return movie.id == id;
      },
    );
  }

  //Edit Movie data
  Future<void> editMovie(String id, MovieModel editmovieData) async {
    await dataBaseRef.child('Movies/$id').update({
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

// Delete Movie From firebase database
  Future<void> deleteMovie(String id) async {
    final existingmovieIndex = movieslist.indexWhere((movie) => movie.id == id);
    movieslist.removeAt(existingmovieIndex);
    await dataBaseRef.child('Movies/$id').remove();
    notifyListeners();
  }
}
