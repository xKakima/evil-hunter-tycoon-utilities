import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evil_hunter_tycoon_utilities/main.dart';

final supabase = Supabase.instance.client;

Future<PostgrestList> fetchGears() async {
  final gears = await supabase
      .from('gears')
      .select('*')
      .eq('user_id', {supabase.auth.currentUser?.id});
  print("fetchGears: $gears");
  return gears;
}
