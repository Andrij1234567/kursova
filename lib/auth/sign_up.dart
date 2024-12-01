import 'package:flutter/material.dart';
import 'package:kursova3/SQLlite/db_helper.dart';
import 'package:kursova3/auth/delete_user.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dbHelper = DatabaseHelper();

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      // Додавання нового користувача в базу
      await _dbHelper.insertUser(username, password);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Реєстрація успішна!')),
      );

      Navigator.pop(context); // Повернення на сторінку логіну
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ім'я користувача
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Ім\'я користувача',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введіть ім\'я користувача';
                  } else if (value.length < 5) {
                    return 'Ім\'я користувача має містити щонайменше 5 символів';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              // Пароль
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введіть пароль';
                  } else if (value.length < 6) {
                    return 'Пароль повинен містити щонайменше 6 символів';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Кнопка реєстрації
              ElevatedButton(
                onPressed: _signUp,
                child: Text('Зареєструватися'),
              ),
              SizedBox(height: 20),
              // Кнопка для переходу на екран видалення акаунта
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeleteAccountScreen()),
                  );
                },
                child: Text('Видалити акаунт'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
