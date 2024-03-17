// import 'package:evil_hunter_tycoon_utilities/database/stats_table.dart';
import 'package:evil_hunter_tycoon_utilities/hunter.dart';
import 'package:evil_hunter_tycoon_utilities/main.dart';
import 'package:evil_hunter_tycoon_utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<PostgrestList> fetchHunters(BuildContext context) async {
  var ehtState = Provider.of<EHTState>(context, listen: false);
  print("Base classes: ${ehtState.baseClasses}");
  print("Supabase current user: ${supabase.auth.currentUser}");
  print("Getting Hunter using id: ${supabase.auth.currentUser?.id}");

  final hunters = await supabase
      .from('hunters')
      .select('*')
      .eq('user_id', {supabase.auth.currentUser?.id});

  // if (hunters.length > 0) {
  //   for (var hunter in hunters) {
  //     var stats = await fetchHunterStats(hunter['id']);
  //     hunter['stats'] = stats;
  //   }
  // }
  print("fetchHunters: $hunters");
  return hunters;
}

Future<void> upsertHunter(Hunter hunter, context) async {
  var ehtState = Provider.of<EHTState>(context, listen: false);
  print("Supabase current user: ${supabase.auth}");
  var userId = supabase.auth.currentUser?.id;
  var baseClassId = ehtState.baseClasses?[hunter.baseClass];
  var secondClassId = ehtState.secondClasses?[hunter.secondClass];
  var thirdClassId = ehtState.thirdClasses?[hunter.thirdClass];

  print("User ID: $userId");
  print("Base Class ID: $baseClassId");
  print("Second Class ID: $secondClassId");
  print("third classes ${ehtState.thirdClasses}");
  print("Third Class ID: $thirdClassId");

  // Null Checkers
  if (userId == null) {
    ShowErrorDialog(context, "User not found",
        "There is an error in creating or updating your hunter");
    return;
  }
  if (hunter.name == "") {
    ShowErrorDialog(context, "Hunter Name must not be empty",
        "Please enter a name for your hunter");
    return;
  }
  if (baseClassId == null || secondClassId == null || thirdClassId == null) {
    ShowErrorDialog(context, "Class not found",
        "There is an error in creating or updating your hunter");
    return;
  }

  try {
    final response = await supabase.from('hunters').upsert(
      {
        'user_id': '$userId',
        'name': hunter.name,
        'base_class': baseClassId,
        'second_class': secondClassId,
        'third_class': thirdClassId,
      },
      ignoreDuplicates: false,
    ).select("hunter_id");
    print("responseasdas: $response");

    // List<dynamic> hunters = response['data'];
    // for (var hunter in hunters) {
    //   print("Hunter ID: ${hunter['id']}");
    //   final statResponse = upsertStats(hunter['id'], hunter.stats);
    //   print(statResponse);
    // }

    // print(response);
  } catch (e) {
    var errorMessage;
    if (e.toString().contains("unique constraint"))
      errorMessage = "Hunter name already exists";
    else
      errorMessage = e.toString();
    ShowErrorDialog(context,
        "There is an error in creating or updating your hunter", errorMessage);
  }
}
