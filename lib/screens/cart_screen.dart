import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../database/db_helper.dart';
import '../services/firebase_service.dart';
import '../services/connectivity_service.dart';
import '../config/constants.dart';
import '../widgets/quantity_button.dart';
import '../widgets/app_button.dart';
import '../widgets/shimmer_loading.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() {
      _isLoading = true;
    });
    final items = await dbHelper.getCartItems();
    setState(() {
      _cartItems = items;
      _isLoading = false;
    });
  }

  Future<void> _incrementQuantity(int cartId, int currentQty) async {
    await dbHelper.updateCartQuantity(cartId, currentQty + 1);
    _loadCart();
  }

  Future<void> _decrementQuantity(int cartId, int currentQty) async {
    if (currentQty <= 1) {
      await dbHelper.removeFromCart(cartId);
    } else {
      await dbHelper.updateCartQuantity(cartId, currentQty - 1);
    }
    _loadCart();
  }

  Future<void> _removeItem(int cartId) async {
    await dbHelper.removeFromCart(cartId);
    _loadCart();
  }

  double get _totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      total += (item['price'] as double) * (item['quantity'] as int);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const CartListShimmer()
          : _cartItems.isEmpty
              ? _buildEmptyCart()
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _cartItems.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final item = _cartItems[index];
                          return _buildCartItem(item);
                        },
                      ),
                    ),
                    _buildCheckoutBar(),
                  ],
                ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.white38),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 20, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Continue Shopping', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Slidable(
      key: ValueKey(item['cartId']),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          _removeItem(item['cartId']);
        }),
        children: [
          SlidableAction(
            onPressed: (_) => _removeItem(item['cartId']),
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Delete',
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              child: Image.asset(
                item['imagePath'],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Size: ${item['size'] ?? AppConstants.defaultSize}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(item['price'] as double).toStringAsFixed(2)} ${AppConstants.currency}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    QuantityButton(
                      icon: Icons.remove,
                      onPressed: () => _decrementQuantity(item['cartId'], item['quantity']),
                      size: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item['quantity']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    QuantityButton(
                      icon: Icons.add,
                      onPressed: () => _incrementQuantity(item['cartId'], item['quantity']),
                      size: 4,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, -5),
            blurRadius: 15,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  '${_totalPrice.toStringAsFixed(2)} ${AppConstants.currency}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Checkout',
              onPressed: _checkout,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkout() async {
    if (_cartItems.isEmpty) return;

    // Check connectivity before proceeding
    final hasInternet = await ConnectivityService.hasConnection();
    if (!hasInternet && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection. Please check your network.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Load user session from shared prefs
    final prefs = await SharedPreferences.getInstance();
    String currentUserName = prefs.getString(AppConstants.prefUserName) ?? 'Customer Name';
    String currentUserEmail = prefs.getString(AppConstants.prefUserEmail) ?? 'customer@qotton.shop';
    String currentUserPhone = prefs.getString(AppConstants.prefUserPhone) ?? '+1 234 567 8900';

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Locating and Processing Order...')),
    );

    String userLocation = 'Location not provided';
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        );
        userLocation = 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
      } else {
        userLocation = 'Location Permission Denied';
      }
    } catch (e) {
      userLocation = 'Location Error: $e';
    }

    bool success = await FirebaseService.saveOrder(
      currentUserName,
      currentUserEmail,
      currentUserPhone,
      userLocation,
      _totalPrice,
      _cartItems,
    );

    if (success && mounted) {
      // Save to local order history
      String itemsStr = _cartItems.map((item) {
        final size = item['size'] ?? AppConstants.defaultSize;
        return '${item['quantity']}x ${item['title']} (Size: $size)';
      }).join(', ');
      await dbHelper.addOrderHistory(currentUserEmail, itemsStr, _totalPrice, DateTime.now().toIso8601String());

      // Clear cart
      for (var item in _cartItems) {
        await dbHelper.removeFromCart(item['cartId']);
      }
      await _loadCart();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order completed and sent to Firebase!')),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send order to Firebase.')),
      );
    }
  }
}
