  import 'package:flutter/material.dart';
  import 'package:kursova3/Contacts_screen/add_edit_contact_screen.dart';
  import 'package:kursova3/Contacts_screen/contact_detail_screen.dart';
  import 'package:kursova3/SQLlite/db_helper.dart';
  import 'package:kursova3/auth/log_in.dart';
  import '../models/contact_model.dart';

  class ContactsPage extends StatefulWidget {
    final int userId;

    const ContactsPage({Key? key, required this.userId}) : super(key: key);

    @override
    _ContactsPageState createState() => _ContactsPageState();
  }

  class _ContactsPageState extends State<ContactsPage> {
    final _dbHelper = DatabaseHelper();
    List<Contact> _contacts = [];
    List<Contact> _filteredContacts = [];
    bool _isLoading = true;
    final TextEditingController _searchController = TextEditingController();

    @override
    void initState() {
      super.initState();
      _loadContacts();
      _searchController.addListener(_filterContacts);
    }

    Future<void> _loadContacts() async {
      try {
        final contacts = await _dbHelper.getContactsByUser(widget.userId);
        setState(() {
          _contacts = contacts;
          _filteredContacts = _contacts;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Помилка завантаження контактів: $e');
      }
    }

    void _filterContacts() {
      setState(() {
        _filteredContacts = _contacts.where((contact) {
          final query = _searchController.text.toLowerCase();
          return contact.firstName.toLowerCase().contains(query) ||
              contact.lastName.toLowerCase().contains(query) ||
              contact.phoneNumber.contains(query) ||
              contact.email.toLowerCase().contains(query) ||
              contact.socialMedia.toLowerCase().contains(query);
        }).toList();
      });
    }

    Future<void> _deleteContact(int contactId) async {
      await _dbHelper.deleteContact(contactId);
      _loadContacts();
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
          title: Text('Контакти'),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Вийти з акаунта'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Видалити акаунт'),
                          onTap: () async {
                            final confirmed = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Видалення акаунта'),
                                content: Text('Ви впевнені, що хочете видалити акаунт?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text('Скасувати'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text('Видалити'),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true) {
                              await _dbHelper.deleteAccountById(widget.userId);
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            }
                          },
                        ),

                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),


        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Пошук контактів',
                  prefixIcon: Icon(Icons.search),
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
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditContactPage(userId: widget.userId),
              ),
            );
            if (result == true) {
              _loadContacts();
            }
          },
          child: Icon(Icons.add),
        ),
      );
    }
  }
