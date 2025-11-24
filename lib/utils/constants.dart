class AppConstants {
  static const String appName = 'ImmoPro';
  
  // Types de biens
  static const List<String> propertyTypes = [
    'Maison',
    'Appartement',
    'Villa',
    'Studio',
    'Loft',
    'Commerce',
    'Bureau',
    'Terrain'
  ];
  
  // Statuts des visites
  static const String visitPlanned = 'planned';
  static const String visitCompleted = 'completed';
  static const String visitCancelled = 'cancelled';
  
  // Rôles utilisateurs
  static const String roleAgent = 'agent';
  static const String roleAdmin = 'admin';
}