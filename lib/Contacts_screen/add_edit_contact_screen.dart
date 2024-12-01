import 'package:flutter/material.dart';
import 'package:kursova3/SQLlite/db_helper.dart';
import '../models/contact_model.dart';

class AddEditContactPage extends StatefulWidget {
  final int userId; // ID користувача, щоб додати контакт
  final Contact? contact; // Існуючий контакт для редагування

  const AddEditContactPage({Key? key, required this.userId, this.contact})
      : super(key: key);

  @override
  _AddEditContactPageState createState() => _AddEditContactPageState();
}

class _AddEditContactPageState extends State<AddEditContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _socialMediaController = TextEditingController(); // Поле для соціальних мереж
  final _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _firstNameController.text = widget.contact!.firstName;
      _lastNameController.text = widget.contact!.lastName;
      _phoneNumberController.text = widget.contact!.phoneNumber;
      _emailController.text = widget.contact!.email;
      _socialMediaController.text = widget.contact!.socialMedia ?? ''; // Якщо є, то додав соціальні мережі
    }
  }

  Future<void> _saveContact() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final phoneNumber = _phoneNumberController.text.trim();
      final email = _emailController.text.trim();
      final socialMedia = _socialMediaController.text.trim(); // Соціальні мережі

      if (widget.contact == null) {
        // Додавання нового контакту
        await _dbHelper.insertContact(
          userId: widget.userId,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          email: email,
          socialMedia: socialMedia, // Додавання соціальних мереж
        );
      } else {
        // Оновлення існуючого контакту
        await _dbHelper.updateContact(
          id: widget.contact!.id!,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          email: email,
          socialMedia: socialMedia, // Оновлення соціальних мереж
        );
      }
      Navigator.pop(context, true); // Повертає true, якщо контакт додано/оновлено
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? 'Додати контакт' : 'Редагувати контакт'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'Ім\'я',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                validator: (value) => value == null || value.isEmpty
                    ? 'Введіть ім\'я'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Прізвище',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                validator: (value) => value == null || value.isEmpty
                    ? 'Введіть прізвище'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Номер телефону',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                validator: (value) => value == null || value.isEmpty
                    ? 'Введіть номер телефону'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Електронна пошта',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                validator: (value) => value == null || value.isEmpty
                    ? 'Введіть email'
                    : !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)
                    ? 'Невірний формат email'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _socialMediaController,
                decoration: InputDecoration(labelText: 'Соціальні мережі (опційно)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                validator: (value) => value == null || value.isEmpty
                    ? 'Введіть ім\'я'
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveContact,
                child: Text('Зберегти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
