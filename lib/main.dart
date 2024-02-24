import 'package:evil_hunter_tycoon_utilities/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './home.dart';
import 'gear_builder.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://qxqgtvqjalxlkdmsuwxr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF4cWd0dnFqYWx4bGtkbXN1d3hyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDg3NjM5MTQsImV4cCI6MjAyNDMzOTkxNH0.WjpW_9D9md2w6EYta6QvzyU_B9Xh-aln2_e_0imXuEc',
  );

  runApp(const EHTApp());
}

class EHTApp extends StatelessWidget {
  const EHTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HunterState()),
        ChangeNotifierProvider(create: (context) => GearState()),
        // Add more providers as needed
      ],
      child: MaterialApp(
        title: 'Evil Hunter Tycoon Helper by Kakima',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 207, 227, 240)),
        ),
        home: const MainAppPage(),
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

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
      page = const LoginPage();
      case 1:
        page = const HomePage();
        break;
      case 2:
        page = const GearBuilderPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: homeBody(constraints, context, page),
      );
    });
  }

  Row homeBody(BoxConstraints constraints, BuildContext context, Widget page) {
    return Row(
      children: [
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: NavigationRail(
                  backgroundColor: const Color.fromARGB(255, 118, 177, 225),
                  extended: constraints.maxWidth >= 600,
                  leading: const Flexible(
                      child: Text('EHT Helper by Kakima',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ))),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_filled),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.build),
                      label: Text('Gear Builder'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: page,
          ),
        ),
      ],
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

  void saveHunter(name) {
    newHunter.name = name;
    savedHunters.add(newHunter);
    // saveData('$name', 'test');
    if (kDebugMode) {
      print("saved Hunters $savedHunters");
    }
    // Assuming savedHunters is your list of Hunter instances
    // String savedHuntersJson =
    //     jsonEncode(savedHunters.map((hunter) => hunter.toJson()).toList());

// Then, you can call the save method on your Storage instance
    // Storage().save("Hunters", savedHuntersJson);
  }

  // void saveData(key, value) async {
  //   final storage = Storage();
  //   storage.save(key, value);
  // }

  // void loadHunters() async {
  //   final storage = Storage();
  //   if (kDebugMode) {
  //     print(storage.load('Hunters'));
  //   }
  // }
}
