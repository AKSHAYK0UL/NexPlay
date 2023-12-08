import 'package:flutter/material.dart';
import 'package:nex_movies/Models/WebSeriesModel.dart';
import 'package:nex_movies/Models/storeDeviceTokens.dart';
import 'package:nex_movies/Models/structureModel.dart';
import 'package:provider/provider.dart';

import 'EditInputFieldWidget.dart';
import 'UrlResWidget.dart';

class WebseriesINPUT extends StatefulWidget {
  static const routeName = 'WebseriesINPUT';
  const WebseriesINPUT({super.key});

  @override
  State<WebseriesINPUT> createState() => _WebseriesINPUTState();
}

class _WebseriesINPUTState extends State<WebseriesINPUT> {
  final _imageController = TextEditingController();
  final _linkController = TextEditingController();
  final _resController = TextEditingController();
  final _AddLinkToCurrentController = TextEditingController();
  final _AddresToCurrentController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _isloading = false;
  final _newMovie = WebSeries(
    posterUrl: '',
    movieName: '',
    movieImage: [],
    movieType: '',
    movieDescription: '',
    addedOn: DateTime.now(),
    downloadUrls: [],
    id: '',
    rating: 0.0,
    releasedOn: '',
    youtubeUrl: '',
  );

  var ImageList;
  var movieId;
  bool _istrue = true;
  var _initValue;
  WebSeries? _editmovie;

  @override
  void didChangeDependencies() {
    if (_istrue) {
      movieId = ModalRoute.of(context)!.settings.arguments as String?;
      if (movieId != null) {
        _editmovie = Provider.of<WebSeriesFunctionClass>(context, listen: false)
            .getByid(movieId);

        _initValue = {
          'releaseOn': _editmovie!.releasedOn,
          'rating': _editmovie!.rating.toString(),
          'moviename': _editmovie!.movieName,
          'posterurl': _editmovie!.posterUrl,
          'youtubeurl': _editmovie!.youtubeUrl,
          'movietype': _editmovie!.movieType,
          'moviedesp': _editmovie!.movieDescription,
          'movieimage': _editmovie!.movieImage,
          'download': _editmovie!.downloadUrls,
        };
      }
    }
    _istrue = false;
    super.didChangeDependencies();
  }

