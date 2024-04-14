import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nex_movies/Models/CommingSoonModel.dart';
import 'package:nex_movies/Models/Notificationservice.dart';
import 'package:nex_movies/Models/firebaseFUN.dart';
import 'package:nex_movies/Models/storeDeviceTokens.dart';
import 'package:nex_movies/main.dart';
import 'package:provider/provider.dart';

import '../Models/structureModel.dart';
import '../Widgets/InputWidget.dart';
import 'CommingSoonDetailsScreen.dart';
import 'InputCommingSoonScreen.dart';
import 'MovieDetailScreen.dart';

class NewAddandCommingSoonScreen extends StatefulWidget {
  NewAddandCommingSoonScreen({super.key});
  static const routeName = 'NewAddandCommingSoonScreen';

  @override
  State<NewAddandCommingSoonScreen> createState() =>
      _NewAddandCommingSoonScreenState();
}

class _NewAddandCommingSoonScreenState
    extends State<NewAddandCommingSoonScreen> {
  bool _isLoading = true;
  bool _isloading2 = true;
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    Provider.of<MovieFunctionClass>(context, listen: false)
        .FetchData()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    Provider.of<CommingSoonModelFunction>(context, listen: false)
        .FetchData()
        .then((value) {
      setState(() {
        _isloading2 = false;
      });
    });
    notificationServices.firebaseInit(context);
    notificationServices.backgroundmessage(context);
    notificationServices.requestNotification();
    // notificationServices.getDeviceToken().then((token) {
    //   print('Token : $token');
    // });
    Provider.of<DeviceTokens>(context, listen: false).fetchToken();
    super.initState();
  }

  Widget newAddFun(MovieModel movieInfo) {
    return Card(
      elevation: 10,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).pushNamed(MovieScreen.routeName, arguments: {
            'name': movieInfo.movieName,
            'poster': movieInfo.posterUrl,
            'type': movieInfo.movieType,
            'desp': movieInfo.movieDescription,
            'youtubelink': movieInfo.youtubeUrl,
            'releaseDate': movieInfo.releasedOn,
            'pics': movieInfo.movieImage,
            'download': movieInfo.downloadUrls,
            'rating': movieInfo.rating,
            'id': movieInfo.id,
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            movieInfo.posterUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget commingSoonFun(CommingSoonModel _movie) {
    return Card(
      elevation: 10,
      shadowColor: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context)
              .pushNamed(CommingSoonDetailsScreen.routeName, arguments: {
            'name': _movie.movieName,
            'poster': _movie.posterUrl,
            'type': _movie.Geners,
            'desp': _movie.storyline,
            'youtubelink': _movie.trailer,
            'releaseDate': _movie.releasedOn,
            'pics': _movie.images,
            'id': _movie.id,
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width * .46,
          // margin: const EdgeInsets.symmetric(horizontal: ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              _movie.posterUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signOUT() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Are you sure',
            style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(navigatorkey.currentContext!).pop();
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void Userinfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Account information',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'User email\n${FirebaseAuth.instance.currentUser!.email.toString()}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close  ',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _movieList =
        Provider.of<MovieFunctionClass>(context).movieslist.reversed.toList();
    final _commingSoon =
        Provider.of<CommingSoonModelFunction>(context).commingSoonMovies;

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (FirebaseAuth.instance.currentUser!.uid ==
              'TuvybxINm7S1o6ifkneSu4odd0e2')
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(InputCommingSoonScreen.routeName);
              },
              icon: const Icon(Icons.new_label),
            ),
          // IconButton(
          //     onPressed: () async {
          //       // // var devicetoken = await FirebaseMessaging.instance.getToken();
          //       // await Provider.of<DeviceTokens>(context, listen: false)
          //       //     .fetchToken();
          //       // var x = Provider.of<DeviceTokens>(context, listen: false)
          //       //     .deviceToken;
          //       // print(x);
          //       // String? devicetoken =
          //       //     await FirebaseMessaging.instance.getToken();
          //       // List<String> tokenlist = Provider.of<DeviceTokens>(
          //       //         navigatorkey.currentContext!,
          //       //         listen: false)
          //       //     .deviceToken;
          //       // int index =
          //       //     tokenlist.indexWhere((element) => element == devicetoken);
          //       // if (index == -1) {
          //       //   await Provider.of<DeviceTokens>(navigatorkey.currentContext!,
          //       //           listen: false)
          //       //       .storeToken(devicetoken);
          //       // }
          //       await Provider.of<DeviceTokens>(context, listen: false)
          //           .sendNotification('Movies', 'Batman');
          //     },
          //     icon: Icon(Icons.abc)),
          IconButton(
            onPressed: () {
              Userinfo();
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () async {
              await signOUT();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text(
          'Nex Play',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: _isLoading && _isloading2
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await Provider.of<MovieFunctionClass>(context, listen: false)
                    .FetchData()
                    .then(
                  (value) {
                    setState(
                      () {
                        _isLoading = false;
                      },
                    );
                  },
                );
              },
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 05),
                        child: Text(
                          'Newly Added',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CarouselSlider.builder(
                        itemCount: 9,
                        itemBuilder: (context, index, realindex) {
                          final _movieData = _movieList[index];
                          return newAddFun(_movieData);
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          pauseAutoPlayOnTouch: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          enlargeCenterPage: true,
                          // viewportFraction: 1,
                          disableCenter: true,
                          // height: 500,
                          height: MediaQuery.of(context).size.height * 0.66,
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: Text(
                          'Coming Soon',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.37,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: _commingSoon.length,
                          itemBuilder: ((context, index) {
                            final commingSoonDetails = _commingSoon[index];
                            return commingSoonFun(commingSoonDetails);
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
