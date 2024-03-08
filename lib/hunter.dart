import 'package:evil_hunter_tycoon_utilities/database/hunters_table.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

List<String> hunterBaseClass = [
  "Berserker",
  "Sorceror",
  "Paladin",
  "Archer",
];

Map<String, List<String>> hunterSecondClass = {
  "Berserker": ["Duelist", "Warrior", "Slayer"],
  "Sorceror": ["Archmage", "Darkmage", "Ignis"],
  "Paladin": ["Crusader", "Templar", "Darkpaladin"],
  "Archer": ["Hawkeye", "Sniper", "Summonarcher"],
};

Map<String, List<String>> hunterThirdClass = {
  "Berserker": ["Barbarian", "Swordsaint", "Destroyer"],
  "Sorceror": ["Conjuror", "DarkLord", "Illusionist"],
  "Paladin": ["Guardian", "Inquisitor", "Executor"],
  "Archer": ["Ministrel", "Scout", "Arcanearcher"],
};

enum HunterType { dps, tank }

class Hunter {
  final String name;
  final String baseClass;
  final String secondClass;
  final String thirdClass;
  HunterType hunterType = HunterType.dps;
  Map<String, int> stats;

  Hunter({
    required this.name,
    required this.baseClass,
    required this.secondClass,
    required this.thirdClass,
    required this.stats,
  });

  factory Hunter.fromJson(Map<String, dynamic> json) {
    print("Parsing Hunter from Json: $json");
    return Hunter(
      name: json['name'],
      baseClass: json['baseClass'],
      secondClass: json['secondClass'],
      thirdClass: json['thirdClass'],
      stats: Map<String, int>.from(json['stats']),
    );
  }
}

class HunterState extends ChangeNotifier {
  late Hunter newHunter;

// Update this add a new list since savedHunters should only contain hunters that are "SAVED" not only created
  var savedHunters = <Hunter>[];

  void createHunter() {
    var newHunter = Hunter(
      name: "New Hunter",
      baseClass: hunterBaseClass[0],
      secondClass: hunterSecondClass[hunterBaseClass.isNotEmpty
              ? hunterBaseClass[0]
              : 'Berserker']?[0] ??
          'Duelist',
      thirdClass: hunterThirdClass[hunterBaseClass.isNotEmpty
              ? hunterBaseClass[0]
              : 'Berserker']?[0] ??
          'Swordsaint',
      stats: {
        "HP": 0,
        "Attack": 0,
        "Defense": 0,
        "CritChance": 0,
        "AttackSpeed": 0,
        "Evasion": 0,
      },
    );

    savedHunters.add(newHunter);
    print("SavedHunters: $savedHunters");
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

  void saveHunter(hunter, context) {
    // savedHunters.add(hunter);
    upsertHunter(hunter, context);
    notifyListeners();
  }
}

class HunterBuilder extends StatefulWidget {
  const HunterBuilder({super.key});

  @override
  State<HunterBuilder> createState() => HunterBuilderState();
}

class HunterBuilderState extends State<HunterBuilder> {
  // Global Widget Variables
  final inputFieldController = TextEditingController(text: "New Hunter");

  @override
  void dispose() {
    inputFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hunterState = context.watch<HunterState>();
    var classDropDownValue = "Berserker";

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 750, // Maximum pixel width of a grid item
          childAspectRatio: 3 / 2, // Width/Height ratio of grid items
          crossAxisSpacing: 20, // Horizontal spacing between grid items
          mainAxisSpacing: 20, // Vertical spacing between grid items
        ),
        itemCount: hunterState.savedHunters.length,
        itemBuilder: (context, index) {
          var widgetHunter;
          final inputFieldController =
              TextEditingController(text: hunterState.savedHunters[index].name);
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              //Make border curved
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  controller: inputFieldController,
                  decoration: const InputDecoration(
                    labelText: "Hunter Name",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    border: OutlineInputBorder(),
                  ),
                ),
                Expanded(
                    child: DropdownButtonFormField(
                  isExpanded: true,
                  value: classDropDownValue,
                  onChanged: (newValue) {
                    setState(() {
                      if (kDebugMode) {
                        print("previous Value $classDropDownValue");
                      }
                      classDropDownValue = newValue.toString();
                      if (kDebugMode) {
                        print("new Value $classDropDownValue");
                      }
                    });
                  },
                  items: hunterBaseClass
                      .map<DropdownMenuItem<String>>((String key) {
                    return DropdownMenuItem<String>(
                      value: key,
                      child: Center(child: Text(key)),
                    );
                  }).toList(),
                )),
                const Gear(),
                ElevatedButton(
                    onPressed: () {
                      widgetHunter = new Hunter(
                          name: inputFieldController.text,
                          baseClass: classDropDownValue,
                          secondClass:
                              hunterSecondClass[classDropDownValue]![0],
                          thirdClass: hunterThirdClass[classDropDownValue]![0],
                          stats: {
                            "HP": 0,
                            "Attack": 0,
                            "Defense": 0,
                            "CritChance": 0,
                            "AttackSpeed": 0,
                            "Evasion": 0,
                          });
                      hunterState.saveHunter(widgetHunter, context);
                      if (kDebugMode) {
                        print('Save Hunter');
                        print("Current Index: $index");
                      }
                    },
                    child: const Text('Save Hunter '))
              ],
            ),
          );
        },
      ),
    );
  }
}

