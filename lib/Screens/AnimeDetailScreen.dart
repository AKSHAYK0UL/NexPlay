import 'package:chrome_launcher/chrome_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nex_movies/Models/AnimeModel.dart';
import 'package:nex_movies/Widgets/AnimeINPUT.dart';
import 'package:nex_movies/Widgets/InputWidget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Models/structureModel.dart';
import '../Widgets/ListImageWidget.dart';

class AnimeDetailScreen extends StatefulWidget {
  static const routeName = 'AnimeDetailScreen';
  const AnimeDetailScreen({super.key});

  @override
  State<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  late YoutubePlayerController _controller;
  bool _istrue = true;
  String? _thumbnail;

  @override
  void didChangeDependencies() {
    if (_istrue) {
      final _movieOBJECT = ModalRoute.of(context)!.settings.arguments as Map;
      final _videoUrl = _movieOBJECT['youtubelink'];

      final videoId = YoutubePlayer.convertUrlToId(
        _videoUrl,
      );
      _thumbnail = YoutubePlayer.getThumbnail(videoId: videoId!);
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          forceHD: true,
          loop: false,
          enableCaption: false,
          mute: false,
          disableDragSeek: true,
        ),
      );

      _istrue = false;
    }

    super.didChangeDependencies();
  }

  Future<void> shownav() async {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
  }

  Future<void> hidenav() async {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
  }

  bool youtube = false;
  final _Pagecontroller = PageController();
  bool _lastPage = false;
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final ort = MediaQuery.of(context).orientation == Orientation.portrait;
    if (ort) {
      shownav();
    } else {
      hidenav();
    }

    final _movieOBJECT = ModalRoute.of(context)!.settings.arguments as Map;
    final _name = _movieOBJECT['name'];
    final _pics = _movieOBJECT['pics'];
    final _desp = _movieOBJECT['desp'];
    final _download = _movieOBJECT['download'];
    final _movietype = _movieOBJECT['type'];
    final _movierating = _movieOBJECT['rating'];
    final _movieId = _movieOBJECT['id'];

    return WillPopScope(
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          thumbnail: Image.network(_thumbnail!),
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.white,
          aspectRatio: 16 / 9,
          progressColors: const ProgressBarColors(
            playedColor: Colors.redAccent,
            handleColor: Colors.red,
            bufferedColor: Colors.white,
            backgroundColor: Colors.blue,
          ),
        ),
        builder: (context, player) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            elevation: 0,
            title: Text(
              _name,
              style: Theme.of(context).textTheme.titleLarge,
              maxLines: 2,
            ),
            actions: [
              if (FirebaseAuth.instance.currentUser!.uid ==
                  'TuvybxINm7S1o6ifkneSu4odd0e2')
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AnimeINPUT.routeName, arguments: _movieId);
                  },
                  icon: const Icon(Icons.edit),
                ),
              if (FirebaseAuth.instance.currentUser!.uid ==
                  'TuvybxINm7S1o6ifkneSu4odd0e2')
                IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Text(
                            'Are You Sure?',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          content: Text(
                            'Movie will be deleted permanently.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await Provider.of<AnimeFunctionClass>(context,
                                        listen: false)
                                    .deleteMovie(_movieId)
                                    .then(
                                      (value) =>
                                          Provider.of<AnimeFunctionClass>(
                                                  context,
                                                  listen: false)
                                              .search(''),
                                    )
                                    .then(
                                  (value) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                              child: const Text(
                                'Delete',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 17),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        PageView(
                          controller: _Pagecontroller,
                          onPageChanged: (index) => setState(() {
                            _pageIndex = index;
                            index == _pics.length
                                ? _lastPage = true
                                : _lastPage = false;
                          }),
                          children: [
                            youtube
                                ? Container(
                                    color: Colors.transparent,
                                    height: 300,
                                    width: double.infinity,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: player,
                                  ),
                            ..._pics.map(
                              (image) {
                                return ListImageWidget(image);
                              },
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: _pageIndex == 0
                                    ? null
                                    : () {
                                        _Pagecontroller.previousPage(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeIn);
                                      },
                                icon: Icon(
                                  _pageIndex == 0 ? null : Icons.arrow_back_ios,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                              IconButton(
                                onPressed: _lastPage
                                    ? null
                                    : () {
                                        _Pagecontroller.nextPage(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeIn);
                                      },
                                icon: Icon(
                                  _lastPage ? null : Icons.arrow_forward_ios,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0.0, 0.90),
                          child: SmoothPageIndicator(
                            onDotClicked: (index) =>
                                _Pagecontroller.jumpToPage(index),
                            controller: _Pagecontroller,
                            count: (_pics.length + 1),
                            effect: const SlideEffect(
                              dotColor: Colors.white,
                              activeDotColor: Colors.blue,
                              type: SlideType.normal,
                              paintStyle: PaintingStyle.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Details',
                          style: TextStyle(
                            color: Colors.green.shade400,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Text(
                                'IMDB rating :',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Text(
                                _movierating.toString().length == 1
                                    ? '$_movierating.0.'
                                    : '$_movierating.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Genres: ',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.64,
                              child: Text(
                                '$_movietype',
                                style: const TextStyle(
                                  fontSize: 18.5,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Storyline',
                          style: TextStyle(
                            color: Colors.green.shade400,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _desp,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          "Download Links",
                          style: TextStyle(
                            color: Colors.green.shade400,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        ..._download.map(
                          (mAp) {
                            return Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              width: double.infinity,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                onPressed: () async {
                                  final _openInChrome = ChromeLauncher();
                                  await _openInChrome
                                      .launchWithChrome(mAp['url']);
                                  // launchUrl(
                                  //   Uri.parse(mAp['url']),
                                  //   mode: LaunchMode.externalApplication,
                                  // );
                                },
                                child: Text(
                                  '${mAp['res']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        if (MediaQuery.of(context).orientation != Orientation.portrait) {
          _controller.toggleFullScreenMode();
        } else {
          setState(() {
            youtube = true;
          });
        }
        return youtube;
      },
    );
  }
}
