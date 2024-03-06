import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<PostgrestList> fetchHunterStats(String hunterId) async {
  print("Supabase current user: ${supabase.auth.currentUser}");
  print("Getting Hunter using id: ${supabase.auth.currentUser?.id}");
  final stats =
      await supabase.from('stats').select('*').eq('hunter_id', {hunterId});
  print("fetchHunterStats: $stats");
  return stats;
}

Future<void> upsertStats(String hunterId, stats) async {
  var userId = supabase.auth.currentUser?.id;
  var dataToInsert = {'id': '$hunterId', 'hunter_id': '$userId', ...stats};
  final response = await supabase.from('stats').upsert([dataToInsert]);

  print(response);
}
