class Contact {
  int? id;
  int userId;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String socialMedia;

  Contact({
    this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.socialMedia,
  });

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
