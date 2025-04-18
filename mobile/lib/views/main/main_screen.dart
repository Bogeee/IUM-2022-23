import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animations/animations.dart';

// constants
import 'package:proj/constants.dart';
import 'package:proj/models/user.dart';
import 'package:proj/views/main/admin_main_screen.dart';

// models
import 'package:provider/provider.dart';
import 'package:proj/models/notifiers.dart';

// Views
import 'package:proj/views/main/home/home.dart';
import 'package:proj/views/main/history/history.dart';
import 'package:proj/views/main/profile/profile.dart';
import 'package:proj/views/main/search_lesson/search_lesson.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _oldIndex = 0;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeNotifier>(context).isDark;
    Color accent = Provider.of<ThemeNotifier>(context).accentColor;
    Color unselectedItemColor = isDark ? Colors.white54 : const Color(0xff0F172A);
    Color appBarForegroundColor = isDark ? Colors.black : Colors.white;
    User? userInfo = Provider.of<LoggedInNotifier>(context).userDetails;

    final Map<String, int> _pageIndexes = {
      'Home' : 0,
      'Prenota' : 1,
      'Storico' : 2,
      'Profilo' : 3
    };

    void _setBookPage() {
      setState(() {
        _currentIndex = _pageIndexes['Prenota']!;
      });
    }

    void _changePage(String mainScreenRoute) {
      setState(() {
        _currentIndex = _pageIndexes[mainScreenRoute]!;
      });
    }

    final List<Widget> _children = [
      UserHomePage(changePageCallback: _setBookPage),
      const SearchLessonPage(),
      UserHistoryPage(changePageCallback: _setBookPage),
      const UserProfilePage()
    ];

    final List<Text> _appBarTitles = [
      const Text('Home'),
      const Text('Prenota'),
      const Text('Storico'),
      const Text('Profilo')
    ];

    return !userInfo.isAdmin
      ? WillPopScope(
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
                      "assets/icons/house-solid.svg",
                      color: _currentIndex == 0? accent : unselectedItemColor,
                      height: 16,
                    ),
                    label: "Home",
                    tooltip: "Home"
                  ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/magnifying-glass-solid.svg",
                    color: _currentIndex == 1 ? accent : unselectedItemColor,
                    height: 16,
                  ),
                  label: "Prenota",
                  tooltip: "Prenota"
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/box-archive-solid.svg",
                    color: _currentIndex == 2 ? accent : unselectedItemColor,
                    height: 16,
                  ),
                  label: "Storico",
                  tooltip: "Storico"
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/circle-user-solid.svg",
                    color: _currentIndex == 3 ? accent : unselectedItemColor,
                    height: 16,
                  ),
                  label: "Profilo",
                  tooltip: "Profilo"
                ),
              ],
              onTap: (index) {
                setState(() {
                  _oldIndex = _currentIndex;
                  _currentIndex = index;
                });
              },
            )
          ),
        )
      : const AdminMainScreen();
  }
}
