import 'package:flutter/material.dart';
import 'utils/supabase_config.dart';
import 'pages/home_page.dart';
import 'pages/food_items_page.dart';
import 'pages/donate_page.dart';
import 'pages/contact_us_page.dart';
import 'pages/login_page.dart';
import 'pages/checkout_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize(); // Initialize Supabase
  runApp(const FoodForAllApp());
}

class FoodForAllApp extends StatelessWidget {
  const FoodForAllApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food For All',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF014D4E), // Midnight Green
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF014D4E), // Midnight Green
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF014D4E), // Midnight Green
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF555555)), // Warm Grey
          bodyMedium: TextStyle(color: Color(0xFF555555)),
          titleLarge: TextStyle(color: Color(0xFF014D4E)), // Midnight Green
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFCA8550), // Gold Ochre
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF014D4E),
        ).copyWith(
          primary: const Color(0xFF014D4E),       // Midnight Green
          secondary: const Color(0xFFD5F4E6),     // Pastel Mint
          error: const Color(0xFFCA4D4D),         // Coral Peach
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onError: Colors.white,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/checkout') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => CheckoutPage(
              cartItems: args['cartItems'],
              onOrderPlaced: args['onOrderPlaced'],
              onClearCart: args['onClearCart'],
            ),
          );
        }

        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => HomePage());
          case '/food-items':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => FoodItemsPage(
                cartItems: args['cartItems'],
                onAddToCart: args['onAddToCart'],
              ),
            );
          case '/donate':
            return MaterialPageRoute(builder: (context) => DonatePage());
          case '/contact':
            return MaterialPageRoute(builder: (context) => ContactUsPage());
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginPage());
          default:
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text("Page Not Found")),
              ),
            );
        }
      },
    );
  }
}
