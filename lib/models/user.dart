class User {
  final String id;
  final String name;
  final String email;
  final String? phone; // Rendre le téléphone optionnel
  final String role; // agent, admin
  final String? agency; // Agence de l'utilisateur
  final DateTime createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.agency,
    required this.createdAt,
    this.updatedAt,
  });

  // Convertir User en Map pour le stockage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'agency': agency,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Créer un User à partir d'un Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toString() ?? '', // Gérer les IDs numériques
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      role: map['role'] ?? 'agent',
      agency: map['agency'],
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  // Créer un User à partir des données JSON de l'API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? json['telephone'],
      role: json['role'] ?? 'agent',
      agency: json['agency'] ?? json['agence'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : (json['createdAt'] != null 
              ? DateTime.parse(json['createdAt'])
              : DateTime.now()),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'])
          : (json['updatedAt'] != null 
              ? DateTime.parse(json['updatedAt'])
              : null),
    );
  }

  // Convertir en JSON pour l'API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'agency': agency,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Copier avec modifications
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? agency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      agency: agency ?? this.agency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Méthode pour afficher le nom complet
  String get displayName => name;

  // Vérifier si c'est un admin
  bool get isAdmin => role.toLowerCase() == 'admin';

  // Vérifier si c'est un agent
  bool get isAgent => role.toLowerCase() == 'agent';

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}