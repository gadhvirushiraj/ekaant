import 'package:ekaant/timer_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerSelection extends StatefulWidget {
  const TimerSelection({Key? key}) : super(key: key);

  @override
  State<TimerSelection> createState() => _TimerSelectionState();
}

class _TimerSelectionState extends State<TimerSelection> {
  late FixedExtentScrollController scrollSurroundController;
  late FixedExtentScrollController scrollStartController;
  late FixedExtentScrollController scrollEndController;
  List<String> surroundSounds = [
    'buddhist scroll',
    'om chant', // yogis om
    'wind chimes',
    'none'
  ];
  List<String> startendSounds = [
    'shankh',
    'tibetian bowl',
    'buddhist bowl',
    'none'
  ];
  Duration duration = const Duration(minutes: 5);
  int surroundSound = 0, endSound = 0, startSound = 0;

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

  void initState() {
    scrollSurroundController =
        FixedExtentScrollController(initialItem: surroundSound);
    scrollStartController =
        FixedExtentScrollController(initialItem: startSound);
    scrollEndController = FixedExtentScrollController(initialItem: endSound);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00c29a),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xff0c0d1b),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 200,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 1, color: Colors.white70),
              Row(
                children: [
                  const Text(
                    "Duration",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Expanded(child: Container()),
                  CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        formatDuration(duration),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) => CupertinoActionSheet(
                                  actions: [buildPicker()],
                                  cancelButton: CupertinoActionSheetAction(
                                    child: const Text(
                                      "Done",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ));
                      })
                ],
              ),
              const Divider(thickness: 1, color: Colors.white70),
              Row(
                children: [
                  const Text(
                    "Surround Sound",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Expanded(child: Container()),
                  CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        surroundSounds[surroundSound],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        scrollSurroundController.dispose();
                        scrollSurroundController = FixedExtentScrollController(
                            initialItem: surroundSound);
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) => CupertinoActionSheet(
                                  actions: [surroundSoundPicker()],
                                  cancelButton: CupertinoActionSheetAction(
                                    child: const Text(
                                      "Done",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ));
                      })
                ],
              ),
              const Divider(thickness: 1, color: Colors.white70),
              Row(
                children: [
                  const Text(
                    "Start Sound",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Expanded(child: Container()),
                  CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        startendSounds[startSound],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        scrollStartController.dispose();
                        scrollStartController = FixedExtentScrollController(
                            initialItem: startSound);
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) => CupertinoActionSheet(
                                  actions: [startSoundPicker()],
                                  cancelButton: CupertinoActionSheetAction(
                                    child: const Text(
                                      "Done",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ));
                      })
                ],
              ),
              const Divider(thickness: 1, color: Colors.white70),
              Row(
                children: [
                  const Text(
                    "End Sound",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Expanded(child: Container()),
                  CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        startendSounds[endSound],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        scrollEndController.dispose();
                        scrollEndController =
                            FixedExtentScrollController(initialItem: endSound);
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) => CupertinoActionSheet(
                                  actions: [endSoundPicker()],
                                  cancelButton: CupertinoActionSheetAction(
                                    child: const Text(
                                      "Done",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ));
                      })
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
                  shape: CircleBorder(),
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TimerDisplay(
                              duration_required: duration,
                              surroundSound: surroundSounds[surroundSound],
                              startSound: startendSounds[startSound],
                              endSound: startendSounds[endSound],
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

  Widget buildPicker() {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.4,
      child: CupertinoTimerPicker(
        initialTimerDuration: duration,
        mode: CupertinoTimerPickerMode.hms,
        onTimerDurationChanged: ((value) {
          setState(() {
            duration = value;
          });
        }),
      ),
    );
  }

  Widget surroundSoundPicker() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: CupertinoPicker(
        looping: true,
        itemExtent: 64,
        scrollController: scrollSurroundController,
        backgroundColor: Colors.white,
        onSelectedItemChanged: ((value) {
          setState(() {
            surroundSound = value;
          });
        }),
        children: surroundSounds.map(((sound) {
          return Center(child: Text(sound));
        })).toList(),
      ),
    );
  }

  Widget startSoundPicker() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: CupertinoPicker(
        looping: true,
        itemExtent: 64,
        scrollController: scrollStartController,
        backgroundColor: Colors.white,
        onSelectedItemChanged: ((value) {
          setState(() {
            startSound = value;
          });
        }),
        children: startendSounds.map(((sound) {
          return Center(child: Text(sound));
        })).toList(),
      ),
    );
  }

  Widget endSoundPicker() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: CupertinoPicker(
        looping: true,
        itemExtent: 64,
        scrollController: scrollEndController,
        backgroundColor: Colors.white,
        onSelectedItemChanged: ((value) {
          setState(() {
            endSound = value;
          });
        }),
        children: startendSounds.map(((sound) {
          return Center(child: Text(sound));
        })).toList(),
      ),
    );
  }
}
