import 'package:ekaant/breathing-excercise/animate_liquid.dart';
import 'package:ekaant/constants/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Breath extends StatefulWidget {
  const Breath({super.key});

  @override
  State<Breath> createState() => _BreathState();
}

class _BreathState extends State<Breath> {
  Duration session = const Duration(minutes: 5);
  Duration inhale = const Duration(seconds: 4);
  Duration hold1 = const Duration(seconds: 7);
  Duration exhale = const Duration(seconds: 8);
  bool vibrate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ekaantGreen,
      body: Container(
        decoration: const BoxDecoration(
          color: ekaantBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Divider(thickness: 1, color: Colors.white70),
              Row(
                children: [
                  const Text(
                    "Vibration",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Expanded(child: Container()),
                  Switch(
                      value: vibrate,
                      inactiveTrackColor: Colors.white54,
                      activeColor: ekaantGreen,
                      onChanged: (bool value) {
                        if (value) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Enable Vibration"),
                              actionsPadding: const EdgeInsets.all(15),
                              content: const Text(
                                  "Make sure to turn on Haptic Feedback or Touch Feedback in your device setting.",
                                  style: TextStyle(fontSize: 18)),
                              actions: [
                                TextButton(
                                  child: const Text(
                                    "Got it!",
                                    style: TextStyle(
                                        color: ekaantGreen, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                              shape: ShapeBorder.lerp(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                0.5,
                              ),
                            ),
                          );
                        }
                        setState(() {
                          vibrate = value;
                        });
                      })
                ],
              ),
              const Divider(thickness: 1, color: Colors.white70),
              Row(
                children: [
                  const Text(
                    "Session Duration",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Expanded(child: Container()),
                  CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      formatDuration(session),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          actions: [buildPicker(session, 0)],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text(
                              "Done",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
              const Divider(thickness: 1, color: Colors.white70),
              Row(
                children: [
                  const Text(
                    "Inhale",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Expanded(child: Container()),
                  CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      formatDuration(inhale),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          actions: [buildPicker(inhale, 1)],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text(
                              "Done",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
              const Divider(thickness: 1, color: Colors.white70),
              Row(
                children: [
                  const Text(
                    "Hold",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Expanded(child: Container()),
                  CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      formatDuration(hold1),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          actions: [buildPicker(hold1, 2)],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text(
                              "Done",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
              const Divider(thickness: 1, color: Colors.white70),
              Row(
                children: [
                  const Text(
                    "Exhale",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Expanded(child: Container()),
                  CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      formatDuration(exhale),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          actions: [buildPicker(exhale, 3)],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text(
                              "Done",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
              const Divider(thickness: 1, color: Colors.white70),
              const SizedBox(
                height: 30,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                  side: const BorderSide(width: 2.0, color: Colors.white),
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnimateLiquid(
                              session_duration: session,
                              inhale_time: inhale.inSeconds,
                              hold_time: hold1.inSeconds,
                              exhale_time: exhale.inSeconds,
                              vibrate: vibrate,
                            )),
                  );
                },
                child: const Icon(
                  Icons.play_arrow_sharp,
                  color: Colors.white,
                  size: 50,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPicker(Duration initTime, int i) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.4,
      child: CupertinoTimerPicker(
        initialTimerDuration: initTime,
        mode: CupertinoTimerPickerMode.hms,
        onTimerDurationChanged: ((value) {
          setState(() {
            if (i == 0) session = value;
            if (i == 1) inhale = value;
            if (i == 2) hold1 = value;
            if (i == 3) exhale = value;
          });
        }),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    String finalFormat = "";
    if (int.parse(hours) != 0) {
      finalFormat += '$hours' + 'hr';
    }

    if (int.parse(minutes) != 0) {
      finalFormat += ' $minutes' + 'min';
    }

    if (int.parse(seconds) != 0) {
      finalFormat += ' $seconds' + 'sec';
    }

    return finalFormat;
  }
}
