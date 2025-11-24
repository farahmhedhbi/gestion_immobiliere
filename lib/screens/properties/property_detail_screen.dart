import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';

class PropertyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> property;

  const PropertyDetailScreen({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    final title = property['title'] ?? 'Sans titre';
    final price = property['price'] is String 
        ? double.tryParse(property['price']) ?? 0
        : (property['price'] as num?)?.toDouble() ?? 0;
    final address = property['address'] ?? '';
    final city = property['city'] ?? '';
    final postalCode = property['postal_code'] ?? '';
    final isAvailable = property['is_available'] == 1 || property['is_available'] == true;
    final bedrooms = property['bedrooms']?.toString() ?? '0';
    final bathrooms = property['bathrooms']?.toString() ?? '0';
    final surface = property['surface'] is String 
        ? double.tryParse(property['surface']) ?? 0
        : (property['surface'] as num?)?.toDouble() ?? 0;
    final description = property['description'] ?? 'Aucune description disponible';
    final type = property['type'] ?? 'Non spécifié';
    final createdAt = property['created_at'] ?? '';

    final fullAddress = [address, postalCode, city]
        .where((component) => component != null && component.toString().isNotEmpty)
        .join(', ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du bien'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image principale
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.home,
                size: 80,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 20),

            // Titre et prix
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  Helpers.formatCurrency(price),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Adresse
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.textLight),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    fullAddress.isNotEmpty ? fullAddress : 'Adresse non renseignée',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Statut
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isAvailable 
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isAvailable ? 'Disponible' : 'Vendu/Loué',
                style: TextStyle(
                  color: isAvailable ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Caractéristiques
            _buildSectionTitle('Caractéristiques'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFeatureItem(Icons.hotel, '$bedrooms Chambres'),
                _buildFeatureItem(Icons.bathtub, '$bathrooms SdB'),
                _buildFeatureItem(Icons.square_foot, '${surface.toInt()}m²'),
                _buildFeatureItem(_getTypeIcon(type), _getTypeLabel(type)),
              ],
            ),

            const SizedBox(height: 20),

            // Description
            _buildSectionTitle('Description'),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // Informations additionnelles
            _buildSectionTitle('Informations'),
            const SizedBox(height: 12),
            _buildInfoItem('Type de bien', _getTypeLabel(type)),
            _buildInfoItem('Surface', '${surface.toInt()} m²'),
            _buildInfoItem('Chambres', bedrooms),
            _buildInfoItem('Salles de bain', bathrooms),
            _buildInfoItem('Date d\'ajout', _formatDate(createdAt)),

            const SizedBox(height: 30),

            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showScheduleVisitDialog(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.primary),
                    ),
                    child: const Text(
                      'Planifier Visite',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showContactDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Contacter',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'appartement':
        return Icons.apartment;
      case 'maison':
        return Icons.house;
      case 'terrain':
        return Icons.landscape;
      case 'bureau':
        return Icons.business;
      default:
        return Icons.home;
    }
  }

  String _getTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'appartement':
        return 'Appartement';
      case 'maison':
        return 'Maison';
      case 'terrain':
        return 'Terrain';
      case 'bureau':
        return 'Bureau';
      default:
        return type;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _showScheduleVisitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Planifier une visite'),
        content: const Text('Fonctionnalité à venir : planification de visite.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contacter l\'agent'),
        content: const Text('Fonctionnalité à venir : contact avec l\'agent immobilier.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}