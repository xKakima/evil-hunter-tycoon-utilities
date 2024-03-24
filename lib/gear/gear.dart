// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum GearSlot { weapon, hat, armor, glove, shoe, belt, necklace, ring }

enum GearType { ancient, primal, original, chaos, unique }

enum GearRarity { poor, common, uncommon, advanced, ultimate }

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

List<String> chaosAndAboveGearLines = [
  "Increase Probability of high-class materals: {x}%",
];

Map<String, List<String>> pinkOptionsSet = {
  "set1": [
    survivabilityGearLines[1],
    racialDamageGearLines[3],
    chaosAndAboveGearLines[0]
  ],
  "set2": [
    offensiveGearLines[offensiveGearLines.length - 1],
    survivabilityGearLines[4],
    chaosAndAboveGearLines[0]
  ],
};

Map<GearSlot, List<String>> pinkOptionsPerGear = {
  GearSlot.hat: pinkOptionsSet["set1"]!,
  GearSlot.belt: pinkOptionsSet["set1"]!,
  GearSlot.armor: pinkOptionsSet["set2"]!,
  GearSlot.glove: pinkOptionsSet["set2"]!,
  GearSlot.shoe: pinkOptionsSet["set2"]!
};

class Gear {
  String name = "";
  final GearSlot gearSlot;
  final GearType gearType;
  final GearRarity gearRarity;
  final List<String> gearLines;
  final bool isFromDB;

  Gear({
    required this.name,
    required this.gearSlot,
    required this.gearType,
    required this.gearRarity,
    required this.gearLines,
    required this.isFromDB,
  });

  @override
  String toString() {
    return "Gear: $name, Slot: $gearSlot, Variant: $gearType, Rarity: $gearRarity, Lines: $gearLines";
  }
}

class GearState extends ChangeNotifier {
  late Gear newGear;
  var gears = <Gear>[];

  void createGearTemplate() {
    var newGear = Gear(
      name: "",
      gearSlot: GearSlot.hat,
      gearType: GearType.ancient,
      gearRarity: GearRarity.poor,
      gearLines: [],
      isFromDB: false,
    );

    gears.add(newGear);
    print("gears: $gears");
    notifyListeners();
    print("Length of gears: ${gears.length}");
    if (kDebugMode) {
      print("Created Gear");
    }
  }
}

// void createHunter() {
//   var newHunter = Gear(
//     name: "",
//     baseClass: gearBaseClass.isNotEmpty ? gearBaseClass[0] : 'Beserker',
//     secondClass: gearBaseClass.isNotEmpty &&
//             gearSecondClass.containsKey(gearBaseClass[0]) &&
//             gearSecondClass[gearBaseClass[0]]!.isNotEmpty
//         ? gearSecondClass[gearBaseClass[0]]![0]
//         : 'Duelist',
//     thirdClass: gearBaseClass.isNotEmpty &&
//             gearThirdClass.containsKey(gearBaseClass[0]) &&
//             gearThirdClass[gearBaseClass[0]]!.isNotEmpty
//         ? gearThirdClass[gearBaseClass[0]]![0]
//         : 'Swordsaint',
//     isFromDB: false,
//   );

//   gears.add(newHunter);
//   print("gears: $gears");
//   notifyListeners();
//   print("Length of gears: ${gears.length}");
//   if (kDebugMode) {
//     print("Created Hunter");
//   }

class StatLine {
  String statName;
  int value;
  Widget widget;

  StatLine({required this.statName, required this.value, required this.widget});
}

class GearItemState with ChangeNotifier {
  String baseClassDropDownValue = "Berserker";
  String secondClassDropDownValue = "Duelist";
  String thirdClassDropDownValue = "Barbarian";

  var name = "";

  GearSlot gearSlot = GearSlot.hat;
  GearType gearType = GearType.ancient;
  GearRarity gearRarity = GearRarity.poor;
  String pinkOptionGearLine = "";
  var gearLinesOptions = gearLines;

  var itemGearLines = [];
  int lineCount = 3;

  void calculateLineCountByGearVariant() {
    if (gearType == GearType.ancient || gearType == GearType.primal) {
      lineCount = 3;
    }
    // else if (gearType == GearType.original) {
    //   lineCount = 4;
    // }
    else {
      lineCount = 4;
    }
    print("Line Count: $lineCount");
  }

  List<StatLine> statLines = [];

