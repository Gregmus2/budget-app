import 'package:english_words/english_words.dart';
import 'package:fb/models.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/repository.dart';
import 'package:fb/ui/category.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Repository repo = Repository();
  await repo.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => CategoryProvider(repo),
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
          Theme
              .of(context)
              .textTheme,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    List<IconData> icons = [
      Icons.add_shopping_cart,
      Icons.access_alarm, Icons.call, Icons.laptop
    ];
    List<CategoryStat> categories = [];
    final CategoryProvider provider = Provider.of<CategoryProvider>(context);
    final Random random = Random();
    // mock data
    for (var i = 0; i < provider.length; i++) {
      int total = random.nextInt(1000);
      categories.add(CategoryStat(
          provider.get(i), total - random.nextInt(total), total, '\$'));
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Placeholder()),
                  );
                },
                icon: const Icon(Icons.edit))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            provider.add(Category(id: random.nextInt(100),
                name: WordPair
                    .random()
                    .asPascalCase,
                icon: icons[random.nextInt(icons.length)],
                color: Color((random.nextDouble() * 0xFFFFFF).toInt())));
          },
          child: const Icon(Icons.add),
        ),
        body: _buildGrid(
            categories) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Widget _buildGrid(List<CategoryStat> categories) =>
    GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 16,
          mainAxisExtent: 120),
      itemBuilder: (context, int index) {
        return CategoryCard(
          progress: categories[index].total / 100 * categories[index].left,
          color: categories[index].category.color,
          category: categories[index].category.name,
          left: '${categories[index].left}\$',
          total: '${categories[index].total}\$',
          icon: categories[index].category.icon,
        );
      },
    );
