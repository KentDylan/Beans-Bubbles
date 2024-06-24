import '../models/cart_model.dart';
// import '../models/user_model.dart'; // Tambahkan ini
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_model.dart';

class DBHelper {
  static Database? _database;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to login user using Firebase Authentication
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  // Function to register user using Firebase Authentication
  // Future<bool> registerUser(String email, String password, String fullName, String phoneNo) async {
  //   try {
  //     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     // Store additional user details in Firestore
  //     await _firestore.collection('users').doc(userCredential.user!.uid).set({
  //       'fullName': fullName,
  //       'email': email,
  //       'phoneNo': phoneNo,
  //     });
  //     return true;
  //   } catch (e) {
  //     print('Error registering user: $e');
  //     return false;
  //   }
  // }

  // Register a user
  Future<void> registerUser(String email, String password, String fullName, String phoneNo) async {
    await _firestore.collection('users').doc(email).set({
      'email': email,
      'password': password,
      'fullName': fullName,
      'phoneNo': phoneNo,
    });
  }

  // Function to sign out user from Firebase Authentication
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'app.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart(
        id INTEGER PRIMARY KEY, 
        productId VARCHAR UNIQUE, 
        productName TEXT, 
        initialPrice INTEGER, 
        productPrice INTEGER, 
        quantity INTEGER, 
        category TEXT, 
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT,
        email TEXT UNIQUE,
        phoneNo INT,
        password TEXT
      )
    ''');
  }

  // Fungsi untuk membersihkan keranjang
  void clearCart() async {
    var dbClient = await database;
    await dbClient!.delete('cart');
  }

  // Future<Cart> insertOrUpdate(Cart cart) async {
  //   var dbClient = await database;
  //   final productId = cart.productId;

  //   final existingCartItem = await dbClient!.query(
  //     'cart',
  //     where: 'productId = ?',
  //     whereArgs: [productId],
  //   );

  //   if (existingCartItem.isNotEmpty) {
  //     final currentQuantity = existingCartItem[0]['quantity'] as int;
  //     await dbClient.update(
  //       'cart',
  //       {
  //         'quantity': currentQuantity + cart.quantity!.value,
  //       },
  //       where: 'productId = ?',
  //       whereArgs: [productId],
  //     );
  //   } else {
  //     await dbClient.insert('cart', cart.toMap());
  //   }

  //   return cart;
  // }

  // Future<List<Cart>> getCartList() async {
  //   var dbClient = await database;
  //   if (dbClient != null) {
  //     final List<Map<String, Object?>> queryResult =
  //         await dbClient.query('cart');
  //     return queryResult.map((result) => Cart.fromMap(result)).toList();
  //   } else {
  //     return [];
  //   }
  // }

  // Future<int> updateQuantity(Cart cart) async {
  //   var dbClient = await database;
  //   return await dbClient!.update('cart', cart.quantityMap(),
  //       where: "productId = ?", whereArgs: [cart.productId]);
  // }

  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  // Fetch product details by product ID
  Future<MenuModel?> getProductById(int productId) async {
    try {
      // Assuming you have a way to fetch a product from listMenu by ID
      return listMenu.firstWhere((product) => product.id == productId);
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }
}
