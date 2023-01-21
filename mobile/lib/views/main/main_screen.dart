import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animations/animations.dart';
import 'package:proj/constants.dart';
import 'package:proj/views/main/profile/profile.dart';

// models
import 'package:provider/provider.dart';
import 'package:proj/models/notifiers.dart';

// Views
import 'package:proj/views/main/home/home.dart';

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
    Color menuBackgroundColor = isDark ? Colors.white54 : const Color(0xfff0f0f0);
    Color appBarForegroundColor = isDark ? Colors.black : Colors.white; 

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
      const Center(child: Text('Prenota')),
      const Center(child: Text('Storico')),
      const UserProfilePage()
      // SearchLessonPage(),
      // HistoryPage(),
      // ProfilePage()
    ];

    final List<Text> _appBarTitles = [
      const Text('Home'),
      const Text('Prenota'),
      const Text('Storico'),
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
                "assets/icons/house-solid.svg",
                color: _currentIndex == 0? accent : unselectedItemColor,
                height: 16,
              ),
              label: "Home",
              tooltip: "Home"
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/at-solid.svg",
                color: _currentIndex == 1 ? accent : unselectedItemColor,
                height: 16,
              ),
              label: "Prenota",
              tooltip: "Prenota"
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/at-solid.svg",
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
    );
  }
}
