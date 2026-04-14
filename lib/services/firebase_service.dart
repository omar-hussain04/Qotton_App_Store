import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Saves user registration details to Firestore
  static Future<bool> saveUser(String name, String email, String phone) async {
    try {
      await _firestore.collection('users').doc(email).set({
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error saving to Firebase: $e');
      return false;
    }
  }

  /// Updates existing user details in Firestore
  static Future<bool> updateUser(
    String name,
    String email,
    String phone,
  ) async {
    try {
      await _firestore.collection('users').doc(email).update({
        'name': name,
        'phone': phone,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error updating Firebase: $e');
      return false;
    }
  }

  /// Saves an order to Firestore
  static Future<bool> saveOrder(
    String userName,
    String userEmail,
    String userPhone,
    String userLocation,
    double total,
    List<Map<String, dynamic>> cartItems,
  ) async {
    try {
      // Format cart items to a list of maps
      List<Map<String, dynamic>> itemsList = cartItems.map((item) {
        return {
          'title': item['title'],
          'quantity': item['quantity'],
          'size': item['size'] ?? 'M',
          'price': item['price'],
        };
      }).toList();

      await _firestore.collection('orders').add({
        'name': userName,
        'email': userEmail,
        'phone': userPhone,
        'location': userLocation,
        'total': total,
        'items': itemsList,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'Pending',
      });
      return true;
    } catch (e) {
      print('Error saving order to Firebase: $e');
      return false;
    }
  }
}
