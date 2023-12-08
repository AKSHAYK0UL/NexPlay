import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Coming Soon Structure
class CommingSoonModel {
  String movieName;
  String posterUrl;
  String storyline;
  String releasedOn;
  String Geners;
  String trailer;
  List images;
  String? id;
  CommingSoonModel({
    required this.Geners,
    required this.movieName,
    required this.posterUrl,
    required this.storyline,
    required this.releasedOn,
    required this.trailer,
    required this.images,
    this.id,
  });
}

// All Function/Method for Coming Soon
class CommingSoonModelFunction with ChangeNotifier {
  final dataBaseRef = FirebaseDatabase.instance.ref();

  //all Coming Soon  will stored in this list when we fetchData from database
  List<CommingSoonModel> commingSoonMovies = [];

//Add Coming Soon  to firebase database
  Future<void> addCommingSoon(CommingSoonModel soonMovie) async {
    final recNode = dataBaseRef.child('CommingSoon').push();
    final nodeKey = recNode.key!;
    try {
      await recNode.set(
        {
          'Movie Name': soonMovie.movieName,
          'ReleasedOn': soonMovie.releasedOn,
          'PosterUrl': soonMovie.posterUrl,
          'Trailer': soonMovie.trailer,
          'Geners': soonMovie.Geners,
          'StoryLine': soonMovie.storyline,
          'Images': soonMovie.images,
        },
      );
      final _newCommindsoon = CommingSoonModel(
        Geners: soonMovie.Geners,
        movieName: soonMovie.movieName,
        posterUrl: soonMovie.posterUrl,
        storyline: soonMovie.storyline,
        releasedOn: soonMovie.releasedOn,
        trailer: soonMovie.trailer,
        images: soonMovie.images,
        id: nodeKey,
      );
      commingSoonMovies.add(_newCommindsoon);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

//Fetch all Coming Soon  from firebase database
  Future<void> FetchData() async {
    final Url = Uri.parse(
        'https://movies-4c160-default-rtdb.asia-southeast1.firebasedatabase.app/CommingSoon.json');
    try {
      final response = await http.get(Url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<CommingSoonModel> _movies = [];
      extractData.forEach((key, CommingSoonMODEL) {
        _movies.add(CommingSoonModel(
            id: key,
            Geners: CommingSoonMODEL['Geners'],
            movieName: CommingSoonMODEL['Movie Name'],
            posterUrl: CommingSoonMODEL['PosterUrl'],
            releasedOn: CommingSoonMODEL['ReleasedOn'],
            storyline: CommingSoonMODEL['StoryLine'],
            trailer: CommingSoonMODEL['Trailer'],
            images: CommingSoonMODEL['Images']));
      });
      commingSoonMovies = _movies;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //Get Coming Soon by Firebase Id
  CommingSoonModel getById(String id) {
    return commingSoonMovies.firstWhere((element) => element.id == id);
  }

  //Edit Coming Soon data
  Future<void> editCommingSoon(String id, CommingSoonModel soonMovie) async {
    try {
      await dataBaseRef.child('CommingSoon/$id').update(
        {
          'Movie Name': soonMovie.movieName,
          'ReleasedOn': soonMovie.releasedOn,
          'PosterUrl': soonMovie.posterUrl,
          'Trailer': soonMovie.trailer,
          'Geners': soonMovie.Geners,
          'StoryLine': soonMovie.storyline,
          'Images': soonMovie.images,
        },
      );
      await FetchData();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

// Delete Coming Soon From firebase database
  Future<void> deleteCommingSoon(String id) async {
    try {
      await dataBaseRef.child('CommingSoon/$id').remove();
      await FetchData();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
