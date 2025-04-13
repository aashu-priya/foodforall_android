import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FoodItemsPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(Map<String, dynamic>) onAddToCart;

  const FoodItemsPage({
    super.key,
    required this.cartItems,
    required this.onAddToCart,
  });

  @override
  State<FoodItemsPage> createState() => _FoodItemsPageState();
}

class _FoodItemsPageState extends State<FoodItemsPage> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _foodItems = [];
  bool _isLoading = true;
  String _sortOption = 'Expiry Soonest';

  // Theme Colors
  final Color primaryColor = const Color(0xFF014D4E); // Midnight Green
  final Color secondaryColor = const Color(0xFFD5F4E6); // Pastel Mint
  final Color accentColor = const Color(0xFFCA4D4D); // Dark Coral Peach
  final Color highlightColor = const Color(0xFFF4A261); // Gold Ochre
  final Color textColor = const Color(0xFF555555); // Warm Grey
  final Color cardColor = const Color(0xFF49655F); // Darker teal for the card background
  final Color iconBackgroundColor = const Color(0xFFA6E3D4); // Darker shade for the upper part where the icon is
  final Color borderColor = const Color(0xFF000000); // Black border around the card
  final Color charcoalGrey = const Color(0xFFDFDCDC); // Charcoal Grey


  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  Future<void> _loadFoodItems() async {
    try {
      final response = await _supabase
          .from('donation')
          .select('id, food_item, quantity, food_category, expiry_date')
          .order('expiry_date', ascending: true);

      final List<Map<String, dynamic>> fetchedItems =
          List<Map<String, dynamic>>.from(response)
              .where((item) =>
                  item['expiry_date'] != null &&
                  DateTime.tryParse(item['expiry_date'])?.isAfter(DateTime.now()) == true &&
                  (item['quantity'] ?? 0) > 0)
              .toList();

      setState(() {
        _foodItems = fetchedItems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading food items: $e')),
      );
    }
  }

  IconData _getFoodIcon(String category) {
    switch (category.toLowerCase()) {
      case 'vegetables':
        return Icons.eco;
      case 'fruits':
        return Icons.apple;
      case 'dairy':
        return Icons.icecream;
      case 'bakery':
        return Icons.bakery_dining;
      case 'meat':
        return Icons.set_meal;
      default:
        return Icons.fastfood;
    }
  }

  void _sortItems(String option) {
    setState(() {
      _sortOption = option;
      if (option == 'Expiry Soonest') {
        _foodItems.sort((a, b) => a['expiry_date'].compareTo(b['expiry_date']));
      } else if (option == 'Expiry Latest') {
        _foodItems.sort((a, b) => b['expiry_date'].compareTo(a['expiry_date']));
      }
    });
  }

  Future<void> _addToCart(Map<String, dynamic> item) async {
    final updatedQuantity = (item['quantity'] ?? 0) - 1;
    if (updatedQuantity < 0) return;

    try {
      await _supabase.from('donation').update({
        'quantity': updatedQuantity,
      }).eq('id', item['id']);

      widget.onAddToCart(item);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${item['food_item']} to cart'),
          backgroundColor: accentColor,
          behavior: SnackBarBehavior.floating,
        ),
      );

      await _loadFoodItems(); // Refresh the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating quantity: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: const Text('Available Food Items'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortItems,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Expiry Soonest',
                child: Text('Sort by Expiry Soonest'),
              ),
              const PopupMenuItem(
                value: 'Expiry Latest',
                child: Text('Sort by Expiry Latest'),
              ),
            ],
            icon: const Icon(Icons.sort),
            color: secondaryColor,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _foodItems.isEmpty
              ? const Center(child: Text('No food items available'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _foodItems.length,
                  itemBuilder: (context, index) {
                    final item = _foodItems[index];
                    return _buildFoodCard(item);
                  },
                ),
    );
  }


Widget _buildFoodCard(Map<String, dynamic> item) {
  final expiryDate = DateTime.tryParse(item['expiry_date'] ?? '')?.toLocal();
  final formattedExpiry = expiryDate != null
      ? '${expiryDate.day}/${expiryDate.month}/${expiryDate.year}'
      : 'N/A';

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: borderColor, width: 2), // Black border around the card
    ),
    color: cardColor, // Darker teal color for the card background
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              color: iconBackgroundColor, // Darker background for the upper section where the icon is
            ),
            child: Center(
              child: Icon(
                _getFoodIcon(item['food_category'] ?? ''),
                size: 60,
                color: highlightColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['food_item'] ?? 'No Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: charcoalGrey, // Charcoal grey for food name
                ),
              ),
              Text(
                'Qty: ${item['quantity'] ?? 0}',
                style: TextStyle(
                  fontSize: 14,
                  color: charcoalGrey, // Charcoal grey for quantity
                ),
              ),
              Text(
                'Expires: $formattedExpiry',
                style: TextStyle(
                  fontSize: 12,
                  color: charcoalGrey, // Charcoal grey for expiry
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _addToCart(item),
                  child: const Text('Add to Cart'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}