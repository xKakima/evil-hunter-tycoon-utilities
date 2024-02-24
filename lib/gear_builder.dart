import 'package:evil_hunter_tycoon_utilities/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GearBuilder extends StatefulWidget {
  const GearBuilder({super.key});

  @override
  State<GearBuilder> createState() => _GearBuilderState();
}

class _GearBuilderState extends State<GearBuilder> {
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
          final inputFieldController = TextEditingController();
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
                const Gear(),
                ElevatedButton(
                    onPressed: () {
                      hunterState.saveHunter(inputFieldController.text);

                      var hunterName = hunterState.savedHunters[index].name;
                      if (kDebugMode) {
                        print('Save Hunter');
                        print("Current Index: $index");
                        print("Hunter Name: $hunterName");
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

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

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

enum HunterType { dps, tank }

class HunterBaseClass {
  final String name;
  final List<String> secondJobs;
  final List<String> thirdJobs;
  HunterType hunterType = HunterType.dps;

  Map<String, dynamic> toJson() {
    return {
      // Return a map that represents the object.
      // For example, if your class has a field named 'name', you might do:
      // 'name': name,
    };
  }

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

  Hunter({required this.name, required this.hunterClass, required this.stats});

  Map<String, dynamic> toJson() {
    return {
      // Include fields from HunterBaseClass
      // Include fields from Hunter
      'name': name,
      'hunterClass': hunterClass,
      'stats': stats,
    };
  }

  factory Hunter.fromJson(Map<String, dynamic> json) {
    return Hunter(
      name: json['name'],
      hunterClass: json['hunterClass'],
      stats: Map<String, int>.from(json['stats']),
    );
  }
}

class GearBuilderPage extends StatefulWidget {
  const GearBuilderPage({super.key});

  @override
  State<GearBuilderPage> createState() => _GearBuilderPageState();
}

class _GearBuilderPageState extends State<GearBuilderPage> {
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    var hunterState = context.read<HunterState>();

    // hunterState.loadHunters();
    // Add your on-mount code here.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var hunterState = context.read<HunterState>();

    if (hunterState.savedHunters.isEmpty) {
      Future.microtask(() => hunterState.createHunter());
    }
    // Initialization that depends on the BuildContext can go here.
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
                child: const GearBuilder(),
              ),
            ),
          ],
        ),
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
