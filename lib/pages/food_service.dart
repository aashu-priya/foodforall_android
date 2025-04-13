import 'package:food_for_all/utils/supabase_config.dart';

class FoodService {
  static Future<List<Map<String, dynamic>>> getDonatedFood() async {
    final client = SupabaseConfig.client;

    try {
      final response = await client
          .from('donation') // or 'donations' if that's your table name
          .select()
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching food data: $e');
      return [];
    }
  }
}
