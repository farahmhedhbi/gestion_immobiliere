import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';

class PropertyCard extends StatelessWidget {
  final dynamic property;
  final VoidCallback onTap;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final price = property['price'] is String 
        ? double.tryParse(property['price']) ?? 0
        : (property['price'] as num?)?.toDouble() ?? 0;
        
    final surface = property['surface'] is String 
        ? double.tryParse(property['surface']) ?? 0
        : (property['surface'] as num?)?.toDouble() ?? 0;
        
    final isAvailable = property['is_available'] == 1 || property['is_available'] == true;
    final type = property['type']?.toString().toLowerCase() ?? 'maison';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image du bien avec badge de type
              Stack(
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _getTypeColor(type).withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Icon(
                      _getTypeIcon(type),
                      size: 32,
                      color: _getTypeColor(type),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getTypeLabel(type),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Contenu de la carte
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Titre et adresse
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            property['title']?.toString() ?? 'Sans titre',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatCompactAddress(property),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 9,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      
                      // Caractéristiques
                      _buildUltraCompactFeatures(property, surface),
                      
                      // Prix et statut
                      _buildUltraCompactPriceAndStatus(price, isAvailable),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUltraCompactFeatures(dynamic property, double surface) {
    final bedrooms = property['bedrooms']?.toString() ?? '0';
    final bathrooms = property['bathrooms']?.toString() ?? '0';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildUltraMiniFeature(Icons.hotel, bedrooms),
        _buildUltraMiniFeature(Icons.bathtub, bathrooms),
        _buildUltraMiniFeature(Icons.square_foot, '${surface.toInt()}'),
      ],
    );
  }

  Widget _buildUltraMiniFeature(IconData icon, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 10,
          color: Colors.blue,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildUltraCompactPriceAndStatus(double price, bool isAvailable) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            Helpers.formatCurrency(price),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: isAvailable 
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            isAvailable ? 'Dispo' : 'Vendu',
            style: TextStyle(
              fontSize: 7,
              color: isAvailable ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _formatCompactAddress(dynamic property) {
    final city = property['city'] ?? '';
    final postalCode = property['postal_code'] ?? '';
    
    if (city.isNotEmpty && postalCode.isNotEmpty) {
      return '$postalCode $city';
    }
    
    final address = property['address'] ?? '';
    if (address.isNotEmpty) {
      return address.length > 20 ? '${address.substring(0, 20)}...' : address;
    }
    
    return 'Adresse non dispo.';
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'appartement':
        return Colors.orange;
      case 'maison':
        return Colors.green;
      case 'terrain':
        return Colors.brown;
      case 'bureau':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
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
    switch (type) {
      case 'appartement':
        return 'APT';
      case 'maison':
        return 'MAISON';
      case 'terrain':
        return 'TERRAIN';
      case 'bureau':
        return 'BUREAU';
      default:
        return type.length > 6 ? type.substring(0, 6).toUpperCase() : type.toUpperCase();
    }
  }
}