import 'package:fb/common/theme_data.dart';
import 'package:fb/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gregmus Budget',
      home: const HomePage(),
      theme: getThemeData(context),
      builder: EasyLoading.init(),
    );
  }
}