  Widget getStatWidget() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Gear Lines',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ...statLines.map((statLine) => statLine.widget).toList(),
          ],
        ),
      ),
    );
  }

  void changeItemType(GearType newType) {
    print("Old Gear Type: $gearType");
    gearType = newType;

    if (gearType == GearType.chaos && pinkOptionGearLine.isEmpty) {
      addPinkOptionLine();
    } else if (!(gearType == GearType.chaos) && pinkOptionGearLine.isNotEmpty) {
      statLines.removeAt(0);
    }
    print("New Gear Type: $gearType");

    generateStatLines();
    print("Generated Stat Lines: $statLines");
    notifyListeners();
  }

  void generateStatLines() {
    calculateLineCountByGearVariant();

    if (statLines.isEmpty) {
      addStatLineTemplate();
      print("Stat lines is empty, will generate 3 lines");
    }
    if (statLines.length > lineCount) {
      print(
          "Stat lines is greater. Current: ${statLines.length} Expected Line Count: $lineCount");
      statLines.removeRange(lineCount, statLines.length);
    } else if (statLines.length < lineCount) {
      print(
          "Stat lines is less. Current: ${statLines.length} Expected Line Count: $lineCount");
      addStatLines(lineCount - statLines.length);
    }
  }

  void addPinkOptionLine() {
    List<String> pinkOptions = pinkOptionsPerGear[gearSlot]!;
    String statLineName = pinkOptions[0];
    Widget newStatLine = Column(children: [
      //Add dropdown here with value of gearLines
      DropdownButtonFormField<String>(
        isExpanded: true,
        value: statLineName,
        onChanged: (newValue) {
          print("New Value: $newValue");
          // statLines.contains(element)
          // setState(() {
          //   if (kDebugMode) {
          //     print("previous Value $gearDropDownValue");
          //   }
          //   gearDropDownValue = newValue!;
          //   if (kDebugMode) {
          //     print("new Value $gearDropDownValue");
          //   }
          // });
        },
        items: pinkOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Center(child: Text(value)),
          );
        }).toList(),
      ),
      // Add input field here
      TextFormField(
        decoration: const InputDecoration(
          labelText: "Stat Value",
          labelStyle: TextStyle(fontSize: 20, color: Colors.black),
          border: OutlineInputBorder(),
        ),
      ),
    ]);
    //Add at index 0
    statLines.insert(
        0, StatLine(statName: statLineName, value: 0, widget: newStatLine));
  }

  void addStatLines(int count) {
    for (var i = 0; i < count; i++) {
      String statLineName = gearLines[0];
      Widget newStatLine = Column(children: [
        //Add dropdown here with value of gearLines
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: statLineName,
          onChanged: (newValue) {
            print("New Value: $newValue");
            // statLines.contains(element)
            // setState(() {
            //   if (kDebugMode) {
            //     print("previous Value $gearDropDownValue");
            //   }
            //   gearDropDownValue = newValue!;
            //   if (kDebugMode) {
            //     print("new Value $gearDropDownValue");
            //   }
            // });
          },
          items: gearLines.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(child: Text(value)),
            );
          }).toList(),
        ),
        // Add input field here
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Stat Value",
            labelStyle: TextStyle(fontSize: 20, color: Colors.black),
            border: OutlineInputBorder(),
          ),
        ),
      ]);
      statLines
          .add(StatLine(statName: statLineName, value: 0, widget: newStatLine));
    }
  }

  void addStatLineTemplate() {
    addStatLines(lineCount);
    notifyListeners();
  }

  String statLineRenamer(String statLine, int value) {
    return statLine.replaceAll("{x}", value.toString());
  }
}

class GearPage extends StatefulWidget {
  const GearPage({super.key});

  @override
  State<GearPage> createState() => _GearPageState();
}

class _GearPageState extends State<GearPage> {
  var selectedIndex = 0;
  List<Gear> gears = [];
  bool _fetchedGears = false;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    if (!_fetchedGears) {
      // var gearState = context.read<GearState>();

      // var response = await fetchHunters(context);
      // print(response);
      // print("is gears empty: ${response.isEmpty}");

      // if (response.isEmpty) {
      //   Future.microtask(() => gearState.createHunter());
      // } else {
      //   for (var gear in response) {
      //     gears.add(Hunter.fromJson(gear, context.read<EHTState>()));
      //   }
      //   gearState.saveHuntersFromDatabase(gears);
      //   print(gearState.gears);
      // }

      _fetchedGears = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var gearState = context.watch<GearState>();

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Container(
                color: const Color.fromRGBO(27, 27, 30, 1.0),
                child: const GearBuilder(),
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
                    print("Creating Gear");
                  }
                  gearState.createGearTemplate();
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FittedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, size: 30.0),
                        SizedBox(height: 5), // Add spacing
                        Text("New Gear", style: TextStyle(fontSize: 16.0)),
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

class GearBuilder extends StatefulWidget {
  const GearBuilder({Key? key}) : super(key: key);

