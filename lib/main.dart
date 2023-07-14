
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netflx_like_video_player/UI/HomePage/home_page.dart';
import 'package:netflx_like_video_player/UI/PlayerPage/player_page.dart';
import 'package:page_transition/page_transition.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  setAllOrientations();
  runApp(const MyApp());
}

setAllOrientations() async {
  await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final Color netflixColor = const Color.fromRGBO(229, 9, 20, 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: MaterialColor(netflixColor.value, <int, Color>{
        50: netflixColor.withOpacity(0.1),
        100: netflixColor.withOpacity(0.2),
        200: netflixColor.withOpacity(0.3),
        300: netflixColor.withOpacity(0.4),
        400: netflixColor.withOpacity(0.5),
        500: netflixColor.withOpacity(0.6),
        600: netflixColor.withOpacity(0.7),
        700: netflixColor.withOpacity(0.8),
        800: netflixColor.withOpacity(0.9),
        900: netflixColor.withOpacity(1.0),
      })),
      home: const HomePage(),
    );
  }
}

