import 'package:flutter/material.dart';
import 'package:kursova3/Contacts_screen/contact_page.dart';
import 'package:kursova3/SQLlite/db_helper.dart';
import 'package:kursova3/auth/delete_user.dart';
import 'package:kursova3/auth/sign_up.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dbHelper = DatabaseHelper();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      final user = await _dbHelper.getUser(username, password);

      if (user != null) {
        // Якщо користувач знайдений
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ContactsPage(userId: user['id']),
          ),
        );
      } else {
        // Якщо користувача не знайдено
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Невірне ім\'я користувача або пароль')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введіть пароль';
                  } else if (value.length < 6) {
                    return 'Пароль має містити щонайменше 6 символів';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Увійти'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text('Зареєструватися'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeleteAccountScreen()),
                  );
                },
                child: Text('Видалити обліковий запис'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
