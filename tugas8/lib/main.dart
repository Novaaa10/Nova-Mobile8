import 'package:flutter/material.dart';
import 'package:tugas8/homepage.dart';
import 'package:tugas8/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();

  await themeProvider.initSettings(); 

  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'My Sweet App',
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: themeProvider.themeMode, 
          debugShowCheckedModeBanner: false,
          home: const Homepage(),
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: Color(0xFFFF9EB5), // Pink pastel
        secondary: Color(0xFFB5EAD7), // Mint hijau
        surface: Color(0xFFFFF5F7), // Pink sangat muda
        background: Color(0xFFFFFBFE), // Putih dengan sentuhan pink
        onPrimary: Colors.white,
        onSecondary: Colors.black87,
      ),
      fontFamily: 'Poppins',
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFFFF9EB5),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFF9EB5),
        foregroundColor: Colors.white,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: Color(0xFFFFB6C1), // Light pink
        secondary: Color(0xFFC8A2C8), // Lilac
        surface: Color(0xFF2D2B42), // Ungu gelap
        background: Color(0xFF1F1D2B), // Dark purple
        onPrimary: Colors.black87,
        onSecondary: Colors.white,
      ),
      fontFamily: 'Poppins',
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFFFFB6C1),
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}