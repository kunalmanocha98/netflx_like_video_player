import 'package:flutter/material.dart';
import 'package:netflx_like_video_player/UI/PlayerPage/player_page.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  backgroundColor: Colors.white),
              onPressed: () {
                openPlayer();

              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                child: Text(
                  'Play',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openPlayer(){
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.topToBottom,
            alignment: Alignment.centerRight,
            child: const PlayerPage(),
            curve: Curves.easeInOut,
            reverseDuration: const Duration(seconds: 1),
            duration: const Duration(milliseconds: 800),
            inheritTheme: true,
            ctx: context)
    );
  }


}
