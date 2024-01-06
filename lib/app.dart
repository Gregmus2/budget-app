import 'package:fb/common/theme_data.dart';
import 'package:fb/pages/home.dart';
import 'package:fb/pages/login.dart';
import 'package:fb/providers/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    StateProvider stateProvider = Provider.of<StateProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gregmus Budget',
      home: stateProvider.user != null ? const HomePage() : const LoginPage(),
      theme: getThemeData(context),
      builder: EasyLoading.init(),
    );
  }
}