  @override
  State<GearBuilder> createState() => GearBuilderState();
}

class GearBuilderState extends State<GearBuilder> {
  @override
  Widget build(BuildContext context) {
    var gearState = context.watch<GearState>();

    String getGearName(index, name) {
      if (name.length > 0) {
        return name;
      } else {
        return 'Gear ${index + 1}';
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 750, // Maximum pixel width of a grid item
          childAspectRatio: 1 / 1.35, // Width/Height ratio of grid items
          crossAxisSpacing: 20, // Horizontal spacing between grid items
          mainAxisSpacing: 20, // Vertical spacing between grid items
        ),
        itemCount: gearState.gears.length,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider(
            create: (context) => GearItemState(),
            child: Consumer<GearItemState>(
              builder: (context, gearItemState, child) {
                // Check if Gear Lines is empty. If it is Generate lines based on rarity
                if (gearItemState.statLines.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    gearItemState.addStatLineTemplate();
                  });
                }

                final inputFieldController = TextEditingController(
                    text: getGearName(index, gearState.gears[index].name));
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    //Make border curved
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(146, 255, 255, 255),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    clipBehavior: Clip.hardEdge,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.add_box),
                            Expanded(
                              child: TextFormField(
                                controller: inputFieldController,
                                decoration: const InputDecoration(
                                  labelText: "Optional Gear Name",
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) =>
                                    gearItemState.name = value,
                              ),
                            ),
                          ],
                        ),
                        DropdownButtonFormField<GearSlot>(
                          isExpanded: true,
                          value: gearItemState.gearSlot,
                          onChanged: (newValue) {
                            gearItemState.gearSlot = newValue!;
                          },
                          items: GearSlot.values
                              .map<DropdownMenuItem<GearSlot>>(
                                (GearSlot value) => DropdownMenuItem<GearSlot>(
                                  value: value,
                                  child: Center(
                                      child: Text(gearSlotToString(value))),
                                ),
                              )
                              .toList(),
                          decoration: const InputDecoration(
                            labelText: 'Slot', // Add your title here
                            labelStyle: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        DropdownButtonFormField<GearType>(
                            isExpanded: true,
                            value: gearItemState.gearType,
                            onChanged: (newValue) {
                              gearItemState.changeItemType(newValue!);
                            },
                            items: GearType.values
                                .map<DropdownMenuItem<GearType>>(
                                  (GearType value) =>
                                      DropdownMenuItem<GearType>(
                                    value: value,
                                    child: Center(
                                        child: Text(gearTypeToString(value))),
                                  ),
                                )
                                .toList(),
                            decoration: const InputDecoration(
                              labelText: 'Type', // Add your title here
                              labelStyle: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        DropdownButtonFormField<GearRarity>(
                            isExpanded: true,
                            value: gearItemState.gearRarity,
                            onChanged: (newValue) {
                              gearItemState.gearRarity = newValue!;
                            },
                            items: GearRarity.values
                                .map<DropdownMenuItem<GearRarity>>(
                                  (GearRarity value) =>
                                      DropdownMenuItem<GearRarity>(
                                    value: value,
                                    child: Center(
                                        child: Text(gearRarityToString(value))),
                                  ),
                                )
                                .toList(),
                            decoration: const InputDecoration(
                              labelText: 'Rarity', // Add your title here
                              labelStyle: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        gearItemState.getStatWidget(),
                        const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: () {
                              var currentWidgetGear = Gear(
                                name: inputFieldController.text,
                                gearSlot: GearSlot.weapon,
                                gearType: GearType.ancient,
                                gearRarity: GearRarity.poor,
                                gearLines: [],
                                isFromDB: false,
                              );
                              print("Current Gear: $currentWidgetGear");
                              // gearState.saveHunter(
                              // currentWidgetHunter, index, context);
                              if (kDebugMode) {
                                print('Save Gear');
                                print("Current Index: $index");
                              }
                            },
                            child: const Text('Save Gear '))
                      ],
                    ),
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

String gearSlotToString(GearSlot gearSlot) {
  switch (gearSlot) {
    case GearSlot.weapon:
      return 'Weapon';
    case GearSlot.hat:
      return 'Hat';
    case GearSlot.armor:
      return 'Armor';
    case GearSlot.glove:
      return 'Glove';
    case GearSlot.shoe:
      return 'Shoe';
    case GearSlot.belt:
      return 'Belt';
    case GearSlot.necklace:
      return 'Necklace';
    case GearSlot.ring:
      return 'Ring';
    default:
      return 'Unknown';
  }
}

String gearTypeToString(GearType gearType) {
  switch (gearType) {
    case GearType.ancient:
      return 'Ancient';
    case GearType.primal:
      return 'Primal';
    case GearType.original:
      return 'Original';
    case GearType.chaos:
      return 'Chaos';
    case GearType.unique:
      return 'Unique';
    default:
      return 'Unknown';
  }
}

String gearRarityToString(GearRarity gearRarity) {
  switch (gearRarity) {
    case GearRarity.poor:
      return 'Poor';
    case GearRarity.common:
      return 'Common';
    case GearRarity.uncommon:
      return 'Uncommon';
    case GearRarity.advanced:
      return 'Advanced';
    case GearRarity.ultimate:
      return 'Ultimate';
    default:
      return 'Unknown';
  }
}
