import 'package:flutter/material.dart';
import 'screens/news_list_screen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialColor myColor = MaterialColor(0xFF0B8C16, {
      50: Color(0xFF0B8C16),
      100: Color(0xFF0B8C16),
      200: Color(0xFF0B8C16),
      300: Color(0xFF0B8C16),
      400: Color(0xFF0B8C16),
      500: Color(0xFF0B8C16),
      600: Color(0xFF0B8C16),
      700: Color(0xFF0B8C16),
      800: Color(0xFF0B8C16),
      900: Color(0xFF0B8C16),
    });

    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: myColor,
      ),
      home: NewsListScreen(),
    );
  }
}