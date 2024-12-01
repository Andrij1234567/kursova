import 'package:flutter/material.dart';
import '../models/contact_model.dart';

class ContactDetailsPage extends StatelessWidget {
  final Contact contact;

  const ContactDetailsPage({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${contact.firstName} ${contact.lastName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailTile(
                icon: Icons.person,
                label: 'Ім\'я',
                value: contact.firstName,
              ),
              _buildDetailTile(
                icon: Icons.person_outline,
                label: 'Прізвище',
                value: contact.lastName,
              ),
              _buildDetailTile(
                icon: Icons.phone,
                label: 'Телефон',
                value: contact.phoneNumber,
              ),
              _buildDetailTile(
                icon: Icons.email,
                label: 'Email',
                value: contact.email ?? 'Не вказано',
              ),
              // Додано поле для соціальних мереж
              _buildDetailTile(
                icon: Icons.social_distance, // Використовуємо іконку для соціальних мереж
                label: 'Соціальні мережі',
                value: contact.socialMedia ?? 'Не вказано',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, size: 28, color: Colors.blue),
      title: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        value,
        style: TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }
}
