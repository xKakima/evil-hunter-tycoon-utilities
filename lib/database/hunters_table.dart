import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<PostgrestList> fetchHunters() async {
  final hunters = await supabase
    .from('hunters')
    .select('*'); 

  return hunters;
}

Future<void> createOrSaveHunter(String name) async {
  var userId = supabase.auth.currentUser?.id;
  final response = await supabase
    .from('hunters')
    .upsert([{'id': '$userId','name': name}]);

    print(response);
}
