import 'package:flutter/material.dart';
import 'package:kursova3/SQLlite/db_helper.dart';
import '../models/contact_model.dart';

class AddEditContactPage extends StatefulWidget {
  final int userId;
  final Contact? contact;

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
  final _socialMediaController = TextEditingController();
  final _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _firstNameController.text = widget.contact!.firstName;
      _lastNameController.text = widget.contact!.lastName;
      _phoneNumberController.text = widget.contact!.phoneNumber;
      _emailController.text = widget.contact!.email;
      _socialMediaController.text = widget.contact!.socialMedia ?? '';
    }
  }

  Future<void> _saveContact() async {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        id: widget.contact?.id,
        userId: widget.userId,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        email: _emailController.text.trim(),
        socialMedia: _socialMediaController.text.trim(),
      );

      if (widget.contact == null) {
        await _dbHelper.insertContact(contact);
      } else {
        await _dbHelper.updateContact(contact);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? 'Додати контакт' : 'Редагувати контакт'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Ім\'я',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Введіть ім\'я'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Прізвище',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Введіть прізвище'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Номер телефону',
                ),
                validator: (value) {
                  final regex = RegExp(r'^\+?\d+$');
                  if (value == null || value.isEmpty) {
                    return 'Введіть номер телефону';
                  } else if (!regex.hasMatch(value)) {
                    return 'Номер телефону може містити тільки цифри або починатися з +';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Електронна пошта',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Введіть email'
                    : !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                    .hasMatch(value)
                    ? 'Невірний формат email'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _socialMediaController,
                decoration: const InputDecoration(
                  labelText: 'Соціальні мережі',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveContact,
                child: const Text('Зберегти'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _socialMediaController.dispose();
    super.dispose();
  }
}
