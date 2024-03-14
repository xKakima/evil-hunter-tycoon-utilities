import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;


Future<PostgrestList> fetchBaseClasses() async {
  final baseClasses = await supabase
      .from('base_classes')
      .select('*');
  print("fetchBaseClasses: $baseClasses");
      return baseClasses;
}

Future<PostgrestList> fetchSecondClasses() async {
  final secondClasses = await supabase
      .from('second_classes')
      .select('*');
  print("fetchSecondClasses: $secondClasses");
      return secondClasses;
}

Future<PostgrestList> fetchThirdClasses() async {
  final thirdClasses = await supabase
      .from('third_classes')
      .select('*');
  print("fetchThirdClasses: $thirdClasses");
      return thirdClasses;
}

