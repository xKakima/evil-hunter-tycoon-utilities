import 'dart:async';
import 'package:evil_hunter_tycoon_utilities/gear/gear.dart';
import 'package:evil_hunter_tycoon_utilities/database/classes.dart';
import 'package:evil_hunter_tycoon_utilities/builder/builder.dart';
import 'package:evil_hunter_tycoon_utilities/login.dart';
import 'package:evil_hunter_tycoon_utilities/utils.dart';
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
      postgrestOptions: const PostgrestClientOptions(schema: 'eht'));

  var baseClassesData = await fetchBaseClasses();
  var secondClassesData = await fetchSecondClasses();
  var thirdClassesData = await fetchThirdClasses();

  var parser = HunterClassParsers();

  var baseClasses = parser.classParser(baseClassesData);
  var secondClasses = parser.classParser(secondClassesData);
  var thirdClasses = parser.classParser(thirdClassesData);

  print("Base classes: $baseClasses");
  print("Second classes: $secondClasses");
  print("Third classes: $thirdClasses");

  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          EHTState()..setClassData(baseClasses, secondClasses, thirdClasses),
      child: const EHTApp(),
    ),
  );
}

class EHTState extends ChangeNotifier {
  Map<String, String>? baseClasses;
  Map<String, String>? secondClasses;
  Map<String, String>? thirdClasses;

  void setClassData(Map<String, String> base, Map<String, String> second,
      Map<String, String> third) {
    baseClasses = base;
    secondClasses = second;
    thirdClasses = third;
    notifyListeners();
  }
}

class EHTApp extends StatefulWidget {
  const EHTApp({Key? key}) : super(key: key);

  @override
  _EHTAppState createState() => _EHTAppState();
}

class _EHTAppState extends State<EHTApp> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HunterState()),
        // ChangeNotifierProvider(create: (context) => GearState()),
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
                      ? const MainAppPage()
                      : const LoginPage());
            case '/main':
              return MaterialPageRoute(
                  builder: (context) => const MainAppPage());
            case '/gear':
              return MaterialPageRoute(
                  builder: (context) => const BuilderPage());
            case '/builder':
              return MaterialPageRoute(
                  builder: (context) => const BuilderPage());
            default:
              return MaterialPageRoute(builder: (context) => const LoginPage());
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
  final supabase = Supabase.instance.client;
  var selectedIndex = 0;
  final pageTitles = [
    'Hunters',
    'Gears',
    'Hunter and Gear Builder',
    'Settings'
  ];
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = supabase.auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const HunterPage();
        break;
      case 1:
        page = const GearPage();
      case 2:
        page = const BuilderPage();
      case 3:
        page = const Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('EHT Utilities by Kakima - ${pageTitles[selectedIndex]}'),
        foregroundColor: Colors.black,
        backgroundColor: const Color.fromRGBO(101, 135, 172, 1.0),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Welcome ${currentUser?.userMetadata?['full_name']}'),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Hunters'),
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shield),
              title: const Text('Gears'),
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.handyman),
              title: const Text('Hunter and Gear Builder'),
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                setState(() {
                  selectedIndex = 3;
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
