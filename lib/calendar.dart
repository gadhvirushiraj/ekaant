import 'package:cron/cron.dart';
import 'package:ekaant/constants/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void initState() {
    reset();
    getData();
    super.initState();
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
        decoration: const BoxDecoration(
          color: ekaantBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 90),
          child: Padding(
            padding:
                const EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 20),
            child: Column(
              children: [
                TableCalendar(
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      if (toHighlight != []) {
                        for (String date in toHighlight) {
                          DateTime d = DateFormat("yyyy-MM-dd").parse(date);
                          if (day.day == d.day &&
                              day.month == d.month &&
                              day.year == d.year) {
                            return Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ekaantGreen,
                              ),
                              child: const Center(
                                child: Icon(Icons.check, color: Colors.white),
                              ),
                            );
                          }
                        }
                      }
                      return null;
                    },
                    todayBuilder: (context, day, focusedDay) {
                      if (toHighlight != []) {
                        for (String date in toHighlight) {
                          DateTime d = DateFormat("yyyy-MM-dd").parse(date);
                          if (day.day == d.day &&
                              day.month == d.month &&
                              day.year == d.year) {
                            return Container(
                              margin: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ekaantGreen,
                              ),
                              child: Center(
                                child: Text(DateTime.now().day.toString(),
                                    style: const TextStyle(fontSize: 16)),
                              ),
                            );
                          }
                        }
                      }
                      return null;
                    },
                  ),

                  //shouldFillViewport: true,
                  firstDay: DateTime.utc(2021, 11, 22),
                  lastDay: DateTime.utc(2030, 11, 22),
                  focusedDay: DateTime.now(),
                  //##################################################
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekendStyle: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    weekdayStyle: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  //##################################################
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      leftChevronIcon:
                          Icon(Icons.chevron_left, color: Colors.white),
                      rightChevronIcon:
                          Icon(Icons.chevron_right, color: Colors.white)),
                  //##################################################
                  calendarStyle: const CalendarStyle(
                    todayTextStyle: TextStyle(color: Colors.black),
                    outsideTextStyle: TextStyle(color: Colors.white60),
                    defaultTextStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                    weekendTextStyle: TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                analysisToday(),
                const SizedBox(
                  height: 12,
                ),
                Container(
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
                                            buildPicker(duration_Breath, 1)
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
      }
    } else {
      if (DateFormat("yyyy-MM-dd").format(DateTime.now()) ==
          previousCompletedDate) {
        removeToday();
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularPercentIndicator(
                            radius: 45,
                            lineWidth: 8,
                            percent: percent_breath,
                            circularStrokeCap: CircularStrokeCap.round,
                            reverse: true,
                            progressColor: ekaantDarkGreen,
                            backgroundColor: ekaantBlue,
                          ),
                          CircularPercentIndicator(
                            radius: 55,
                            lineWidth: 8,
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
                                      color: ekaantDarkGreen, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const VerticalDivider(
              color: Colors.black54,
              thickness: 2,
              indent: 5,
              endIndent: 5,
              width: 30,
            ),
            Expanded(
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
