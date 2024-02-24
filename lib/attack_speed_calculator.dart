// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';

enum GearType { berserker, sorcerer, ranger, paladin }

enum GearVariant { ancient, primal, pvp, pvpult, wb }

class Gear {
  final int atk;
  final double spd;

  Gear({required this.atk, required this.spd});
}

class GearLookup {
  final Map<GearType, Map<GearVariant, Gear>> lookup = {
    GearType.berserker: {
      GearVariant.ancient: Gear(atk: 83916, spd: 2.00),
      GearVariant.primal: Gear(atk: 109188, spd: 2.00),
      GearVariant.pvp: Gear(atk: 110840, spd: 2.20),
      GearVariant.pvpult: Gear(atk: 1, spd: 2.20),
      GearVariant.wb: Gear(atk: 1, spd: 2.20),
    },
    // Add other GearTypes...
  };
}

class AtkSpdCalculator extends StatefulWidget {
  const AtkSpdCalculator({super.key});

  @override
  AtkSpdCalculatorState createState() => AtkSpdCalculatorState();
}

class AtkSpdCalculatorState extends State<AtkSpdCalculator> {
  String hType = 'berserker';
  String hWeaponType = 'ancient';
  double guild = 0;
  double sTech = 0;
  double eBonus = 0;
  double hStat = 0;
  double hChar = 0;
  double hQuick = 1;
  double fury = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DropdownButton<String>(
          value: hType,
          onChanged: (String? newValue) {
            setState(() {
              hType = newValue!;
              // calcATKSPD();
            });
          },
          items: <String>['berserker', 'sorcerer', 'ranger', 'paladin']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        // Add other form fields...
      ],
    );
  }

  void calcATKSPD({
    required GearType hType,
    required GearVariant hWeaponType,
    required double guild,
    required double sTech,
    required double eBonus,
    required double hStat,
    required double hChar,
    required double hQuick,
    required double fury,
  }) {
    var lookUp = GearLookup().lookup;
    var weapon = lookUp[hType]![hWeaponType]!.spd;

    if (sTech > 10 || sTech < 0) {
      // Handle invalid sTech value...
    }

    var step1 = guild + sTech + eBonus + hStat + hChar;
    var step2 = step1 / 100;
    var step3 = 1 - step2;
    var step4 = weapon * step3;
    var atkSpd = (step4 / hQuick).toStringAsFixed(2);
    var atkSpdFury = (step4 / (fury + (hQuick - 1))).toStringAsFixed(2);

    var totalAtkSpdNeededNoFury = 1 - (hQuick / (4 * weapon));
    var totalAtkSpdNeededWithFury = 1 - (((hQuick - 1) + fury) / (4 * weapon));

    var atkSpdNeeded = totalAtkSpdNeededNoFury - step2;
    var atkSpdNeededWithFury = totalAtkSpdNeededWithFury - step2;

    if (fury > 0 &&
        (hType == GearType.berserker || hType == GearType.sorcerer)) {
      //   print(
      //       'Your attack speed will be.. WITH FURY: $atkSpdFury, WITHOUT FURY: $atkSpd');
      // } else if (double.parse(atkSpd) >= 0.25) {
      //   print('Attack Speed will be: $atkSpd');
      // } else {
      //   print(
      //       'Consider removing ${-atkSpdNeeded * 100}%, the max is 0.25 and you have: $atkSpd');
    }
  }
}

class AtkSpdCalculatorClass {
  late double _quicknessTrait;
  late double weaponAtkSpd;
  late double totalEquimentAtkSpd;
  late double hunterStat;
  late double guildBuff;
  late double secretTech;
  late double characteristic;

  set quicknessTraitRange(double value) {
    if (value < 1.0 || value > 1.5) {
      throw ArgumentError('Value must be between 1.0 and 1.5');
    }
    _quicknessTrait = value;
  }

  double get quicknessTrait => _quicknessTrait;

  void calculateAtkSpd() {
    double finalAtkSpd;

    finalAtkSpd = (weaponAtkSpd *
            (1 -
                (guildBuff +
                        secretTech +
                        totalEquimentAtkSpd +
                        hunterStat +
                        characteristic) /
                    100)) /
        quicknessTrait;
  }
}
