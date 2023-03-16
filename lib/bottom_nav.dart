import 'package:ekaant/breathing-excercise/breath_selection.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ekaant/calendar.dart';
import 'package:ekaant/constants/color.dart';
import 'package:ekaant/meditation-timer/timer_selection.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 1;
  final screens = [Breath(), Calendar(), TimerSelection()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
          child: BottomNavigationBar(
              unselectedItemColor: ekaantBlue.withOpacity(0.7),
              backgroundColor: ekaantGreen,
              selectedItemColor: Colors.white,
              showUnselectedLabels: false,
              selectedFontSize: 16,
              currentIndex: currentIndex,
              onTap: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(MdiIcons.meditation),
                  label: 'Breath',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    MdiIcons.homeVariantOutline,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.timelapse,
                  ),
                  label: 'Timer',
                ),
              ]),
        ),
      ),
      body: screens[currentIndex],
    );
  }
}
