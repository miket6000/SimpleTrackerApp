import 'package:flutter/material.dart';
import 'screens/overview_screen.dart';
import 'screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'providers/serial_provider.dart';
import 'screens/terminal_screen.dart';

/*
void main() {
  runApp(SimpleTrackerApp());
}
*/

// change notifier based start, for when I get around to implementing SerialConnection.
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SerialProvider(),
      child: SimpleTrackerApp(),
    ),
  );
}

class SimpleTrackerApp extends StatelessWidget {
  const SimpleTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimpleTracker',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3, // Number of tabs
        child: MyHomePage(),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SimpleTracker'),
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home), text: "Overview"),
            Tab(icon: Icon(Icons.text_fields_rounded), text: "Serial Connection"),
            Tab(icon: Icon(Icons.settings), text: "Settings"),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          OverviewScreen(),
          TerminalScreen(),
          SettingPage(),
        ],
      ),
    );
  }
}
