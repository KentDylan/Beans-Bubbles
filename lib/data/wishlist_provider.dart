import 'package:flutter/material.dart';
import '../models/menu_model.dart';

class WishListProvider extends ChangeNotifier {
  List<MenuModel> _wishListItems = [];

  List<MenuModel> get wishListItems => _wishListItems;

  void toggleWishList(MenuModel item) {
    if (_wishListItems.contains(item)) {
      _wishListItems.remove(item);
    } else {
      _wishListItems.add(item);
    }
    notifyListeners();
  }

  bool contains(MenuModel item) {
    if (_wishListItems.contains(item)) {
      return true;
    }
    return false;
  }

  void removeItem(MenuModel item) {
    _wishListItems.remove(item);
    notifyListeners();
  }
}
