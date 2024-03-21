import 'package:evil_hunter_tycoon_utilities/database/hunters_table.dart';
import 'package:evil_hunter_tycoon_utilities/main.dart';
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
  bool isFromDB;
  HunterType hunterType = HunterType.dps;
  // late Map<String, int> stats;

  Hunter({
    required this.name,
    required this.baseClass,
    required this.secondClass,
    required this.thirdClass,
    required this.isFromDB,
  });

  factory Hunter.fromJson(Map<String, dynamic> json, EHTState ehtState) {
    print("Parsing Hunter from Json: $json");

    var baseClassKey = ehtState.baseClasses?.keys.firstWhere(
        (k) => ehtState.baseClasses?[k] == json['base_class'],
        orElse: () => '');
    var secondClassKey = ehtState.secondClasses?.keys.firstWhere(
        (k) => ehtState.secondClasses?[k] == json['second_class'],
        orElse: () => '');
    var thirdClassKey = ehtState.thirdClasses?.keys.firstWhere(
        (k) => ehtState.thirdClasses?[k] == json['third_class'],
        orElse: () => '');
    print("Base Class Key: $baseClassKey");
    print("Second Class Key: $secondClassKey");
    print("Third Class Key: $thirdClassKey");
    return Hunter(
      name: json['name'],
      baseClass: baseClassKey!,
      secondClass: secondClassKey!,
      thirdClass: thirdClassKey!,
      isFromDB: true,
      // stats: Map<String, int>.from(json['stats']),
    );
  }
  @override
  String toString() {
    return 'Hunter: {name: $name, baseClass: $baseClass, secondClass: $secondClass, thirdClass: $thirdClass';
  }
}

class HunterState extends ChangeNotifier {
  late Hunter newHunter;
  var hunters = <Hunter>[];

  void createHunter() {
    var newHunter = Hunter(
      name: "",
      baseClass: hunterBaseClass.isNotEmpty ? hunterBaseClass[0] : 'Beserker',
      secondClass: hunterBaseClass.isNotEmpty &&
              hunterSecondClass.containsKey(hunterBaseClass[0]) &&
              hunterSecondClass[hunterBaseClass[0]]!.isNotEmpty
          ? hunterSecondClass[hunterBaseClass[0]]![0]
          : 'Duelist',
      thirdClass: hunterBaseClass.isNotEmpty &&
              hunterThirdClass.containsKey(hunterBaseClass[0]) &&
              hunterThirdClass[hunterBaseClass[0]]!.isNotEmpty
          ? hunterThirdClass[hunterBaseClass[0]]![0]
          : 'Swordsaint',
      isFromDB: false,
    );

    hunters.add(newHunter);
    print("hunters: $hunters");
    notifyListeners();
    print("Length of hunters: ${hunters.length}");
    if (kDebugMode) {
      print("Created Hunter");
    }
  }

  void saveHuntersFromDatabase(_hunters) {
    print("hunters from db ${_hunters}");
    hunters = _hunters;
    print("Length of hunters: ${hunters.length}");
    notifyListeners();
    if (kDebugMode) {
      print("Saved Hunter");
    }
  }

  Future<void> saveHunter(_hunter, index, context) async {
    hunters[index] = _hunter;
    if (await upsertHunter(_hunter, context)) {
      hunters[index].isFromDB = true;
    }

    notifyListeners();
  }
}

class HunterItemState with ChangeNotifier {
  String baseClassDropDownValue = "Berserker";
  String secondClassDropDownValue = "Duelist";
  String thirdClassDropDownValue = "Barbarian";

  var name = "";

  void updateBaseClass(String newValue) {
    baseClassDropDownValue = newValue;
    secondClassDropDownValue = hunterSecondClass[baseClassDropDownValue]![0];
    thirdClassDropDownValue = hunterThirdClass[baseClassDropDownValue]![0];
    notifyListeners();
  }

  void updateItemStateValues(index, BuildContext context) {
    print("Index: $index");
    var hunterState = context.watch<HunterState>();
    print("Hunters Length: ${hunterState.hunters.length}");
    if (index < hunterState.hunters.length) {
      print("Updating Item State Values");
      name = hunterState.hunters[index].name;
      baseClassDropDownValue = hunterState.hunters[index].baseClass;
      secondClassDropDownValue = hunterState.hunters[index].secondClass;
      thirdClassDropDownValue = hunterState.hunters[index].thirdClass;

      print("🟢 Name: $name");
      print("🔵 Base Class: $baseClassDropDownValue");
      print("🟡 Second Class: $secondClassDropDownValue");
      print("🔴 Third Class: $thirdClassDropDownValue");
      notifyListeners();
    }
  }
}

