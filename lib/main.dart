import 'dart:async';

import 'package:evil_hunter_tycoon_utilities/database/hunters_table.dart';
import 'package:evil_hunter_tycoon_utilities/login.dart';
import 'package:flutter/foundation.dart';
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
  User? _user;
  late StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    super.initState();

    // Listen for changes in the user's authentication state
    _authStateSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      setState(() {
        _user = event.session?.user;
      });
    });
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

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
                  builder: (context) =>
                      _user != null ? MainAppPage() : LoginPage());
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
              child: Text('Change Current User Name Here'),
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

class HunterState extends ChangeNotifier {
  late Hunter newHunter;

// Update this add a new list since savedHunters should only contain hunters that are "SAVED" not only created
  var savedHunters = <Hunter>[];

  void createHunter() {
    newHunter = Hunter(
        name: "New Hunter",
        hunterClass: hunterClasses["Berserker"],
        stats: {
          "HP": 0,
          "Attack": 0,
          "Defense": 0,
          "CritChance": 0,
          "AttackSpeed": 0,
          "Evasion": 0,
        });
    savedHunters.add(newHunter);
    notifyListeners();
    if (kDebugMode) {
      print("Created Hunter");
    }
  }

  void saveHuntersFromDatabase(hunters) {
    print("hunters from db ${hunters}");
    savedHunters = hunters;
    notifyListeners();
    if (kDebugMode) {
      print("Saved Hunter");
    }
  }

  void saveHunter(name) {
    newHunter.name = name;
    savedHunters.add(newHunter);
    createOrSaveHunter(name);
  }
}
