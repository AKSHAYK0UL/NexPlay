import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nex_movies/Models/WebSeriesModel.dart';
import 'package:nex_movies/Widgets/WebseriesINPUT.dart';
import 'package:provider/provider.dart';

import '../Widgets/WebSeriesGridviewWidget.dart';

class SerialHomeScreen extends StatefulWidget {
  const SerialHomeScreen({super.key});
  static const routeName = 'SerialHomeScreen';

  @override
  State<SerialHomeScreen> createState() => _SerialHomeScreenState();
}

class _SerialHomeScreenState extends State<SerialHomeScreen> {
  bool _isloading = false;

  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    Provider.of<WebSeriesFunctionClass>(context, listen: false)
        .FetchData()
        .then(
      (_) {
        setState(
          () {
            _isloading = false;
          },
        );
      },
    ).then((value) {
      Provider.of<WebSeriesFunctionClass>(context, listen: false).search('');
    }).catchError(
      (error) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Network error'),
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
      },
    );
    _controller.addListener(
      () {
        Future.delayed(
          Duration.zero,
          () {
            Provider.of<WebSeriesFunctionClass>(context, listen: false)
                .search(_controller.text);
          },
        );
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _movieOBJECT =
        Provider.of<WebSeriesFunctionClass>(context, listen: true);
    final _reverselist = _movieOBJECT.getmovielist.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text(
          'Web Series',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          if (FirebaseAuth.instance.currentUser!.uid ==
              'TuvybxINm7S1o6ifkneSu4odd0e2')
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(WebseriesINPUT.routeName);
              },
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await Provider.of<WebSeriesFunctionClass>(context,
                        listen: false)
                    .FetchData()
                    .then(
                  (value) {
                    _movieOBJECT.search('');
                    _controller.clear();
                  },
                );
              },
              child: Column(
                children: [
                  // Container(
                  //   margin: EdgeInsets.all(6),
                  //   height: 200,
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(15),
                  //       color: Colors.blue),
                  // ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    height: MediaQuery.of(context).size.height * 0.063,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(left: 20),
                        labelText: 'Search',
                        labelStyle:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Colors.black54, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                      controller: _controller,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: _movieOBJECT.foundUser.isEmpty
                        ? Center(
                            child: Text(
                              'No Web Series Found!',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              childAspectRatio: 0.74,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            // itemCount: _movieOBJECT.foundUser.isEmpty
                            //     ? _movieOBJECT.getmovielist.length
                            //     : _movieOBJECT.foundUser.length,
                            itemCount: _movieOBJECT.getfound.length,
                            itemBuilder: (context, index) {
                              var getmovie;
                              // _movieOBJECT.getfound.isNotEmpty
                              //     ? getmovie = _movieOBJECT.getfound[index]
                              //     : getmovie = _movieOBJECT.getmovielist[index];
                              getmovie = _movieOBJECT.foundUser[index];

                              return WebSeriesGridviewWidget(
                                poster: getmovie.posterUrl,
                                name: getmovie.movieName,
                                pics: getmovie.movieImage,
                                desp: getmovie.movieDescription,
                                type: getmovie.movieType,
                                releaseDate: getmovie.releasedOn,
                                youtubelink: getmovie.youtubeUrl,
                                downurls: getmovie.downloadUrls,
                                rating: getmovie.rating,
                                id: getmovie.id,
                                conttrollerClear: _controller,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
