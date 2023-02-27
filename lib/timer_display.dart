import 'dart:async';
import 'package:ekaant/bottom_nav.dart';
import 'package:ekaant/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerDisplay extends StatefulWidget {
  final Duration duration_required;
  final String surroundSound;
  final String startSound;
  final String endSound;
  const TimerDisplay(
      {required this.duration_required,
      required this.surroundSound,
      required this.startSound,
      required this.endSound,
      Key? key})
      : super(key: key);

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer startPlayer = AudioPlayer();
  AudioPlayer endPlayer = AudioPlayer();
  late Duration duration;
  late Duration initialTime;
  Timer? timer;
  bool isRunning = true;

  void playStartAudio() async {
    if (widget.startSound != 'none') {
      startPlayer.setAsset('assets/start_end_sound/${widget.startSound}.mp3');
      startPlayer.play();
    }
  }

  void playEndAudio() {
    if (widget.endSound != 'none') {
      endPlayer.setAsset('assets/start_end_sound/${widget.endSound}.mp3');
      endPlayer.play();
    }
  }

  void playAudio() {
    if (widget.surroundSound != 'none') {
      audioPlayer.setAsset('assets/surround_sound/${widget.surroundSound}.mp3');
      audioPlayer.setLoopMode(LoopMode.one);
      audioPlayer.setSpeed(1);
      audioPlayer.play();
    }
  }

  Future<void> updateTimeDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> currDone =
        (await prefs.getStringList('achievedTime')) ?? ['0', '0', '0'];

    await prefs.setStringList('achievedTime', [
      (int.parse(formatDuration(initialTime).substring(0, 2)) +
              int.parse(currDone[0]))
          .toString(),
      (int.parse(formatDuration(initialTime).substring(3, 5)) +
              int.parse(currDone[1]))
          .toString(),
      (int.parse(formatDuration(initialTime).substring(6, 8)) +
              int.parse(currDone[2]))
          .toString(),
    ]);
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
          audioPlayer.dispose();
          playEndAudio();
        }
      },
    );
  }

  void stopTimer() {
    setState(() {
      timer?.cancel();
    });
  }

  @override
  void initState() {
    duration = widget.duration_required;
    initialTime = widget.duration_required;
    playStartAudio();
    playAudio();
    startTimer();
    super.initState();
  }

  Widget buildTime() {
    if (duration == const Duration(seconds: 0)) {
      return const Icon(
        Icons.check,
        color: ekaantGreen,
        size: 110,
      );
    } else {
      return Center(
        child: Text(
          formatDuration(duration),
          style: const TextStyle(color: Colors.white, fontSize: 40),
        ),
      );
    }
  }

  Widget pausePlayButton() {
    if (isRunning == true) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
          side: const BorderSide(width: 2.0, color: Colors.white),
          shape: CircleBorder(),
        ),
        onPressed: () {
          stopTimer();
          audioPlayer.pause();
          startPlayer.pause();
          endPlayer.pause();
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
          shape: CircleBorder(),
        ),
        onPressed: () {
          startTimer();
          audioPlayer.play();
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
      updateTimeDone();
      return OutlinedButton(
        onPressed: (() {
          audioPlayer.dispose();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNav()),
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
              shape: CircleBorder(),
            ),
            onPressed: () {
              stopTimer();
              startPlayer.dispose();
              endPlayer.dispose();
              audioPlayer.dispose();
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

  @override
  Widget build(BuildContext context) {
    double percent;
    if (duration.inSeconds / initialTime.inSeconds > 1) {
      percent = 1;
    } else {
      percent = duration.inSeconds / initialTime.inSeconds;
    }
    return WillPopScope(
      onWillPop: () async {
        startPlayer.dispose();
        endPlayer.dispose();
        audioPlayer.dispose();
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
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: duration.inSeconds / initialTime.inSeconds,
                        strokeWidth: 12,
                        color: Colors.white,
                        backgroundColor: ekaantGreen,
                      ),
                      buildTime(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                stopButton()
              ],
            ),
          )),
    );
  }
}
