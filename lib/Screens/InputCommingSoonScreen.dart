import 'package:flutter/material.dart';
import 'package:nex_movies/Models/CommingSoonModel.dart';
import 'package:nex_movies/main.dart';
import 'package:provider/provider.dart';

import '../Widgets/EditInputFieldWidget.dart';

class InputCommingSoonScreen extends StatefulWidget {
  const InputCommingSoonScreen({super.key});
  static const routeName = 'InputCommingSoonScreen';

  @override
  State<InputCommingSoonScreen> createState() => _InputCommingSoonScreenState();
}

class _InputCommingSoonScreenState extends State<InputCommingSoonScreen> {
  final _commingSoon = CommingSoonModel(
    movieName: '',
    posterUrl: '',
    storyline: '',
    releasedOn: '',
    trailer: '',
    Geners: '',
    images: [],
  );
  bool _istrue = true;
  var movieId;
  CommingSoonModel? _editmovie;
  @override
  void didChangeDependencies() {
    if (_istrue) {
      movieId = ModalRoute.of(context)!.settings.arguments as String?;
      if (movieId != null) {
        _editmovie =
            Provider.of<CommingSoonModelFunction>(context, listen: false)
                .getById(movieId);
      }
    }
    _istrue = false;
    super.didChangeDependencies();
  }

  final _formKey = GlobalKey<FormState>();
  Future<void> OnClickSave() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      if (movieId == null) {
        await Provider.of<CommingSoonModelFunction>(context, listen: false)
            .addCommingSoon(_commingSoon);
      } else {
        await Provider.of<CommingSoonModelFunction>(context, listen: false)
            .editCommingSoon(movieId, _commingSoon);
      }
    } catch (error) {
      showDialog(
        context: navigatorkey.currentContext!,
        builder: (context) {
          return AlertDialog(
            title: const Text('Something went wrong!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              )
            ],
          );
        },
      );
    } finally {
      navigatorkey.currentState!.pop();
      navigatorkey.currentState!.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Coming Soon'),
        actions: [
          IconButton(
            onPressed: () {
              OnClickSave();
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Data';
                    }
                    return null;
                  },
                  initialValue: movieId != null ? _editmovie!.movieName : null,
                  decoration: InputDecoration(
                      labelText: 'Movie name',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      )),
                  onSaved: (newValue) {
                    _commingSoon.movieName = newValue!;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Data';
                    }
                    return null;
                  },
                  initialValue: movieId != null ? _editmovie!.Geners : null,
                  decoration: InputDecoration(
                    labelText: 'Movie Type',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onSaved: (newValue) {
                    _commingSoon.Geners = newValue!;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Data';
                    }
                    return null;
                  },
                  initialValue: movieId != null ? _editmovie!.releasedOn : null,
                  decoration: InputDecoration(
                    labelText: 'Released On',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onSaved: (newValue) {
                    _commingSoon.releasedOn = newValue!;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Data';
                    }
                    return null;
                  },
                  initialValue: movieId != null ? _editmovie!.posterUrl : null,
                  decoration: InputDecoration(
                    labelText: 'Poster Url',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onSaved: (newValue) {
                    _commingSoon.posterUrl = newValue!;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Data';
                    }
                    return null;
                  },
                  initialValue: movieId != null ? _editmovie!.trailer : null,
                  decoration: InputDecoration(
                    labelText: 'Trailer Url',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onSaved: (newValue) {
                    _commingSoon.trailer = newValue!;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Data';
                    }
                    return null;
                  },
                  initialValue: movieId != null ? _editmovie!.storyline : null,
                  decoration: InputDecoration(
                    labelText: 'Storyline',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onSaved: (newValue) {
                    _commingSoon.storyline = newValue!;
                  },
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue,
                    ),
                    child: Column(
                      children: [
                        ..._editmovie!.images.map(
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
                      return 'Enter Data';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'images',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  maxLines: 5,
                  onSaved: (newValue) {
                    if (newValue!.isEmpty && movieId != null) {
                      _commingSoon.images = _editmovie!.images;
                    } else {
                      var ele = newValue;
                      ele.split(',').forEach(
                        (element) {
                          _commingSoon.images.add(element);
                        },
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
