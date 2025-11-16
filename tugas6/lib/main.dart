import 'package:flutter/material.dart';
import 'package:tugas6/screens/homepage.dart';

void main() {
  runApp(MaterialApp(
    title: 'Katalog Wisata',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
    ),
    home: HomePage()
  ));
}