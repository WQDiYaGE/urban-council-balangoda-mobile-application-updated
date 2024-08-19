import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:urban_council/screens/announcement_screen.dart';
import 'package:urban_council/screens/chat_screen.dart';
import 'package:urban_council/screens/dashboard_screen.dart';

class DashScreen extends StatefulWidget {
  @override
  _DashScreenState createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  int _selectedIndex = 0;

  // List of pages for each tab
  static const List<Widget> _pages = <Widget>[
    DashboardScreen(),
    AnnouncementScreen(),
    ChatScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/home.svg',
              color: _selectedIndex == 0
                  ? Colors.grey[800]
                  : const Color(0xFF757575),
              height: 21,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/announce_new.svg',
              height: 21,
            ),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/chat.svg',
              color: _selectedIndex == 2
                  ? Colors.grey[800]
                  : const Color(0xFF757575),
              height: 21,
            ),
            label: 'Chat',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color(0xFF757575),
        unselectedFontSize: 12,
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        selectedItemColor: Colors.grey[800],
        selectedFontSize: 12,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
