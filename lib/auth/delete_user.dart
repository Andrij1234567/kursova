import 'package:flutter/material.dart';
import 'package:kursova3/SQLlite/db_helper.dart';

class DeleteAccountScreen extends StatefulWidget {
  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String _statusMessage = "";

  Future<void> _deleteAccount() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _statusMessage = "Будь ласка, заповніть всі поля.";
      });
      return;
    }

    try {
      final result = await _dbHelper.deleteAccount(username, password);
      setState(() {
        _statusMessage = result > 0
            ? "Обліковий запис успішно видалено."
            : "Обліковий запис не знайдено. Перевірте ім'я користувача та пароль.";
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Помилка: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Видалення облікового запису"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Введіть ім'я користувача та пароль для видалення облікового запису:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Ім'я користувача",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Пароль",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _deleteAccount,
              child: Text("Видалити обліковий запис"),
            ),
            SizedBox(height: 20),
            Text(
              _statusMessage,
              style: TextStyle(
                fontSize: 16,
                color: _statusMessage.contains("успішно") ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
