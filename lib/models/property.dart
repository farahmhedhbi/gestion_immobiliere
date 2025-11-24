class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String address;
  final String city;
  final String postalCode;
  final String type; // maison, appartement, villa, etc.
  final int bedrooms;
  final int bathrooms;
  final double surface;
  final List<String> images;
  final bool isAvailable;
  final String agentId;
  final DateTime createdAt;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.type,
    required this.bedrooms,
    required this.bathrooms,
    required this.surface,
    required this.images,
    required this.isAvailable,
    required this.agentId,
    required this.createdAt,
  });

  String get formattedPrice {
    return '€${price.toStringAsFixed(0)}';
  }

  String get fullAddress {
    return '$address, $postalCode $city';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'type': type,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'surface': surface,
      'images': images,
      'isAvailable': isAvailable,
      'agentId': agentId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      price: map['price'].toDouble(),
      address: map['address'],
      city: map['city'],
      postalCode: map['postalCode'],
      type: map['type'],
      bedrooms: map['bedrooms'],
      bathrooms: map['bathrooms'],
      surface: map['surface'].toDouble(),
      images: List<String>.from(map['images']),
      isAvailable: map['isAvailable'],
      agentId: map['agentId'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}