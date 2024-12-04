import 'package:flutter/material.dart';
import 'package:kursova3/SQLlite/db_helper.dart';
import 'package:kursova3/models/user_model.dart';

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

      final existingUser = await _dbHelper.getUserByUsername(username);
      if (existingUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Користувач із таким ім\'ям вже існує')),
        );
        return;
      }

      final newUser = User(username: username, password: password);
      await _dbHelper.insertUser(newUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Реєстрація успішна!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Реєстрація')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Ім\'я користувача',
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

              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Пароль',
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

              ElevatedButton(
                onPressed: _signUp,
                child: Text('Зареєструватися'),
              ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
