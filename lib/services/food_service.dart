import 'package:food_for_all/utils/supabase_config.dart';

class FoodService {
  static Future<List<Map<String, dynamic>>> getFoodItems() async {
    try {
      final response = await SupabaseConfig.client
          .from('food_items')
          .select()
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load food items: $e');
    }
  }
}
