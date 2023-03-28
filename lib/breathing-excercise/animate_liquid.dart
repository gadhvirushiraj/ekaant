import 'dart:async';
import 'package:ekaant/bottom_nav.dart';
import 'package:ekaant/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimateLiquid extends StatefulWidget {
  final inhale_time;
  final hold_time;
  final exhale_time;
  final session_duration;

  const AnimateLiquid(
      {required this.session_duration,
      required this.inhale_time,
      required this.hold_time,
      required this.exhale_time,
      Key? key})
      : super(key: key);

  @override
  State<AnimateLiquid> createState() => _AnimateLiquidState();
}

class _AnimateLiquidState extends State<AnimateLiquid> {
  Timer? timer;
  bool isRunning = true;
  late Duration duration;
  late Duration initialTime;
  late String text;
  late double liquidPercentage;
  late Duration count;

  void initState() {
    super.initState();
    startTimer();
    duration = widget.session_duration;
    initialTime = widget.session_duration;
    text = "Inhale";
    liquidPercentage = 0;
    count = Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ekaantGreen,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        backgroundColor: ekaantGreen,
        title: Image.asset(
          'assets/title.png',
          height: 90,
          fit: BoxFit.contain,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: ekaantBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 250,
                  width: 250,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: duration.inSeconds / initialTime.inSeconds,
                        strokeWidth: 12,
                        color: Colors.white,
                        backgroundColor: ekaantDarkGreen,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: LiquidCircularProgressIndicator(
                    value: liquidPercentage,
                    direction: Axis.vertical,
                    valueColor: const AlwaysStoppedAnimation(ekaantGreen),
                    backgroundColor: ekaantBlue,
                    borderColor: Colors.white,
                    borderWidth: 2.5,
                    center: Text(
                      text,
                      style: const TextStyle(color: Colors.white, fontSize: 27),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            stopButton(),
          ],
        ),
      ),
    );
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(milliseconds: 1),
      (_) {
        if (duration > const Duration(seconds: 0)) {
          setState(() {
            duration = duration - const Duration(milliseconds: 1);
            if (text == "Inhale") {
              if (count.inSeconds == widget.inhale_time) {
                text = "Hold";
                count = Duration.zero;
                liquidPercentage = 1.1;
              } else {
                count = count + const Duration(milliseconds: 1);
                liquidPercentage =
                    count.inMilliseconds / (widget.inhale_time * 1000);
              }
            } else if (text == "Hold") {
              if (count.inSeconds == widget.hold_time) {
                text = "Exhale";
                count = Duration.zero;
              } else {
                count = count + const Duration(milliseconds: 1);
              }
            } else {
              if (count.inSeconds == widget.exhale_time) {
                text = "Inhale";
                count = Duration.zero;
              } else {
                count = count + const Duration(milliseconds: 1);
                liquidPercentage =
                    1 - (count.inMilliseconds / (widget.exhale_time * 1000));
              }
            }
          });
        } else {
          timer?.cancel();
        }
      },
    );
  }

  void stopTimer() {
    setState(() {
      timer?.cancel();
    });
  }

  Widget pausePlayButton() {
    if (isRunning == true) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
          side: const BorderSide(width: 2.0, color: Colors.white),
          shape: const CircleBorder(),
        ),
        onPressed: () {
          stopTimer();
          setState(() {
            isRunning = false;
          });
        },
        child: const Icon(
          Icons.pause,
          color: Colors.white,
          size: 50,
        ),
      );
    } else {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
          side: const BorderSide(width: 2.0, color: Colors.white),
          shape: const CircleBorder(),
        ),
        onPressed: () {
          startTimer();
          setState(() {
            isRunning = true;
          });
        },
        child: const Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 50,
        ),
      );
    }
  }

  Widget stopButton() {
    if (duration == const Duration(seconds: 0)) {
      return OutlinedButton(
        onPressed: (() {
          updateTimeDone();
          timer?.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNav()),
          );
        }),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
          side: const BorderSide(width: 2.0, color: Colors.white),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text(
          "Finish",
          style: TextStyle(color: ekaantGreen, fontSize: 20),
        ),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
              side: const BorderSide(width: 2.0, color: Colors.white),
              shape: const CircleBorder(),
            ),
            onPressed: () {
              stopTimer();
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.timer_off,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          pausePlayButton(),
        ],
      );
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return '$hours:$minutes:$seconds';
  }

  Future<void> updateTimeDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> currDone =
        await (prefs.getStringList('achievedBreath')) ?? ['0', '0', '0'];

    await prefs.setStringList('achievedBreath', [
      ((int.parse(formatDuration(initialTime).substring(0, 2)) +
              int.parse(currDone[0]))
          .toString()),
      ((int.parse(formatDuration(initialTime).substring(3, 5)) +
              int.parse(currDone[1]))
          .toString()),
      ((int.parse(formatDuration(initialTime).substring(6, 8)) +
              int.parse(currDone[2]))
          .toString()),
    ]);
  }
}
