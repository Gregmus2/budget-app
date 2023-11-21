import 'package:fb/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gregmus Budget',
      home: const HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(42, 45, 66, 1.0),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blue, foregroundColor: Colors.blue),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
        ),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      builder: EasyLoading.init(),
    );
  }
}
