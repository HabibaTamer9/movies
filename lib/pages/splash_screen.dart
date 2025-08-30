import 'package:flutter/material.dart';
import 'package:movies/data.dart';
import 'package:movies/pages/home.dart';
import 'package:movies/widget/background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0.0;

  navigateFunction() async {
    await fetchData();
    print("5");
    Future.delayed(Duration(milliseconds: 200), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        opacity = 1.0;
      });
      navigateFunction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BackGround().decoration(),
        child: Column(
          children: [
            TweenAnimationBuilder(
              duration: Duration(milliseconds: 1500),
              curve: Curves.bounceOut,
              tween: Tween<double>(
                  begin: 0, end: MediaQuery.of(context).size.height * 0.35),
              child: Text(
                "📺",
                style: TextStyle(fontSize: 80),
              ),
              builder: (context, value, child) {
                return Container(
                    margin: EdgeInsets.only(top: value), child: child);
              },
            ),
            Center(
              child: AnimatedOpacity(
                opacity: opacity,
                curve: Curves.bounceOut,
                duration: Duration(seconds: 2),
                child: Text(
                  'Movies',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: <Color>[Color(0xff0a838e), Colors.purple],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 80.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
