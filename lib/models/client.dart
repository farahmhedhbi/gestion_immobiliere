class Client {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? address;
  final String? notes;
  final String agentId;
  final DateTime createdAt;

  Client({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.address,
    this.notes,
    required this.agentId,
    required this.createdAt,
  });

  String get fullName {
    return '$firstName $lastName';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'notes': notes,
      'agentId': agentId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      notes: map['notes'],
      agentId: map['agentId'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}