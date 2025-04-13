import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://egbizrmbyyrlstkuvnlb.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVnYml6cm1ieXlybHN0a3V2bmxiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ0NTMwMzAsImV4cCI6MjA2MDAyOTAzMH0.XlDHEUoFHOPeBLVW0Ko-SLKyEFv0fsvowTMEBAuzxAQ';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
