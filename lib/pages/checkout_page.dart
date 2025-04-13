import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function() onOrderPlaced;
  final Function() onClearCart;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.onOrderPlaced,
    required this.onClearCart,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _isSubmitting = false;
  bool _showSuccess = false;
  final Map<String, int> _cartQuantities = {};

  final Color primaryColor = const Color(0xFF014D4E); // Midnight Green
  final Color accentColor = const Color(0xFFCA4D4D); // Coral Peach
  final Color highlightColor = const Color(0xFFCA8550); // Gold Ochre
  final Color textColor = const Color(0xFF555555); // Warm Grey

  @override
  void initState() {
    super.initState();
    for (var item in widget.cartItems) {
      final id = item['id'].toString();
      _cartQuantities[id] = (_cartQuantities[id] ?? 0) + 1;
    }
  }

  Future<void> _handleCheckout() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));
    widget.onOrderPlaced();
    setState(() {
      _isSubmitting = false;
      _showSuccess = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    widget.onClearCart();
    if (mounted) Navigator.pop(context);
  }

  void _removeItem(String id) {
    setState(() {
      if (_cartQuantities.containsKey(id)) {
        _cartQuantities.remove(id);
      }
    });
  }

  void _clearCart() {
    setState(() => _cartQuantities.clear());
    widget.onClearCart();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) {
      return Scaffold(
        backgroundColor: const Color(0xFFD5F4E6), // Pastel Mint
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: highlightColor, size: 80),
              const SizedBox(height: 20),
              Text(
                'Order Placed!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your food will be prepared shortly',
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  widget.onClearCart();
                  Navigator.pop(context);
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    }

    final uniqueItems = widget.cartItems.fold<Map<String, Map<String, dynamic>>>(
      {},
      (acc, item) {
        final id = item['id'].toString();
        acc[id] = item;
        return acc;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: primaryColor,
        actions: [
          if (_cartQuantities.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_forever, color: accentColor),
              tooltip: 'Clear Cart',
              onPressed: _clearCart,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _cartQuantities.isEmpty
                ? Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(fontSize: 18, color: textColor),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(12),
                    children: uniqueItems.entries.map((entry) {
                      final id = entry.key;
                      final item = entry.value;
                      final quantity = _cartQuantities[id] ?? 0;

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.fastfood, color: highlightColor),
                          title: Text(
                            item['food_item'] ?? 'Unnamed Item',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          subtitle: Text('Quantity: $quantity', style: TextStyle(color: textColor)),
                          trailing: IconButton(
                            icon: Icon(Icons.remove_circle_outline, color: accentColor),
                            onPressed: () => _removeItem(id),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
          if (_cartQuantities.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FilledButton(
                onPressed: _isSubmitting ? null : _handleCheckout,
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Complete Checkout'),
              ),
            ),
        ],
      ),
    );
  }
}
