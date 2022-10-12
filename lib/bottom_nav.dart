import 'package:ekaant/calendar.dart';
import 'package:ekaant/timer_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;
  final screens = [Calendar(), TimerSelection()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xff00c29a),
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
              unselectedItemColor: const Color(0xff0c0d1b).withOpacity(0.7),
              backgroundColor: const Color(0xff00c29a),
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
                  icon: Icon(
                    Icons.home,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.timelapse,
                  ),
                  label: 'Timer',
                )
              ]),
        ),
      ),
      body: screens[currentIndex],
    );
  }
}
