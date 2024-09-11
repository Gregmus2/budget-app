import 'package:dynamic_color/dynamic_color.dart';
import 'package:fb/pages/home.dart';
import 'package:fb/providers/state.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  final Widget page;
  final Widget Function(BuildContext, Widget?)? builder;

  const App({super.key, required this.page, this.builder});

  @override
  Widget build(BuildContext context) {
    StateProvider state = Provider.of<StateProvider>(context);

    return DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme lightColorScheme;
      ColorScheme darkColorScheme;

      if (lightDynamic != null && darkDynamic != null) {
        lightColorScheme = lightDynamic.harmonized();
        darkColorScheme = darkDynamic.harmonized();
        // lightCustomColors = lightCustomColors.harmonized(lightColorScheme);
      } else {
        // Otherwise, use fallback schemes.
        lightColorScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue,
        );
        darkColorScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        );
      }

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gregmus Budget',
        home: page,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.nunitoSans().fontFamily,
          colorScheme: lightColorScheme,
          // extensions: [lightCustomColors],
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.nunitoSans().fontFamily,
          colorScheme: darkColorScheme,
        ),
        themeMode: state.themeMode,
        builder: builder,
      );
    });
  }
}
