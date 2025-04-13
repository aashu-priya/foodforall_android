import 'package:flutter/material.dart';
import 'package:food_for_all/pages/contact_us_page.dart';
import 'package:food_for_all/pages/donate_page.dart';
import 'package:food_for_all/pages/food_items_page.dart';
import 'package:food_for_all/pages/login_page.dart';
import 'package:food_for_all/pages/checkout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _cartItems = [];

  // Theme Colors
 final Color primaryColor = const Color(0xFF014D4E); // Midnight Green
final Color secondaryColor = const Color(0xFFD5F4E6); // Pastel Mint
final Color accentColor = const Color(0xFFCA4D4D); // Coral Peach
final Color highlightColor = const Color(0xFFF4A261); // Gold Ochre
final Color textColor = const Color(0xFF555555); // Warm Grey

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food For All'),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildMissionSection(),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: const Text(
              'Food For All',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildDrawerItem(Icons.home, 'Home', () => Navigator.pop(context)),
          _buildDrawerItem(Icons.fastfood, 'Food Items', () => _navigateToFoodItems(context)),
          _buildDrawerItem(Icons.volunteer_activism, 'Donate', () => _navigateToDonate(context)),
          _buildDrawerItem(Icons.shopping_cart, 'Checkout', () => _navigateToCart(context)),
          _buildDrawerItem(Icons.login, 'Login', () => _navigateToLogin(context)),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: accentColor),
      title: Text(label, style: TextStyle(color: textColor)),
      onTap: onTap,
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.food_bank, size: 60, color: secondaryColor),
            const SizedBox(height: 20),
            Text(
              'Fighting Hunger Together',
              style: TextStyle(
                color: secondaryColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Join our mission to end food waste',
              style: TextStyle(
                color: highlightColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Mission',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'We connect surplus food from restaurants and grocery stores with people in need, reducing waste while fighting hunger in our community.',
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatItem('500+', 'Meals Served'),
              const SizedBox(width: 20),
              _buildStatItem('50+', 'Partners'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: highlightColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildActionButton('Browse Food Items', Icons.fastfood, () => _navigateToFoodItems(context)),
          const SizedBox(height: 15),
          _buildActionButton('Make a Donation', Icons.volunteer_activism, () => _navigateToDonate(context)),
          const SizedBox(height: 15),
          _buildActionButton('Checkout', Icons.shopping_cart, () => _navigateToCart(context)),
          const SizedBox(height: 15),
          _buildActionButton('Contact Us', Icons.contact_page, () => _navigateToContact(context)),
          const SizedBox(height: 15),
          _buildActionButton('Login', Icons.login, () => _navigateToLogin(context)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(fontSize: 16)),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  void _navigateToFoodItems(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodItemsPage(
          cartItems: _cartItems,
          onAddToCart: (item) => setState(() => _cartItems.add(item)),
        ),
      ),
    );
  }

  void _navigateToDonate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DonatePage()),
    );
  }

  void _navigateToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          cartItems: _cartItems,
          onOrderPlaced: () => setState(() => _cartItems.clear()),
          onClearCart: () => setState(() => _cartItems.clear()),
        ),
      ),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _navigateToContact(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactUsPage()),
    );
  }
}