  Future<void> addMovies() async {
    final valid = _formkey.currentState!.validate();
    if (!valid) {
      return;
    }
    _formkey.currentState!.save();
    setState(
      () {
        _isloading = true;
      },
    );

    try {
      if (movieId == null) {
        await Provider.of<WebSeriesFunctionClass>(context, listen: false)
            .addnewmovie(_newMovie)
            .then(
              (value) =>
                  Provider.of<WebSeriesFunctionClass>(context, listen: false)
                      .search(''),
            )
            .then((value) async {
          await Provider.of<DeviceTokens>(context, listen: false)
              .sendNotification('New Web series added', _newMovie.movieName);
        });
      } else {
        await Provider.of<WebSeriesFunctionClass>(context, listen: false)
            .editMovie(movieId, _newMovie)
            .then(
              (value) =>
                  Provider.of<WebSeriesFunctionClass>(context, listen: false)
                      .search(''),
            )
            .then((value) => Navigator.of(context).pop());
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('An error occured!'),
            content: const Text('Something went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(
        () {
          _isloading = false;
        },
      );
      Navigator.of(context).pop();
    }
  }

  bool _isempty = false;
  void Urllink(String res, String url) {
    Map<String, String> linkres = {'res': res, 'url': url};

    _newMovie.downloadUrls.add(linkres);

    _resController.clear();
    _linkController.clear();
  }

  void NEWUrllink(String res, String url) {
    Map<String, String> linkres = {'res': res, 'url': url};
    _editmovie!.downloadUrls.add(linkres);
    _AddresToCurrentController.clear();
    _AddLinkToCurrentController.clear();
  }

  final _controller = TextEditingController();
  bool editurl = false;
  bool editimage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Add Web Series'),
        actions: [
          IconButton(
              onPressed: () {
                addMovies();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter data';
                                }
                                return null;
                              },
                              initialValue: movieId != null
                                  ? _initValue['releaseOn']
                                  : null,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.movie,
                                  color: Colors.black,
                                  size: 27,
                                ),
                                labelText: 'Release On',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  ),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.red),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  ),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.red),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  ),
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.grey.shade400),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  ),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.black),
                                ),
                              ),
                              onSaved: (newValue) =>
                                  _newMovie.releasedOn = newValue!,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter data';
                                }
                                return null;
                              },
                              initialValue:
                                  movieId != null ? _initValue['rating'] : null,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.movie,
                                  color: Colors.black,
                                  size: 27,
                                ),
                                labelText: 'Rating',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.red),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.red),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.grey.shade400),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.black),
                                ),
                              ),
                              onSaved: (newValue) =>
                                  _newMovie.rating = double.parse(newValue!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter data';
                          }
                          return null;
                        },
                        initialValue:
                            movieId != null ? _initValue['moviename'] : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.movie,
                            color: Colors.black,
                            size: 27,
                          ),
                          labelText: 'Movie Name',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                width: 2, color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        onSaved: (newValue) => _newMovie.movieName = newValue!,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter data';
                          }
                          return null;
                        },
                        initialValue:
                            movieId != null ? _initValue['posterurl'] : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.movie,
                            color: Colors.black,
                            size: 27,
                          ),
                          labelText: 'Poster Url',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                width: 2, color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        onSaved: (newValue) =>
                            _newMovie.posterUrl = newValue!.trim(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter data';
                          }
                          return null;
                        },
                        initialValue:
                            movieId != null ? _initValue['youtubeurl'] : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.movie,
                            color: Colors.black,
                            size: 27,
                          ),
                          labelText: 'Youtube Url',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                width: 2, color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        onSaved: (newValue) =>
                            _newMovie.youtubeUrl = newValue!.trim(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter data';
                          }
                          return null;
                        },
                        initialValue:
                            movieId != null ? _initValue['movietype'] : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.movie,
                            color: Colors.black,
                            size: 27,
                          ),
                          labelText: 'Movie Type',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                width: 2, color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        onSaved: (newValue) => _newMovie.movieType = newValue!,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter data';
                          }
                          return null;
                        },
                        initialValue:
                            movieId != null ? _initValue['moviedesp'] : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.movie,
                            color: Colors.black,
                            size: 27,
                          ),
                          labelText: 'Movie Description',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                width: 2, color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        onSaved: (newValue) =>
                            _newMovie.movieDescription = newValue!,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (movieId != null)
                        const Text(
                          '  Current Images:',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (movieId != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 4),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
                          ),
                          child: Column(
                            children: [
                              ..._editmovie!.movieImage.map(
                                (e) => EditInputWidget(e),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty && movieId == null) {
                            return 'Enter data';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.movie,
                            color: Colors.black,
                            size: 27,
                          ),
                          labelText: 'Movie Images',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                width: 2, color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        maxLines: 5,
                        onSaved: (newValue) {
                          if (newValue!.isEmpty && movieId != null) {
                            _newMovie.movieImage = _editmovie!.movieImage;
                          } else if (newValue.isNotEmpty && movieId != null) {
                            var el = newValue;
                            el.split(',').forEach(
                              (element) {
                                _newMovie.movieImage.add(element);
                              },
                            );
                          } else {
                            var el = newValue;
                            el.split(',').forEach(
                              (element) {
                                _newMovie.movieImage.add(element);
                              },
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (movieId != null)
                        const Text(
                          '  Current Download Links:',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (movieId != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 4),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
                          ),
                          child: Column(
                            children: [
                              ..._editmovie!.downloadUrls.map(
                                (e) => UrlResWidget(
                                  res: e['res'],
                                  urllink: e['url'],
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.movie,
                            color: Colors.black,
                            size: 27,
                          ),
                          labelText: 'Resolution',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                width: 2, color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        controller: _resController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.movie,
                            color: Colors.black,
                            size: 27,
                          ),
                          labelText: 'Download Url',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                width: 2, color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        controller: _linkController,
                        maxLines: 5,
                        onSaved: (newvalue) {
                          if (_newMovie.downloadUrls.isEmpty &&
                              movieId != null) {
                            _newMovie.downloadUrls = _editmovie!.downloadUrls;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (_isempty)
                        Text(
                          "   Enter data",
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_resController.text.isEmpty &&
                                _linkController.text.isEmpty &&
                                movieId != null) {
                              _newMovie.downloadUrls = _editmovie!.downloadUrls;
                            } else if (_resController.text.isNotEmpty &&
                                _linkController.text.isNotEmpty &&
                                movieId != null) {
                              _editmovie!.downloadUrls.clear();
                              Urllink(
                                _resController.text,
                                _linkController.text.trim(),
                              );
                              setState(() {
                                _isempty = false;
                              });
                            } else if (_resController.text.isNotEmpty &&
                                _linkController.text.isNotEmpty) {
                              Urllink(
                                _resController.text,
                                _linkController.text.trim(),
                              );
                              setState(() {
                                _isempty = false;
                              });
                            } else {
                              setState(() {
                                _isempty = true;
                              });
                            }
                          },
                          child: const Text('Add Url link'),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      movieId == null
                          ? Container()
                          : TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.movie,
                                  color: Colors.black,
                                  size: 27,
                                ),
                                labelText: 'Resolution',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.red),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.red),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.grey.shade400),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.black),
                                ),
                              ),
                              controller: _AddresToCurrentController,
                            ),
                      const SizedBox(
                        height: 15,
                      ),
                      movieId == null
                          ? Container()
                          : TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.movie,
                                  color: Colors.black,
                                  size: 27,
                                ),
                                labelText: 'Download Url',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.red),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.red),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.grey.shade400),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.black),
                                ),
                              ),
                              controller: _AddLinkToCurrentController,
                              maxLines: 5,
                              // onSaved: (newvalue) {
                              //   if (_newMovie.downloadUrls.isNotEmpty) {
                              //     Urllink(
                              //       _AddresToCurrentController.text,
                              //       _AddLinkToCurrentController.text.trim(),
                              //     );
                              //   }
                              // },
                            ),
                      const SizedBox(
                        height: 8,
                      ),
                      movieId == null
                          ? Container()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_AddLinkToCurrentController
                                          .text.isEmpty &&
                                      _AddresToCurrentController.text.isEmpty) {
                                    _newMovie.downloadUrls =
                                        _editmovie!.downloadUrls;
                                  } else if (_AddresToCurrentController
                                          .text.isNotEmpty &&
                                      _AddLinkToCurrentController
                                          .text.isNotEmpty) {
                                    NEWUrllink(
                                      _AddresToCurrentController.text,
                                      _AddLinkToCurrentController.text.trim(),
                                    );
                                  }
                                },
                                child:
                                    const Text('Add Url link to current list'),
                              ),
                            ),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
