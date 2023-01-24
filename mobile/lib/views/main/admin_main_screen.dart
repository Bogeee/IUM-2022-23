import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proj/models/notifiers.dart';
import 'package:proj/views/main/admin_unbook/admin_unbook.dart';
import 'package:proj/views/main/profile/profile.dart';
import 'package:proj/views/main/search_lesson/admin_search_lesson.dart';
import 'package:proj/views/main/search_lesson/search_lesson.dart';
import 'package:provider/provider.dart';

class AdminMainScreen extends StatefulWidget{
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {

  int _oldIndex = 0;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeNotifier>(context).isDark;
    Color accent = Provider.of<ThemeNotifier>(context).accentColor;
    Color unselectedItemColor = isDark ? Colors.white54 : const Color(0xff0F172A);
    Color menuBackgroundColor = isDark ? Colors.white54 : const Color(0xfff0f0f0);
    Color appBarForegroundColor = isDark ? Colors.black : Colors.white;

    final List<Widget> _children = [
      const AdminSearchLessonPage(),
      const AdminUnbookPage(),
      const UserProfilePage()
    ];

    final List<Text> _appBarTitles = [
      const Text('Catalogo ripetizioni'),
      const Text('Disdici ripetizioni'),
      const Text('Profilo')
    ];

    return WillPopScope(
      onWillPop: () async {
        // prevent default behavior on Android back button pressed
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: accent,
          foregroundColor: appBarForegroundColor,
          automaticallyImplyLeading: false,
          title: _appBarTitles[_currentIndex],
        ),
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 200),
          reverse: _currentIndex < _oldIndex,
          transitionBuilder: (
            child,
            animation,
            secondaryAnimation,
          ) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
          child: _children[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: menuBackgroundColor,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          unselectedItemColor: unselectedItemColor,
          selectedItemColor: accent,
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/magnifying-glass-solid.svg",
                  color: _currentIndex == 0 ? accent : unselectedItemColor,
                  height: 16,
                ),
                label: "Catalogo",
                tooltip: "Catalogo"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/circle-xmark-regular.svg",
                  color: _currentIndex == 1 ? accent : unselectedItemColor,
                  height: 16,
                ),
                label: "Disdici",
                tooltip: "Disdici"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/circle-user-solid.svg",
                  color: _currentIndex == 2 ? accent : unselectedItemColor,
                  height: 16,
                ),
                label: "Profilo",
                tooltip: "Profilo"),
          ],
          onTap: (index) {
            setState(() {
              _oldIndex = _currentIndex;
              _currentIndex = index;
            });
          },
        )
      ),
    );
  }
}