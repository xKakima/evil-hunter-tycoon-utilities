import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BuilderState()),
        ChangeNotifierProvider(create: (context) => HunterState()),
        // Add more providers as needed
      ],
      child: MaterialApp(
        title: 'Evil Hunter Tycoon Helper',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class BuilderState extends ChangeNotifier {}

class HunterState extends ChangeNotifier {
  late Hunter newHunter;

  var savedHunters = <Hunter>[];

  void createHunter() {
    newHunter = Hunter();
    savedHunters.add(newHunter);
    notifyListeners();
    print("Created Hunter");
  }
}

Map<String, HunterBaseClass> hunterClasses = {
  "Berserker": HunterBaseClass("Berserker", ["duelist", "warrior", "slayer"],
      ["barbarian", "swordSaint", "destroyer"]),
  "Sorceror": HunterBaseClass("Sorceror", ["archMage", "darkMage", "ignis"],
      ["conjuror", "darkLord", "illusionist"]),
  "Paladin": HunterBaseClass("Paladin", ["crusader", "templar", "darkPaladin"],
      ["guardian", "inquisitor", "executor"]),
  "Archer": HunterBaseClass("Archer", ["duelist", "warrior", "slayer"],
      ["ministrel", "scout", "arcaneArcher"]),
};

class HunterBaseClass {
  final String name;
  final List<String> secondJobs;
  final List<String> thirdJobs;

  HunterBaseClass(this.name, this.secondJobs, this.thirdJobs);
}

class Hunter {
  var name = "New Hunter";
  var hunterClass = hunterClasses["Berserker"];
  var stats = {
    "HP": 0,
    "Attack": 0,
    "Defense": 0,
    "CritChance": 0,
    "AttackSpeed": 0,
    "Evasion": 0,
  };
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var hunterState = context.watch<HunterState>();

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: GearBuilder(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Creating Hunter");
            hunterState.createHunter();
          },
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add),
                  SizedBox(height: 2), // Add spacing
                  Text("New Hunter", style: TextStyle(fontSize: 16.0)),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    });
  }
}

class GearBuilder extends StatefulWidget {
  @override
  State<GearBuilder> createState() => _GearBuilderState();
}

class _GearBuilderState extends State<GearBuilder> {
  @override
  Widget build(BuildContext context) {
    var hunterState = context.watch<HunterState>();
    var classDropDownValue = "Berserker";
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 750, // Maximum pixel width of a grid item
          childAspectRatio: 3 / 2, // Width/Height ratio of grid items
          crossAxisSpacing: 20, // Horizontal spacing between grid items
          mainAxisSpacing: 20, // Vertical spacing between grid items
        ),
        itemCount: hunterState.savedHunters.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              //Make border curved
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Hunter Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                Expanded(
                    child: DropdownButtonFormField(
                  isExpanded: true,
                  value: classDropDownValue,
                  onChanged: (newValue) {
                    setState(() {
                      print("previous Value $classDropDownValue");
                      classDropDownValue = newValue.toString();
                      print("new Value $classDropDownValue");
                    });
                    // print("new Value $newValue");
                    // hunterState.newHunter.hunterClass =
                    //     newValue! as HunterBaseClass?;
                  },
                  items: hunterClasses.keys
                      .map<DropdownMenuItem<String>>((String key) {
                    return DropdownMenuItem<String>(
                      value: key,
                      child: Center(child: Text(key)),
                    );
                  }).toList(),
                )),
                ElevatedButton(
                    onPressed: () {
                      print('Save Hunter');
                    },
                    child: Text('Save Hunter '))
              ],
            ),
          );
        },
      ),
    );
  }
}
