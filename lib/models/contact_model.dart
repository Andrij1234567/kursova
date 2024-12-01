class Contact {
  int? id; // Унікальний ідентифікатор контакту
  int userId; // Ідентифікатор користувача, якому належить контакт
  String firstName; // Ім'я контакту
  String lastName; // Прізвище контакту
  String phoneNumber; // Номер телефону
  String email; // Електронна пошта
  String socialMedia; // Соціальні мережі

  Contact({
    this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.socialMedia,
  });

  // Перетворення об'єкта Contact в Map (для SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'socialMedia': socialMedia,
    };
  }

  // Відновлення об'єкта Contact з Map (з SQLite)
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      userId: map['userId'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      socialMedia: map['socialMedia'],
    );
  }
}
