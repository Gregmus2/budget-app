import 'package:fb/category_circle.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: const ColorScheme.dark(
            primary: Colors.blue,
          )),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double progress = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CategoryCircle(progress: progress, primaryColor: Colors.blue),
            Slider(
              value: progress,
              max: 100,
              divisions: 100,
              label: progress.round().toString(),
              onChanged: (double value) {
                setState(() {
                  progress = value;
                });
              },
            ),
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

