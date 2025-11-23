import 'package:flutter/material.dart';
import 'package:tugas7/models/product.dart';

class Cart extends ChangeNotifier {
  final List<Product> _items = [];
  List<Product> get items => _items;
  int get totalItems => _items.length;
  
  double get totalHarga {
    double total = 0;
    for (var item in _items) {
      total += item.harga;
    }
    return total;
  }

  void add(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void remove(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}