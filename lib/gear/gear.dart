import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class Gear extends StatefulWidget {
//   const Gear({super.key});

//   @override
//   State<Gear> createState() => _GearState();
// }

// class _GearState extends State<Gear> {
//   GearType? gearDropDownValue;

//   @override
//   Widget build(BuildContext context) {
//     var gearState = context.watch<GearState>();

//     gearDropDownValue ??= gearState.gearType;
//     return Expanded(
//       child: Column(
//         children: [
//           Expanded(
//               child: DropdownButtonFormField<GearType>(
//             isExpanded: true,
//             value: gearDropDownValue,
//             onChanged: (newValue) {
//               setState(() {
//                 if (kDebugMode) {
//                   print("previous Value $gearDropDownValue");
//                 }
//                 gearDropDownValue = newValue!;
//                 if (kDebugMode) {
//                   print("new Value $gearDropDownValue");
//                 }
//               });
//             },
//             items: GearType.values
//                 .map<DropdownMenuItem<GearType>>((GearType value) {
//               return DropdownMenuItem<GearType>(
//                 value: value,
//                 child: Center(
//                     child: Text(capitalize(value.toString().split('.').last))),
//               );
//             }).toList(),
//           )),
//         ],
//       ),
//     );
//   }
// }

enum GearType { weapon, hat, armor, glove, shoe, belt, necklace, ring }

enum GearVariant { ancient, primal, original, chaos }

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

class Gear {
  String name = "Gear Name";
  final GearType gearType;
  final GearVariant gearVariant;
  final GearRarity gearRarity;
  final List<String> gearLines;

  Gear({
    required this.name,
    required this.gearType,
    required this.gearVariant,
    required this.gearRarity,
    required this.gearLines,
  });

  @override
  String toString() {
    return "Gear: $name, Type: $gearType, Variant: $gearVariant, Rarity: $gearRarity, Lines: $gearLines";
  }
}

class HunterState extends ChangeNotifier {
  late Gear newGear;
  var gears = <Gear>[];

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
}

class GearItemState with ChangeNotifier {
  String baseClassDropDownValue = "Berserker";
  String secondClassDropDownValue = "Duelist";
  String thirdClassDropDownValue = "Barbarian";

  var name = "";

  // Add other methods to update secondClassDropDownValue and thirdClassDropDownValue...
}
// class GearPage extends StatefulWidget {
//   const GearPage({Key? key}) : super(key: key);

//   @override
//   _GearPageState createState() => _GearPageState();
// }

// class _GearPageState extends State<GearPage> {
//   String productDropped = 'On Product Drop Text will update';

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       return Scaffold(
//         body: Row(
//           children: [
//             Expanded(
//               child: Container(
//                 color: const Color.fromRGBO(27, 27, 30, 1.0),
//                 child: const DraggableExampleApp(),
//               ),
//             ),
//           ],
//         ),
//         floatingActionButton: LayoutBuilder(
//           builder: (context, constraints) {
//             double buttonSize = constraints.biggest.width * 0.15;
//             double clampedSize = buttonSize.clamp(60.0, 100.0);

//             return SizedBox(
//               width: clampedSize,
//               height: clampedSize,
//               // color: Colors.white,
//               child: FloatingActionButton(
//                 backgroundColor: const Color.fromARGB(255, 196, 196, 196),
//                 onPressed: () {
//                   if (kDebugMode) {
//                     print("Creating Gear");
//                   }
//                   // gearState.createHunter();
//                 },
//                 child: const Padding(
//                   padding: EdgeInsets.all(10.0),
//                   child: FittedBox(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Icon(Icons.add, size: 30.0),
//                         SizedBox(height: 5), // Add spacing
//                         Text("New Gear", style: TextStyle(fontSize: 16.0)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       );
//     });
//   }
// }

// class DraggableExampleApp extends StatelessWidget {
//   const DraggableExampleApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Draggable Sample')),
//         body: const DraggableExample(),
//       ),
//     );
//   }
// }

// class DraggableExample extends StatefulWidget {
//   const DraggableExample({super.key});

//   @override
//   State<DraggableExample> createState() => _DraggableExampleState();
// }

// class _DraggableExampleState extends State<DraggableExample> {
//   int acceptedData = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         Draggable<int>(
//           // Data is the value this Draggable stores.
//           data: 10,
//           feedback: Container(
//             color: Colors.deepOrange,
//             height: 100,
//             width: 100,
//             child: const Icon(Icons.directions_run),
//           ),
//           childWhenDragging: Container(
//             height: 100.0,
//             width: 100.0,
//             color: Colors.pinkAccent,
//             child: const Center(
//               child: Text('Child When Dragging'),
//             ),
//           ),
//           child: Container(
//             height: 100.0,
//             width: 100.0,
//             color: Colors.lightGreenAccent,
//             child: const Center(
//               child: Text('Draggable'),
//             ),
//           ),
//         ),
//         DragTarget<int>(
//           builder: (
//             BuildContext context,
//             List<dynamic> accepted,
//             List<dynamic> rejected,
//           ) {
//             return Container(
//               height: 100.0,
//               width: 100.0,
//               color: Colors.cyan,
//               child: Center(
//                 child: Text('Value is updated to: $acceptedData'),
//               ),
//             );
//           },
//           onAcceptWithDetails: (DragTargetDetails<int> details) {
//             setState(() {
//               acceptedData += details.data;
//             });
//           },
//         ),
//       ],
//     );
//   }
// }

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
                child: GearBuilder(),
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
                  // gearState.createHunter();
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

class GearBuilder extends StatefulWidget {
  GearBuilder({Key? key}) : super(key: key);

  @override
  State<GearBuilder> createState() => GearBuilderState();
}

class GearBuilderState extends State<GearBuilder> {
  @override
  Widget build(BuildContext context) {
    var gearState = context.watch<HunterState>();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 750, // Maximum pixel width of a grid item
          childAspectRatio: 3 / 2, // Width/Height ratio of grid items
          crossAxisSpacing: 20, // Horizontal spacing between grid items
          mainAxisSpacing: 20, // Vertical spacing between grid items
        ),
        itemCount: gearState.gears.length,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider(
            create: (context) => GearItemState(),
            child: Consumer<GearItemState>(
              builder: (context, gearItemState, child) {
                // print("!!!!Updating Item State Values");
                // gearItemState.updateItemStateValues(index, context);
                // print("~~~Updated Item State Values");
                // print(
                //     "gearItemState.secondClassDropDownValue, ${gearItemState.secondClassDropDownValue}");
                // print(
                //     "gearItemState.thirdClassDropDownValue, ${gearItemState.thirdClassDropDownValue}");
                final inputFieldController = TextEditingController(
                    text: index < gearState.gears.length
                        ? gearState.gears[index].name
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
                        onChanged: (value) => gearItemState.name = value,
                      ),
                      // Expanded(
                      //     child: DropdownButtonFormField(
                      //   isExpanded: true,
                      //   value: gearItemState.baseClassDropDownValue,
                      //   onChanged: (newValue) {
                      //     gearItemState.updateBaseClass(newValue.toString());
                      //   },
                      //   items: gearBaseClass
                      //       .map<DropdownMenuItem<String>>((String key) {
                      //     return DropdownMenuItem<String>(
                      //       value: key,
                      //       child: Center(child: Text(key)),
                      //     );
                      //   }).toList(),
                      // )),
                      // Expanded(
                      //     child: DropdownButtonFormField(
                      //   isExpanded: true,
                      //   value: gearItemState.secondClassDropDownValue,
                      //   onChanged: (newValue) {
                      //     gearItemState.secondClassDropDownValue = newValue!;
                      //   },
                      //   items: gearSecondClass[
                      //           gearItemState.baseClassDropDownValue]!
                      //       .map<DropdownMenuItem<String>>((String key) {
                      //     return DropdownMenuItem<String>(
                      //       value: key,
                      //       child: Center(child: Text(key)),
                      //     );
                      //   }).toList(),
                      // )),
                      // Expanded(
                      //     child: DropdownButtonFormField(
                      //   isExpanded: true,
                      //   value: gearItemState.thirdClassDropDownValue,
                      //   onChanged: (newValue) {
                      //     gearItemState.thirdClassDropDownValue = newValue!;
                      //   },
                      //   items: gearThirdClass[
                      //           gearItemState.baseClassDropDownValue]!
                      //       .map<DropdownMenuItem<String>>((String key) {
                      //     return DropdownMenuItem<String>(
                      //       value: key,
                      //       child: Center(child: Text(key)),
                      //     );
                      //   }).toList(),
                      // )),
                      // // const Gear(),
                      ElevatedButton(
                          onPressed: () {
                            var currentWidgetHunter = Gear(
                              name: inputFieldController.text,
                              gearType: GearType.weapon,
                              gearVariant: GearVariant.ancient,
                              gearRarity: GearRarity.poor,
                              gearLines: [],
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
                            // gearState.saveHunter(
                            // currentWidgetHunter, index, context);
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
