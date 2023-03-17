import 'package:ekaant/breathing-excercise/breath_selection.dart';
import 'package:ekaant/constants/color.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:flutter/material.dart';

List<TargetFocus> home_target({
  required GlobalKey calendar_key,
  required GlobalKey indicator_key,
  required GlobalKey streak_key,
  required GlobalKey goal_key,
}) {
  List<TargetFocus> targets = [];

  targets.add(
    TargetFocus(
      keyTarget: calendar_key,
      enableOverlayTab: true,
      shape: ShapeLightFocus.RRect,
      borderSide: const BorderSide(width: 1, color: Colors.white),
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: const [
                  Text(
                    "Welcome to Ekaant!",
                    style: TextStyle(
                      color: ekaantGreen,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "View your monthly performance here. It's currently empty, but completing your daily goals will highlight that day in green.",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Tap to NEXT",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Hind',
                        fontWeight: FontWeight.w100),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
          },
        ),
      ],
    ),
  );

  targets.add(
    TargetFocus(
      keyTarget: indicator_key,
      enableOverlayTab: true,
      shape: ShapeLightFocus.Circle,
      borderSide: const BorderSide(width: 1, color: Colors.white),
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Track daily progress here,\n\nOuter Ring for Breathing Excercise\nInner Ring for Meditation",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );

  targets.add(
    TargetFocus(
      keyTarget: streak_key,
      enableOverlayTab: true,
      shape: ShapeLightFocus.Circle,
      borderSide: const BorderSide(width: 1, color: Colors.white),
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Your Goal Completion Streak",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );

  targets.add(
    TargetFocus(
      keyTarget: goal_key,
      enableOverlayTab: true,
      shape: ShapeLightFocus.RRect,
      borderSide: const BorderSide(width: 1, color: Colors.white),
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Set your Daily Goals here !\n",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "After tutorial, click timer icon to start your first session.",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                        fontSize: 20,
                        fontFamily: 'Hind'),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );

  return targets;
}
