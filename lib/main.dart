import 'package:Netflix/Screens/SEARCH.DART';
import 'package:Netflix/Screens/getstarted.dart';
import 'package:Netflix/Screens/homepage.dart';
import 'package:flutter/material.dart';
import 'Screens/MyList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/': (context) => getStarted(),
        '/home': (context) => MyHomePage(),
        '/search': (context) => SearchPage(),
        '/mylist': (context) => MyList(),
      },
    );
  }
}
