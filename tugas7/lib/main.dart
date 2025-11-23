import 'package:flutter/material.dart';
import 'package:tugas7/models/cart.dart';
import 'package:tugas7/screens/productscreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Cart(),
    child: const MaterialApp(
      title: 'Beauty Store',
      home: ProductScreen(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}