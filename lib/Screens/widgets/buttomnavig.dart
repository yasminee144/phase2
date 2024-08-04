import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<dynamic> myList;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.myList,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.red,
      backgroundColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_library),
          label: 'My List',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app),
          label: 'SignOut',
        ),
      ],
      currentIndex: currentIndex,
      onTap: (index) {
        onTap(index);
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            Navigator.pushNamed(context, '/mylist', arguments: myList);
            break;
          case 2:
            Navigator.pushNamed(context, '/search');
            break;
          case 3:
            Navigator.pushNamed(context, '/');
            break;
        }
      },
      selectedLabelStyle: TextStyle(color: Colors.white),
      unselectedLabelStyle: TextStyle(color: Colors.white),
    );
  }
}

class CustomBottomNavigationBarX extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBarX({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.red,
      backgroundColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_library),
          label: 'My List',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app),
          label: 'SignOut',
        ),
      ],
      currentIndex: currentIndex,
      onTap: (index) {
        onTap(index);
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            Navigator.pushNamed(context, '/mylist');
            break;
          case 2:
            Navigator.pushNamed(context, '/search');
            break;
          case 3:
            Navigator.pushNamed(context, '/');
            break;
        }
      },
      selectedLabelStyle: TextStyle(color: Colors.white),
      unselectedLabelStyle: TextStyle(color: Colors.white),
    );
  }
}
