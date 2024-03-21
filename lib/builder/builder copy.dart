import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

class GearPage extends StatefulWidget {
  const GearPage({Key? key}) : super(key: key);

  @override
  _GearPageState createState() => _GearPageState();
}

class _GearPageState extends State<GearPage> {
  String productDropped = 'On Product Drop Text will update';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Container(
                color: const Color.fromRGBO(27, 27, 30, 1.0),
                child: const DraggableExampleApp(),
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
                  // hunterState.createHunter();
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

class DraggableExampleApp extends StatelessWidget {
  const DraggableExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Draggable Sample')),
        body: const DraggableExample(),
      ),
    );
  }
}

class DraggableExample extends StatefulWidget {
  const DraggableExample({super.key});

  @override
  State<DraggableExample> createState() => _DraggableExampleState();
}

class _DraggableExampleState extends State<DraggableExample> {
  int acceptedData = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Draggable<int>(
          // Data is the value this Draggable stores.
          data: 10,
          feedback: Container(
            color: Colors.deepOrange,
            height: 100,
            width: 100,
            child: const Icon(Icons.directions_run),
          ),
          childWhenDragging: Container(
            height: 100.0,
            width: 100.0,
            color: Colors.pinkAccent,
            child: const Center(
              child: Text('Child When Dragging'),
            ),
          ),
          child: Container(
            height: 100.0,
            width: 100.0,
            color: Colors.lightGreenAccent,
            child: const Center(
              child: Text('Draggable'),
            ),
          ),
        ),
        DragTarget<int>(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return Container(
              height: 100.0,
              width: 100.0,
              color: Colors.cyan,
              child: Center(
                child: Text('Value is updated to: $acceptedData'),
              ),
            );
          },
          onAcceptWithDetails: (DragTargetDetails<int> details) {
            setState(() {
              acceptedData += details.data;
            });
          },
        ),
      ],
    );
  }
}
