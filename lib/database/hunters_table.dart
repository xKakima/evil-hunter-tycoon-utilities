import 'package:evil_hunter_tycoon_utilities/database/stats_table.dart';
import 'package:evil_hunter_tycoon_utilities/hunter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<PostgrestList> fetchHunters() async {
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

Future<void> upsertHunter(Hunter hunter) async {
  var userId = supabase.auth.currentUser?.id;
  final response = await supabase.from('hunters').upsert([
    {'user_id': '$userId', 'name': hunter.name}
  ]);

  for (var hunter in response.data) {
    final statResponse = upsertStats(hunter['id'], hunter.stats);
    print(statResponse);
  }

  print(response);
}
