import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadMenuItems(List<MenuModel> menuItems) async {
    // print("hello");
    for (var menuItem in menuItems) {
      await _firestore.collection('menu_items').add(menuItem.toJson());
    }
  }

  Future<List<MenuModel>> fetchMenuItems() async {
    CollectionReference menuCollection = _firestore.collection('menu_items');
    QuerySnapshot querySnapshot = await menuCollection.get();

    return querySnapshot.docs.map((doc) {
      return MenuModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}