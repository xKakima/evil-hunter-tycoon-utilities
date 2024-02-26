import 'dart:async';

import 'package:evil_hunter_tycoon_utilities/database/hunters_table.dart';
import 'package:evil_hunter_tycoon_utilities/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import './home.dart';
import 'hunter.dart';

Future<void> main() async {
  await Supabase.initialize(
      url: 'https://qxqgtvqjalxlkdmsuwxr.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF4cWd0dnFqYWx4bGtkbXN1d3hyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDg3NjM5MTQsImV4cCI6MjAyNDMzOTkxNH0.WjpW_9D9md2w6EYta6QvzyU_B9Xh-aln2_e_0imXuEc',
      postgrestOptions: PostgrestClientOptions(schema: 'eht'));

  runApp(const EHTApp());
}

class EHTApp extends StatefulWidget {
  const EHTApp({Key? key}) : super(key: key);

  @override
  _EHTAppState createState() => _EHTAppState();
}

class _EHTAppState extends State<EHTApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HunterState()),
        ChangeNotifierProvider(create: (context) => GearState()),
        // Add more providers as needed
      ],
      child: MaterialApp(
        initialRoute: '/',
        onGenerateRoute: (settings) {
          // Remove the query parameters from the route name
          final uri = Uri.parse(settings.name!);
          final path = uri.path;

          switch (path) {
            case '/':
              return MaterialPageRoute(
                  builder: (context) => supabase.auth.currentUser != null
                      ? MainAppPage()
                      : LoginPage());
            case '/main':
              return MaterialPageRoute(builder: (context) => MainAppPage());
            default:
              return MaterialPageRoute(builder: (context) => LoginPage());
          }
        },
      ),
    );
  }
}

class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key});

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  var selectedIndex = 0;
  var currentUser = supabase.auth.currentUser;
  final pageTitles = ['Hunters', 'Settings'];

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const HunterPage();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('EHT Utilities by Kakima - ${pageTitles[selectedIndex]}'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Welcome ${currentUser?.userMetadata?['full_name']}'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.build),
              title: Text('Gear Builder'),
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: page,
    );
  }
}