class HunterBuilder extends StatefulWidget {
  HunterBuilder({Key? key}) : super(key: key);

  @override
  State<HunterBuilder> createState() => HunterBuilderState();
}

class HunterBuilderState extends State<HunterBuilder> {
  @override
  Widget build(BuildContext context) {
    var hunterState = context.watch<HunterState>();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 750, // Maximum pixel width of a grid item
          childAspectRatio: 3 / 2, // Width/Height ratio of grid items
          crossAxisSpacing: 20, // Horizontal spacing between grid items
          mainAxisSpacing: 20, // Vertical spacing between grid items
        ),
        itemCount: hunterState.hunters.length,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider(
            create: (context) => HunterItemState(),
            child: Consumer<HunterItemState>(
              builder: (context, hunterItemState, child) {
                print("!!!!Updating Item State Values");
                hunterItemState.updateItemStateValues(index, context);
                print("~~~Updated Item State Values");
                print(
                    "hunterItemState.secondClassDropDownValue, ${hunterItemState.secondClassDropDownValue}");
                print(
                    "hunterItemState.thirdClassDropDownValue, ${hunterItemState.thirdClassDropDownValue}");
                final inputFieldController = TextEditingController(
                    text: index < hunterState.hunters.length
                        ? hunterState.hunters[index].name
                        : '');
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    //Make border curved
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(146, 255, 255, 255),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        controller: inputFieldController,
                        decoration: const InputDecoration(
                          labelText: "Hunter Name",
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.black),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => hunterItemState.name = value,
                      ),
                      Expanded(
                          child: DropdownButtonFormField(
                        isExpanded: true,
                        value: hunterItemState.baseClassDropDownValue,
                        onChanged: (newValue) {
                          hunterItemState.updateBaseClass(newValue.toString());
                        },
                        items: hunterBaseClass
                            .map<DropdownMenuItem<String>>((String key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Center(child: Text(key)),
                          );
                        }).toList(),
                      )),
                      Expanded(
                          child: DropdownButtonFormField(
                        isExpanded: true,
                        value: hunterItemState.secondClassDropDownValue,
                        onChanged: (newValue) {
                          hunterItemState.secondClassDropDownValue = newValue!;
                        },
                        items: hunterSecondClass[
                                hunterItemState.baseClassDropDownValue]!
                            .map<DropdownMenuItem<String>>((String key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Center(child: Text(key)),
                          );
                        }).toList(),
                      )),
                      Expanded(
                          child: DropdownButtonFormField(
                        isExpanded: true,
                        value: hunterItemState.thirdClassDropDownValue,
                        onChanged: (newValue) {
                          hunterItemState.thirdClassDropDownValue = newValue!;
                        },
                        items: hunterThirdClass[
                                hunterItemState.baseClassDropDownValue]!
                            .map<DropdownMenuItem<String>>((String key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Center(child: Text(key)),
                          );
                        }).toList(),
                      )),
                      // const Gear(),
                      ElevatedButton(
                          onPressed: () {
                            var currentWidgetHunter = Hunter(
                              name: inputFieldController.text,
                              baseClass: hunterItemState.baseClassDropDownValue,
                              secondClass:
                                  hunterItemState.secondClassDropDownValue,
                              thirdClass:
                                  hunterItemState.thirdClassDropDownValue,
                              isFromDB: false,
                              // stats: {
                              //   "HP": 0,
                              //   "Attack": 0,
                              //   "Defense": 0,
                              //   "CritChance": 0,
                              //   "AttackSpeed": 0,
                              //   "Evasion": 0,
                              // }
                            );
                            print("Current Hunter: $currentWidgetHunter");
                            hunterState.saveHunter(
                                currentWidgetHunter, index, context);
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
        },
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

      var response = await fetchHunters(context);
      print(response);
      print("is hunters empty: ${response.isEmpty}");

      if (response.isEmpty) {
        Future.microtask(() => hunterState.createHunter());
      } else {
        for (var hunter in response) {
          hunters.add(Hunter.fromJson(hunter, context.read<EHTState>()));
        }
        hunterState.saveHuntersFromDatabase(hunters);
        print(hunterState.hunters);
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
                color: const Color.fromRGBO(27, 27, 30, 1.0),
                child: HunterBuilder(),
              ),
            ),
          ],
        ),
        floatingActionButton: LayoutBuilder(
          builder: (context, constraints) {
            double buttonSize = constraints.biggest.width * 0.15;
            double clampedSize = buttonSize.clamp(60.0, 100.0);

            return SizedBox(
              width: clampedSize,
              height: clampedSize,
              // color: Colors.white,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 196, 196, 196),
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
