import 'package:flutter/material.dart';
import 'package:kursova3/Contacts_screen/add_edit_contact_screen.dart';
import 'package:kursova3/Contacts_screen/contact_detail_screen.dart';
import 'package:kursova3/SQLlite/db_helper.dart';
import '../models/contact_model.dart';

class ContactsPage extends StatefulWidget {
  final int userId; // ID користувача, щоб завантажити його контакти

  const ContactsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final _dbHelper = DatabaseHelper();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = []; // Для зберігання відфільтрованих контактів
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _searchController.addListener(_filterContacts);
  }

  // Завантаження контактів з бази
  Future<void> _loadContacts() async {
    final contactMaps = await _dbHelper.getContactsByUser(widget.userId);
    setState(() {
      _contacts = contactMaps.map((map) => Contact.fromMap(map)).toList();
      _filteredContacts = _contacts; // Спочатку всі контакти без фільтрації
      _isLoading = false;
    });
  }

  // Пошук/фільтрація контактів
  void _filterContacts() {
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        return contact.firstName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            contact.lastName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            contact.phoneNumber.contains(_searchController.text) ||
            contact.email.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            contact.socialMedia.toLowerCase().contains(_searchController.text.toLowerCase()); // Додав пошук по соціальних мережах
      }).toList();
    });
  }

  // Видалення контакту
  Future<void> _deleteContact(int contactId) async {
    await _dbHelper.deleteContact(contactId);
    _loadContacts(); // Оновлення списку після видалення
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мої контакти'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Пошук за ім\'ям, номером телефону, email або соц. мережею',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _filteredContacts.isEmpty
              ? Center(child: Text('Контактів немає'))
              : Expanded(
            child: ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return Card(
                  child: ListTile(
                    title: Text('${contact.firstName} ${contact.lastName}'),
                    subtitle: Text(contact.phoneNumber),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactDetailsPage(contact: contact),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditContactPage(
                                  userId: widget.userId,
                                  contact: contact,
                                ),
                              ),
                            );
                            if (result == true) {
                              _loadContacts();
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Видалити контакт'),
                                content: Text('Ви впевнені, що хочете видалити цей контакт?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Скасувати'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deleteContact(contact.id!);
                                    },
                                    child: Text('Видалити'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Кнопка для додавання нового контакту
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditContactPage(userId: widget.userId),
            ),
          );
          if (result == true) {
            _loadContacts(); // Оновлення списку після додавання
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Додати контакт',
      ),
    );
  }
}
