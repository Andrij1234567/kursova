import 'package:flutter/material.dart';
import 'package:kursova3/auth/log_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Book',
      theme: ThemeData(
        // Основна кольорова схема
        colorScheme: ColorScheme.light(
          primary: Colors.lightBlue, // Головний колір
          secondary: Colors.blueAccent, // Додатковий колір
          background: Colors.white, // Колір фону
          surface: Colors.lightBlue.shade50, // Колір для поверхонь (карток, кнопок)
          onPrimary: Colors.white, // Колір тексту на головному кольорі
          onSecondary: Colors.white, // Колір тексту на додатковому кольорі
          onBackground: Colors.black, // Колір тексту на фоні
          onSurface: Colors.black, // Колір тексту на поверхнях
        ),
        scaffoldBackgroundColor: Colors.lightBlue.shade50, // Фон для екранів
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightBlue, // Колір AppBar
          foregroundColor: Colors.white, // Колір тексту/ікон у AppBar
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueAccent, // Колір текстових кнопок
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Колір кнопок
            foregroundColor: Colors.white, // Колір тексту на кнопках
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Закруглені краї кнопок
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0), // Закруглені краї полів
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Colors.lightBlue),
          ),
          labelStyle: TextStyle(color: Colors.blueAccent),
          iconColor: Colors.blueAccent,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent, // Колір FAB
          foregroundColor: Colors.white, // Колір іконок на FAB
        ),
      ),
      home: LoginPage(),
    );
  }
}
