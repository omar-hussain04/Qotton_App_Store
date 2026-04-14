import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'qotton_shop.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Users Table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        phone TEXT
      )
    ''');

    // Create Products Table
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        title TEXT,
        imagePath TEXT,
        price REAL
      )
    ''');

    // Create Cart Table
    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId TEXT,
        size TEXT,
        quantity INTEGER,
        FOREIGN KEY (productId) REFERENCES products (id)
      )
    ''');
    
    // Create Orders Table
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userEmail TEXT,
        items TEXT,
        total REAL,
        date TEXT
      )
    ''');

    // Pre-populate some dummy products into the database
    await _seedProducts(db);
  }

  Future<void> _seedProducts(Database db) async {
    final products = [
      {'id': 'p1', 'title': 'Classic Qotton Hoodie', 'imagePath': 'img/product/1.png', 'price': 15.00},
      {'id': 'p2', 'title': 'Minimalist Dark Hoodie', 'imagePath': 'img/product/2.png', 'price': 15.00},
      {'id': 'p3', 'title': 'Essential Qotton Hoodie', 'imagePath': 'img/product/3.png', 'price': 15.00},
      {'id': 'p4', 'title': 'Signature Zip Hoodie', 'imagePath': 'img/product/4.png', 'price': 15.00},
      {'id': 'p5', 'title': 'Premium Comfort Hoodie', 'imagePath': 'img/product/5.png', 'price': 15.00},
      {'id': 'p7', 'title': 'Anime X Qotton Collab', 'imagePath': 'img/product/7.png', 'price': 15.00},
      {'id': 'p8', 'title': 'Akatsuki Cloud Anime Hoodie', 'imagePath': 'img/product/8.png', 'price': 15.00},
      {'id': 'p9', 'title': 'Hunter License Anime Edition', 'imagePath': 'img/product/9.png', 'price': 15.00},
      {'id': 'p10', 'title': 'Titan Core Anime Hoodie', 'imagePath': 'img/product/10.png', 'price': 15.00},
      {'id': 'p11', 'title': 'Shinobi Origin Anime Drop', 'imagePath': 'img/product/11.png', 'price': 15.00},
      {'id': 'p12', 'title': 'Dragon Ball Anime Exclusive', 'imagePath': 'img/product/12.png', 'price': 15.00},
    ];

    products.shuffle();

    for (var product in products) {
      await db.insert('products', product, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // --- User Authentication Methods ---
  Future<int> registerUser(String name, String email, String password, String phone) async {
    final db = await database;
    try {
      return await db.insert(
        'users',
        {'name': name, 'email': email, 'password': password, 'phone': phone},
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (e) {
      // Typically email already exists, or DB Schema is outdated. 
      // User must reinstall the app to recreate DB tables with new columns.
      return -1; 
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<int> updateUser(String email, String name, String phone) async {
    final db = await database;
    try {
      return await db.update(
        'users',
        {'name': name, 'phone': phone},
        where: 'email = ?',
        whereArgs: [email],
      );
    } catch (e) {
      return -1;
    }
  }

  // --- Cart Methods ---
  Future<void> addToCart(String productId, String size, int quantity) async {
    final db = await database;
    
    // Check if the product AND SIZE already exists in the cart
    final List<Map<String, dynamic>> existingItems = await db.query(
      'cart',
      where: 'productId = ? AND size = ?',
      whereArgs: [productId, size],
    );

    if (existingItems.isNotEmpty) {
      // Increment quantity
      final int currentQty = existingItems.first['quantity'] as int;
      final int cartId = existingItems.first['id'] as int;
      await db.update(
        'cart',
        {'quantity': currentQty + quantity},
        where: 'id = ?',
        whereArgs: [cartId],
      );
    } else {
      // Add new item to cart
      await db.insert(
        'cart',
        {'productId': productId, 'size': size, 'quantity': quantity},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> removeFromCart(int cartId) async {
    final db = await database;
    await db.delete('cart', where: 'id = ?', whereArgs: [cartId]);
  }

  Future<void> updateCartQuantity(int cartId, int newQuantity) async {
    final db = await database;
    if (newQuantity <= 0) {
      await removeFromCart(cartId);
    } else {
      await db.update('cart', {'quantity': newQuantity}, where: 'id = ?', whereArgs: [cartId]);
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT cart.id as cartId, cart.quantity, cart.size, products.id as productId, products.title, products.imagePath, products.price 
      FROM cart
      INNER JOIN products ON cart.productId = products.id
    ''');
  }

  Future<int> getCartItemCount() async {
    final db = await database;
    var result = await db.rawQuery('SELECT SUM(quantity) as total FROM cart');
    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    }
    return 0;
  }

  // --- Order History Methods ---
  Future<int> addOrderHistory(String userEmail, String items, double total, String date) async {
    final db = await database;
    return await db.insert('orders', {
      'userEmail': userEmail,
      'items': items,
      'total': total,
      'date': date,
    });
  }

  Future<List<Map<String, dynamic>>> getOrderHistory(String userEmail) async {
    final db = await database;
    return await db.query(
      'orders',
      where: 'userEmail = ?',
      whereArgs: [userEmail],
      orderBy: 'id DESC', // Newest first
    );
  }
}
