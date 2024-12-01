class User {
  int? id; // Унікальний ідентифікатор користувача
  String username; // Ім'я користувача
  String password; // Пароль користувача

  User({
    this.id,
    required this.username,
    required this.password,
  });

  // Перетворення об'єкта User в Map (для SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  // Відновлення об'єкта User з Map (з SQLite)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }
}
