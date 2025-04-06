import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notev2/home.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:marquee/marquee.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:google_fonts/google_fonts.dart';
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late final AnimationController? _anime =
      AnimationController(vsync: this, duration: Duration(seconds: 2))
        ..repeat(reverse: true);
  // Start the animation
  //  _anime!.forward();;

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home())));
  }

  @override
  void dispose() {
    _anime!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use a more noticeable offset for up-and-down movement
    Animation<Offset> ofset =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 0.04))
            .animate(_anime!);

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SlideTransition(
              position: ofset,
              child: Center(child: Image(image: AssetImage('images/note.png'))),
            ),
            Text(
              "note",
              style: TextStyle(fontSize: 40, fontFamily: 'roboto'),
            )
                .animate()
                .fade(
                    begin: 84,
                    duration:
                        Duration(seconds: 5)) // uses `Animate.defaultDuration`
                .scale() // inherits duration from fadeIn
                .move(
                    delay: 1000.ms,
                    duration: 600.ms) // runs after the above w/new duration
            // / inherits the delay & duratio
            ,
            // Text(
            //   'Hello in Cursive!',
            //   style: TextStyle(fontSize: 30, fontFamily: 'italy'),
            // ),
            // Text(
            //   'Hello in Cursive!',
            //   style: GoogleFonts.semijoined(
            //     textStyle: TextStyle(fontSize: 30),
            //   ),

            Container(
              width: 200,
              height: 20,
              child: Marquee(
                text: 'you can  anything from heart',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'DancingScript'),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: 20.0,
                velocity: 100.0,
                pauseAfterRound: Duration(seconds: 2),
                startPadding: 10.0,
                accelerationDuration: Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: Duration(milliseconds: 500),
                decelerationCurve: Curves.easeIn,
              ),
            )
          ],
        ),
      ),
    );
  }
}
