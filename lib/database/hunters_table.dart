import 'package:evil_hunter_tycoon_utilities/database/stats_table.dart';
import 'package:evil_hunter_tycoon_utilities/hunter.dart';
import 'package:evil_hunter_tycoon_utilities/main.dart';
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

  if (hunters.length > 0) {
    for (var hunter in hunters) {
      var stats = await fetchHunterStats(hunter['id']);
      hunter['stats'] = stats;
    }
  }
  print("fetchHunters: $hunters");
  return hunters;
}

Future<void> upsertHunter(Hunter hunter, context) async {
  print("Supabase current user: ${supabase.auth}");
  var userId = supabase.auth.currentUser?.id;
  try {
    final response = await supabase.from('hunters').upsert(
      {'user_id': '$userId', 'name': hunter.name},
      ignoreDuplicates: false,
    ).select("hunter_id");
    print("responseasdas: $response");
  } catch (e) {
    var errorMessage;
    if (e.toString().contains("unique constraint"))
      errorMessage = "Hunter name already exists";
    else
      errorMessage = e.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(errorMessage),
        );
      },
    );
  }

  // for (var hunter in response['data']) {
  //   print("Hunter ID: ${hunter['id']}");
  //   final statResponse = upsertStats(hunter['id'], hunter.stats);
  //   print(statResponse);
  // }

  // print(response);
}
