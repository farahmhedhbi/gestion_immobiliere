class Visit {
  final String id;
  final String propertyId;
  final String clientId;
  final String agentId;
  final DateTime scheduledDate;
  final String status; // planned, completed, cancelled
  final String? notes;
  final int? rating;
  final String? feedback;
  final DateTime createdAt;

  Visit({
    required this.id,
    required this.propertyId,
    required this.clientId,
    required this.agentId,
    required this.scheduledDate,
    required this.status,
    this.notes,
    this.rating,
    this.feedback,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'propertyId': propertyId,
      'clientId': clientId,
      'agentId': agentId,
      'scheduledDate': scheduledDate.toIso8601String(),
      'status': status,
      'notes': notes,
      'rating': rating,
      'feedback': feedback,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Visit.fromMap(Map<String, dynamic> map) {
    return Visit(
      id: map['id'],
      propertyId: map['propertyId'],
      clientId: map['clientId'],
      agentId: map['agentId'],
      scheduledDate: DateTime.parse(map['scheduledDate']),
      status: map['status'],
      notes: map['notes'],
      rating: map['rating'],
      feedback: map['feedback'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}