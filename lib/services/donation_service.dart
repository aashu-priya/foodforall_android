import 'package:food_for_all/utils/supabase_config.dart';

class DonationService {
  static Future<void> submitDonation(Map<String, dynamic> data) async {
    final client = SupabaseConfig.client;

    try {
      final response = await client.from('donation').insert(data);

      // Optional: log it
      print('Insert success: $response');
    } catch (e) {
      print('Insert failed: $e');
      throw Exception('Submission error: $e');
    }
  }
}

