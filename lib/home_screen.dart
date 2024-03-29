import 'package:cron/cron.dart';
import 'package:ekaant/app-tour/tour_home.dart';
import 'package:ekaant/app-tour/app_tour_status.dart';
import 'package:ekaant/calendar.dart';
import 'package:ekaant/constants/color.dart';
import 'package:ekaant/mood_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  int streak = 0;
  String previousCompletedDate = "";

  Duration duration_Medi = const Duration(minutes: 5); // by default
  Duration durationDoneMedi = const Duration(seconds: 0);

  Duration duration_Breath = const Duration(minutes: 5); // by default
  Duration durationDoneBreath = const Duration(seconds: 0);

  List<String> goalMeditation = ['0', '5', '0']; // by deafualt
  List<String> achievedMedi = ['0', '0', '0'];

  List<String> goalBreath = ['0', '5', '0']; // by deafualt
  List<String> achievedBreath = ['0', '0', '0'];

  late String lastActivityDate; // by deafualt
  List<String> toHighlight = [];

  late TutorialCoachMark tutorialMark;
  final ScrollController scrollController = ScrollController();

  List<String> moodData = ['0', '0', '0', '0', '0'];

  final calendar_key = GlobalKey();
  final toggle_key = GlobalKey();
  final streak_key = GlobalKey();
  final indicator_key = GlobalKey();
  final goal_key = GlobalKey();

  List<bool> isSelected = [true, false];

  @override
  void initState() {
    reset();
    getData();
    super.initState();
    initAppTour();
  }

  void initAppTour() async {
    if (await SaveAppTour().alreadyDone("home_tour") == false) {
      int counter = 0;
      List<TargetFocus> targets = home_target(
        calendar_key: calendar_key,
        toggle_key: toggle_key,
        indicator_key: indicator_key,
        streak_key: streak_key,
        goal_key: goal_key,
      );
      Scrollable.ensureVisible(
          targets[counter].keyTarget?.currentContext ?? context);
      tutorialMark = TutorialCoachMark(
          targets: targets,
          colorShadow: ekaantBlue,
          opacityShadow: 0.9,
          paddingFocus: 10,
          hideSkip: true,
          alignSkip: Alignment.bottomRight,
          onClickTarget: (p0) async {
            counter++;
            if (counter < targets.length) {
              Scrollable.ensureVisible(
                  targets[counter].keyTarget?.currentContext ?? context,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeIn);
            }
            await Future.delayed(const Duration(milliseconds: 300));
          },
          onClickOverlay: ((p0) async {
            counter++;
            if (counter < targets.length) {
              Scrollable.ensureVisible(
                  targets[counter].keyTarget?.currentContext ?? context,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeIn);
            }
            await Future.delayed(const Duration(milliseconds: 200));
          }),
          onFinish: (() {
            SaveAppTour().saveStatus("home_tour");
            Scrollable.ensureVisible(calendar_key.currentContext ?? context,
                duration: const Duration(seconds: 1), curve: Curves.easeIn);
          }));

      Future.delayed(const Duration(seconds: 3), () {
        tutorialMark.show(context: context);
      });
    }
  }

  Future<void> setNew() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lastActivityDate =
        await prefs.getString('lastActivityDate') ?? '2021-11-11';
    if (lastActivityDate != DateFormat("yyyy-MM-dd").format(DateTime.now())) {
      await prefs.setStringList('achievedMedi', ['0', '0', '0']);
      await prefs.setStringList('achievedBreath', ['0', '0', '0']);
      await prefs.setString(
          'lastActivityDate', DateFormat("yyyy-MM-dd").format(DateTime.now()));
    }
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    toHighlight = (await prefs.getStringList('toHighlight')) ?? [];

    streak = (await prefs.getInt('streak')) ?? 0;

    goalMeditation =
        (await prefs.getStringList('goalMeditation')) ?? ['0', '5', '0'];
    goalBreath = (await prefs.getStringList('goalBreath')) ?? ['0', '5', '0'];

    await setNew();

    achievedMedi =
        (await prefs.getStringList('achievedMedi')) ?? ['0', '0', '0'];

    achievedBreath =
        (await prefs.getStringList('achievedBreath')) ?? ['0', '0', '0'];

    duration_Medi = Duration(
      hours: int.parse(goalMeditation[0]),
      minutes: int.parse(goalMeditation[1]),
      seconds: int.parse(goalMeditation[2]),
    );

    durationDoneMedi = Duration(
      hours: int.parse(achievedMedi[0]),
      minutes: int.parse(achievedMedi[1]),
      seconds: int.parse(achievedMedi[2]),
    );

    duration_Breath = Duration(
      hours: int.parse(goalBreath[0]),
      minutes: int.parse(goalBreath[1]),
      seconds: int.parse(goalBreath[2]),
    );

    durationDoneBreath = Duration(
      hours: int.parse(achievedBreath[0]),
      minutes: int.parse(achievedBreath[1]),
      seconds: int.parse(achievedBreath[2]),
    );

    previousCompletedDate = await prefs.getString('lastCompleteDay') ?? "";

    if (previousCompletedDate == "" ||
        DateFormat("yyyy-MM-dd")
                .parse(previousCompletedDate)
                .difference(DateTime.now())
                .inDays
                .abs() >
            1) {
      streak = 0;
    }

    moodData = prefs.getStringList('moodData') ?? ['0', '0', '0', '0', '0'];
    setState(() {});
  }

  Future<void> reset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final cron = Cron();
    cron.schedule(Schedule.parse('00 00 * * *'), () async {
      await prefs.setStringList('achievedMedi', ['0', '0', '0']);
      await prefs.setStringList('achievedBreath', ['0', '0', '0']);
      getData();
    });
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
    return Scaffold(
      backgroundColor: ekaantGreen,
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
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 90),
          child: Padding(
            padding:
                const EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 20),
            child: Column(
              children: [
                buildCalendar(toHighlight, calendar_key, isSelected[0]),
                BarChartSample7(build: isSelected[1], moodData: moodData),
                const SizedBox(height: 12),
                Container(
                  key: toggle_key,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ToggleButtons(
                        constraints: BoxConstraints.expand(
                            width: constraints.maxWidth / 2, height: 35),
                        fillColor: ekaantGreen,
                        borderWidth: 0,
                        selectedColor: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < isSelected.length; i++) {
                              isSelected[i] = i == index;
                            }
                          });
                        },
                        isSelected: isSelected,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Calendar',
                              style: TextStyle(fontSize: 16, color: ekaantBlue),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Mood Chart',
                              style: TextStyle(fontSize: 16, color: ekaantBlue),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 5),
                analysisToday(),
                const SizedBox(height: 12),
                Container(
                  key: goal_key,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Set Goal",
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                        const Divider(thickness: 1, color: Colors.black87),
                        Row(
                          children: [
                            const Text(
                              "Daily Meditation",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                            Expanded(child: Container()),
                            CupertinoButton(
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                formatDuration(duration_Medi),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              onPressed: () {
                                showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) => CupertinoActionSheet(
                                          actions: [
                                            buildPicker(duration_Medi, 0)
                                          ],
                                          cancelButton:
                                              CupertinoActionSheetAction(
                                            child: const Text(
                                              "Done",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ));
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Breathing Excercise",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                            Expanded(child: Container()),
                            CupertinoButton(
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                formatDuration(duration_Breath),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              onPressed: () {
                                showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) => CupertinoActionSheet(
                                          actions: [
                                            buildPicker(
                                              duration_Breath,
                                              1,
                                            )
                                          ],
                                          cancelButton:
                                              CupertinoActionSheetAction(
                                            child: const Text(
                                              "Done",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPicker(Duration initTime, int i) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Center(
        child: CupertinoTimerPicker(
          initialTimerDuration: initTime,
          mode: CupertinoTimerPickerMode.hms,
          onTimerDurationChanged: ((value) async {
            if (value != const Duration(seconds: 0)) {
              setState(() {
                if (i == 0) duration_Medi = value;
                if (i == 1) duration_Breath = value;
              });

              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (i == 0) {
                await prefs.setStringList('goalMeditation', [
                  formatDuration(duration_Medi).substring(0, 2),
                  formatDuration(duration_Medi).substring(3, 5),
                  formatDuration(duration_Medi).substring(6, 8)
                ]);
              }

              if (i == 1) {
                await prefs.setStringList('goalBreath', [
                  formatDuration(duration_Breath).substring(0, 2),
                  formatDuration(duration_Breath).substring(3, 5),
                  formatDuration(duration_Breath).substring(6, 8)
                ]);
              }
            }
          }),
        ),
      ),
    );
  }

  Widget analysisToday() {
    double percent_medi = durationDoneMedi.inSeconds / duration_Medi.inSeconds;
    double percent_breath =
        durationDoneBreath.inSeconds / duration_Breath.inSeconds;

    if (percent_medi >= 1 || percent_breath >= 1) {
      if (percent_breath >= 1) percent_breath = 1;
      if (percent_medi >= 1) percent_medi = 1;

      if (percent_medi >= 1 && percent_breath >= 1) {
        if (previousCompletedDate == "" ||
            DateFormat("yyyy-MM-dd").format(DateTime.now()) !=
                previousCompletedDate) {
          markToday();
        }
      } else {
        if (DateFormat("yyyy-MM-dd").format(DateTime.now()) ==
            previousCompletedDate) {
          removeToday();
        }
      }
    } else {
      if (DateFormat("yyyy-MM-dd").format(DateTime.now()) ==
          previousCompletedDate) {
        removeToday();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        padding:
            const EdgeInsets.only(top: 15, right: 20, left: 20, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Column(
                children: [
                  const Text(
                    "Today's Effort",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        key: indicator_key,
                        width: (MediaQuery.of(context).size.width - 90) / 2,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularPercentIndicator(
                              radius: 45,
                              lineWidth: 9,
                              percent: percent_breath,
                              circularStrokeCap: CircularStrokeCap.round,
                              reverse: true,
                              progressColor: ekaantDarkerGreen,
                              backgroundColor: ekaantBlue,
                            ),
                            CircularPercentIndicator(
                              radius: 55,
                              lineWidth: 9,
                              percent: percent_medi,
                              circularStrokeCap: CircularStrokeCap.round,
                              reverse: true,
                              progressColor: ekaantGreen,
                              backgroundColor: ekaantBlue,
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${((durationDoneMedi.inSeconds / duration_Medi.inSeconds) * 100).floor()}%",
                                    style: const TextStyle(
                                        color: ekaantGreen, fontSize: 18),
                                  ),
                                  Text(
                                    "${((durationDoneBreath.inSeconds / duration_Breath.inSeconds) * 100).floor()}%",
                                    style: const TextStyle(
                                        color: ekaantDarkerGreen, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: ekaantDarkerGreen,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "Breathing",
                        style: TextStyle(color: ekaantDarkerGreen),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: ekaantGreen,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "Meditation",
                        style: TextStyle(color: ekaantGreen),
                      ),
                    ],
                  )
                ],
              ),
              const VerticalDivider(
                color: ekaantBlue,
                thickness: 2,
                endIndent: 3,
                width: 30,
              ),
              Expanded(
                key: streak_key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      streak.toString(),
                      style: const TextStyle(
                        fontSize: 40,
                        color: ekaantGreen,
                      ),
                    ),
                    const Text(
                      "DAYS STREAK",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> markToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> currData = (await prefs.getStringList('toHighlight')) ?? [];

    currData.add(DateFormat("yyyy-MM-dd").format(DateTime.now()));
    Set<String> currDataSet = {...currData};

    previousCompletedDate = await prefs.getString('lastCompleteDay') ?? "";

    await prefs.setStringList('toHighlight', currDataSet.toList());

    await prefs.setString(
        'lastCompleteDay', DateFormat("yyyy-MM-dd").format(DateTime.now()));
    await prefs.setString(
        'lastActivityDate', DateFormat("yyyy-MM-dd").format(DateTime.now()));

    if (previousCompletedDate == "" ||
        DateFormat("yyyy-MM-dd")
                .parse(previousCompletedDate)
                .difference(DateTime.now())
                .inDays <=
            1) {
      streak += 1;
    } else {
      streak = 0;
    }

    await prefs.setInt('streak', streak);

    setState(() {
      toHighlight = currDataSet.toList();
      previousCompletedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      lastActivityDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    });
  }

  Future<void> removeToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> currData = (await prefs.getStringList('toHighlight')) ?? [];

    currData.remove(DateFormat("yyyy-MM-dd").format(DateTime.now()));
    await prefs.setStringList('toHighlight', currData.toList());
    await prefs.setString('lastCompleteDay', "");
    await prefs.setInt('streak', streak - 1);

    setState(() {
      previousCompletedDate = "";
      streak -= 1;
      toHighlight = currData;
    });
  }
}
