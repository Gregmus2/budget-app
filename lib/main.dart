import 'package:fb/pages/categories.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Repository repo = Repository();
  await repo.init();

  CategoryProvider catProvider = CategoryProvider(repo);
  await catProvider.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => catProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gregmus Budget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(42, 45, 66, 1.0),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
        ),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const CategoriesPage(),
    );
  }
}
