import 'dart:io';
import 'package:darlehensrechner/graph.dart';
import 'package:darlehensrechner/table.dart';
import 'package:flutter/foundation.dart';
import 'package:window_size/window_size.dart';
import 'package:darlehensrechner/calculator.dart';
import 'package:flutter/material.dart';

void main() {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isLinux || Platform.isWindows) {
      setWindowMinSize(const Size(600, 600));
      setWindowMinSize(const Size(1080, 1080));
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Darlehensrechner',
      darkTheme: ThemeData.dark(),
      home: const TabMain(),
    );
  }
}

class TabMain extends StatefulWidget {
  const TabMain({super.key});

  @override
  State<TabMain> createState() => _TabMainState();
}

class _TabMainState extends State<TabMain> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Rechner",
                ),
                Tab(
                  text: "Graph",
                ),
                Tab(
                  text: "Tabelle",
                )
              ],
            ),
            title: const Text("Darlehensrechner"),
          ),
          body:
              const TabBarView(children: [Calculator(), Graph(), TableView()]),
        ));
  }
}
