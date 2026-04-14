import 'package:flutter/material.dart';
import '../screens/splash_screen.dart'; // <--- Added this
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/main_screen.dart';
import '../screens/home_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/order_history_screen.dart';
import '../screens/product_details_screen.dart';
import '../models/product.dart';

/// Centralized route names for the entire app.
class AppRoutes {
  // Prevent instantiation
  AppRoutes._();

  static const String splash = '/'; // <--- SplashScreen back as root
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String orderHistory = '/order-history';
  static const String productDetails = '/product-details';

  /// Generates routes based on [RouteSettings].
  /// Used as the `onGenerateRoute` callback in [MaterialApp].
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashScreen(), settings);

      case login:
        return _buildRoute(const LoginScreen(), settings);

      case signup:
        return _buildRoute(const SignupScreen(), settings);

      case main:
        return _buildRoute(const MainScreen(), settings);

      case home:
        return _buildRoute(const HomeScreen(), settings);

      case cart:
        return _buildRoute(const CartScreen(), settings);

      case profile:
        return _buildRoute(const ProfileScreen(), settings);

      case editProfile:
        return _buildRoute(const EditProfileScreen(), settings);

      case orderHistory:
        return _buildRoute(const OrderHistoryScreen(), settings);

      case productDetails:
        final product = settings.arguments as Product;
        return _buildRoute(ProductDetailsScreen(product: product), settings);

      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          settings,
        );
    }
  }

  /// Helper to build a [MaterialPageRoute] with consistent settings.
  static MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
