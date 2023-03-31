import 'package:ekaant/bottom_nav.dart';
import 'package:ekaant/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodCheck extends StatelessWidget {
  const MoodCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.5,
      insetAnimationCurve: Curves.easeInOut,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        // color: ekaantBlue.withOpacity(0.3),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              "How do you feel now?",
              style: TextStyle(
                  fontSize: 25,
                  color: ekaantDarkGreen,
                  fontWeight: FontWeight.w600),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                createEmoji(MdiIcons.emoticonOutline, 0, context),
                const SizedBox(width: 15),
                createEmoji(MdiIcons.emoticonHappyOutline, 1, context),
                const SizedBox(width: 15),
                createEmoji(MdiIcons.emoticonNeutralOutline, 2, context),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                createEmoji(MdiIcons.emoticonSadOutline, 3, context),
                const SizedBox(width: 15),
                createEmoji(MdiIcons.emoticonCryOutline, 4, context),
              ],
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  Widget createEmoji(IconData icon, int iconID, BuildContext context) {
    return Container(
      constraints: const BoxConstraints.tightFor(width: 70, height: 70),
      decoration: const BoxDecoration(
        color: ekaantBlue,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: IconButton(
        onPressed: (() {
          updateMood(iconID);
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNav()),
          );
        }),
        icon: Icon(
          icon,
          size: 50,
          color: ekaantGreen,
        ),
      ),
    );
  }

  Future<void> updateMood(int iconID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> currMood =
        prefs.getStringList('moodData') ?? ['0', '0', '0', '0', '0'];
    currMood[iconID] = (int.parse(currMood[iconID]) + 1).toString();
    
    List<int> currMoodInt = currMood.map(int.parse).toList();

    prefs.setStringList('moodData', currMood);
  }
}
