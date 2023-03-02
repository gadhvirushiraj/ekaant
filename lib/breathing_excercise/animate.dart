import 'dart:async';
import 'package:ekaant/bottom_nav.dart';
import 'package:ekaant/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Animate extends StatefulWidget {
  final inhale_time;
  final hold_time;
  final exhale_time;
  final session_duration;

  const Animate(
      {required this.session_duration,
      required this.inhale_time,
      required this.hold_time,
      required this.exhale_time,
      Key? key})
      : super(key: key);

  @override
  State<Animate> createState() => _AnimateState();
}

class _AnimateState extends State<Animate> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation colorAnimation;
  late Animation sizeAnimation;
  late Duration duration;
  late Duration initialTime;

  Timer? timer;
  bool isRunning = true;

  @override
  void initState() {
    super.initState();
    startTimer();
    duration = widget.session_duration;
    initialTime = widget.session_duration;

    controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                (widget.inhale_time + widget.hold_time + widget.exhale_time)));

    Animatable colorSequence = TweenSequence([
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
            begin: ekaantGreen.withOpacity(0.5),
            end: ekaantGreen.withOpacity(0.8)),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
            begin: ekaantGreen.withOpacity(0.8),
            end: ekaantGreen.withOpacity(0.8)),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
            begin: ekaantGreen.withOpacity(0.8),
            end: ekaantGreen.withOpacity(0.5)),
      ),
    ]);

    colorAnimation = colorSequence.animate(controller);
    sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(
          tween: Tween(begin: 50, end: 200),
          weight: widget.inhale_time /
              (widget.inhale_time + widget.hold_time + widget.exhale_time)),
      TweenSequenceItem(
          tween: ConstantTween(200),
          weight: widget.hold_time /
              (widget.inhale_time + widget.hold_time + widget.exhale_time)),
      TweenSequenceItem(
          tween: Tween(begin: 200, end: 50),
          weight: widget.exhale_time /
              (widget.inhale_time + widget.hold_time + widget.exhale_time)),
    ]).animate(controller);

    controller.addListener(() {
      setState(() {});
    });

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.dispose();
        timer?.cancel();
        return true;
      },
      child: Scaffold(
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
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: ekaantBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60),
              topRight: Radius.circular(60),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 2, color: Colors.white.withOpacity(0.4))),
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 25,
                        )
                      ],
                      shape: BoxShape.circle,
                      color: ekaantGreen.withOpacity(0.25),
                      border: Border.all(
                          width: 2, color: Colors.white.withOpacity(0.5)),
                    ),
                  ),
                  Container(
                    height: sizeAnimation.value,
                    width: sizeAnimation.value,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ekaantGreen.withOpacity(0.65),
                          blurRadius: 20,
                          spreadRadius: 35,
                        )
                      ],
                      color: colorAnimation.value,
                      shape: BoxShape.circle,
                    ),
                  ),
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
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              stopButton(),
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (duration > const Duration(seconds: 0)) {
          setState(() {
            duration = duration - const Duration(seconds: 1);
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
          controller.stop();
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
          controller.repeat();
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
          controller.dispose();
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
              controller.dispose();
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