class Gear extends StatefulWidget {
  const Gear({super.key});

  @override
  State<Gear> createState() => _GearState();
}

class _GearState extends State<Gear> {
  GearType? gearDropDownValue;

  @override
  Widget build(BuildContext context) {
    var gearState = context.watch<GearState>();

    gearDropDownValue ??= gearState.gearType;
    return Expanded(
      child: Column(
        children: [
          Expanded(
              child: DropdownButtonFormField<GearType>(
            isExpanded: true,
            value: gearDropDownValue,
            onChanged: (newValue) {
              setState(() {
                if (kDebugMode) {
                  print("previous Value $gearDropDownValue");
                }
                gearDropDownValue = newValue!;
                if (kDebugMode) {
                  print("new Value $gearDropDownValue");
                }
              });
            },
            items: GearType.values
                .map<DropdownMenuItem<GearType>>((GearType value) {
              return DropdownMenuItem<GearType>(
                value: value,
                child: Center(
                    child: Text(capitalize(value.toString().split('.').last))),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }
}

class HunterPage extends StatefulWidget {
  const HunterPage({super.key});

  @override
  State<HunterPage> createState() => _HunterPageState();
}

class _HunterPageState extends State<HunterPage> {
  var selectedIndex = 0;
  List<Hunter> hunters = [];
  bool _fetchedHunters = false;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    if (!_fetchedHunters) {
      var hunterState = context.read<HunterState>();

      var response = await fetchHunters();
      print(response);
      print("is hunters empty: ${response.isEmpty}");

      if (response.isEmpty) {
        Future.microtask(() => hunterState.createHunter());
      } else {
        response.forEach((hunter) => hunters.add(Hunter.fromJson(hunter)));
        hunterState.saveHuntersFromDatabase(hunters);
        print(hunterState.savedHunters);
      }

      _fetchedHunters = true;
    }
  }

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
                child: const HunterBuilder(),
              ),
            ),
          ],
        ),
        floatingActionButton: LayoutBuilder(
          builder: (context, constraints) {
            double buttonSize = constraints.biggest.width * 0.15;
            double clampedSize = buttonSize.clamp(60.0, 100.0);

            return Container(
              width: clampedSize,
              height: clampedSize,
              child: FloatingActionButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("Creating Hunter");
                  }
                  hunterState.createHunter();
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FittedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, size: 30.0),
                        SizedBox(height: 5), // Add spacing
                        Text("New Hunter", style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    });
  }
}

enum GearType { weapon, hat, armor, glove, shoe, belt, necklace, ring }

enum GearVariant { ancient, primal, original, chaos }

List<String> gearLines = [
  ...offensiveGearLines,
  ...survivabilityGearLines,
];

List<String> offensiveGearLines = [
  "Increase ATK SPD by {x}%",
  "Increase Critical Hit chance by {x}%",
  ...racialDamageGearLines,
  "Increase Critical Hit damage by {x}%",
  "Increase ATK {x}%",
];

List<String> survivabilityGearLines = [
  "Increase Evasion by {x}%",
  "Increase HP {x}%",
  "Increase DEF {x}%",
  "Lifesteal {x}% of total damage",
  "{x}% chance of decreasing damage taken by {y}%"
];

List<String> racialDamageGearLines = [
  "Increase {x}% damage against Demon Types",
  "Increase {x}% damage against Undead Types",
  "Increase {x}% damage against Primate Types",
  "Increase Against Boss type {x}% damage",
  "Increase {x}% damage against Animal Types",
];

class GearState extends ChangeNotifier {
  GearType gearType = GearType.hat;
  GearVariant gearVariant = GearVariant.ancient;
  var gearLinesOptions = gearLines;

  var itemGearLines = [];
  int lineCount = 3;

  int calculateLineCountByGearVariant() {
    if (gearVariant == GearVariant.ancient ||
        gearVariant == GearVariant.primal) {
      return 3;
    } else if (gearVariant == GearVariant.original) {
      return 4;
    } else {
      return 5;
    }
  }
}
