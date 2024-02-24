import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<PostgrestList> fetchHunters() async {
  final hunters = await supabase
    .from('eht.hunters')
    .select('*');

  return hunters;
}
