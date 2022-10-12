import 'package:ekaant/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showSplash = false;

  Future<void> splashTimer() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {});
    setState(() {
      showSplash = false;
    });
  }

  void initState() {
    showSplash = true;
    splashTimer();
    super.initState();
  }

  Widget animation() {
    if (showSplash == true) {
      return Container(
        color: Colors.transparent,
        child: const Center(
          child: RiveAnimation.asset(
            'assets/splash.riv',
            alignment: Alignment.center,
            fit: BoxFit.fill,
          ),
        ),
      );
    }
    return const SizedBox(
      height: 0,
      width: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          BottomNav(),
          animation(),
        ],
      ),
    );
  }
}
