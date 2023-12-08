import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nex_movies/Models/AnimeModel.dart';
import 'package:nex_movies/Models/CommingSoonModel.dart';
import 'package:nex_movies/Models/WebSeriesModel.dart';
import 'package:nex_movies/Models/firebaseFUN.dart';
import 'package:nex_movies/Models/storeDeviceTokens.dart';
import 'package:nex_movies/Screens/AnimeDetailScreen.dart';
import 'package:nex_movies/Screens/SerialDetailsScreen.dart';
import 'package:nex_movies/Screens/bottomNavScreen.dart';
import 'package:nex_movies/Screens/resetPasswordScreen.dart';
import 'package:nex_movies/Widgets/AuthWidget.dart';
import 'package:nex_movies/Widgets/WebseriesINPUT.dart';
import 'package:nex_movies/firebase_options.dart';
import 'package:provider/provider.dart';
import 'Models/structureModel.dart';
import 'Screens/CommingSoonDetailsScreen.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/InputCommingSoonScreen.dart';
import 'Screens/MovieDetailScreen.dart';
import 'Screens/NewAddandCommingSoonScreen.dart';
import 'Screens/SerialHomeScreen.dart';
import 'Widgets/AnimeINPUT.dart';
import 'Widgets/InputWidget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(backgroudNotification);

  runApp(MyApp());
}

final navigatorkey = GlobalKey<NavigatorState>();
@pragma('vm:entry-point')
Future<void> backgroudNotification(RemoteMessage message) async {
  print(message.notification!.body.toString());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MovieFunctionClass()),
        ChangeNotifierProvider(create: (context) => CommingSoonModelFunction()),
        ChangeNotifierProvider(create: (context) => AnimeFunctionClass()),
        ChangeNotifierProvider(create: (context) => WebSeriesFunctionClass()),
        ChangeNotifierProvider(create: (context) => FirebaseFUN()),
        ChangeNotifierProvider(
          create: (context) => DeviceTokens(),
        )
      ],
      child: MaterialApp(
        navigatorKey: navigatorkey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          canvasColor: Colors.white,
          hintColor: Colors.green,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              color: Colors.white,
              fontSize: 21.4,
              fontWeight: FontWeight.bold,
            ),
            titleMedium: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            titleSmall: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.normal,
            ),
            bodyMedium: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
            bodySmall: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        home: const AuthWidget(),
        routes: {
          BottomNavScreen.routeName: (context) => BottomNavScreen(),
          MovieScreen.routeName: (context) => const MovieScreen(),
          InputWidget.routeName: (context) => const InputWidget(),
          NewAddandCommingSoonScreen.routeName: (context) =>
              NewAddandCommingSoonScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          InputCommingSoonScreen.routeName: (context) =>
              const InputCommingSoonScreen(),
          CommingSoonDetailsScreen.routeName: (context) =>
              const CommingSoonDetailsScreen(),
          AnimeINPUT.routeName: (context) => const AnimeINPUT(),
          AnimeDetailScreen.routeName: (context) => const AnimeDetailScreen(),
          SerialHomeScreen.routeName: (context) => const SerialHomeScreen(),
          WebSeriesDetailScreen.routeName: (context) =>
              const WebSeriesDetailScreen(),
          WebseriesINPUT.routeName: (context) => const WebseriesINPUT(),
          resetPasswordScreen.routeName: (context) => resetPasswordScreen(),
        },
      ),
    );
  }
}
