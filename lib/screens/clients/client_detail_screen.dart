import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';
import '../visits/schedule_visit_screen.dart';

class ClientDetailScreen extends StatelessWidget {
  final dynamic client;

  const ClientDetailScreen({super.key, required this.client});

  String _formatClientSince(String createdAt) {
    if (createdAt.isEmpty) {
      return 'Date d\'inscription non disponible';
    }
    try {
      return 'Client depuis ${Helpers.formatDate(createdAt)}';
    } catch (e) {
      return 'Client depuis $createdAt';
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fullName = '${client['first_name'] ?? ''} ${client['last_name'] ?? ''}'.trim();
    final createdAt = client['created_at']?.toString() ?? '';
    final email = client['email']?.toString() ?? 'Non renseigné';
    final phone = client['phone']?.toString() ?? 'Non renseigné';
    final address = client['address']?.toString();
    final notes = client['notes']?.toString();
    final clientId = client['id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Client'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête du client
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    fullName.isNotEmpty ? fullName : 'Client',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatClientSince(createdAt),
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Informations de contact
            _buildSectionTitle('Informations de Contact'),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildContactItem(Icons.email, 'Email', email),
                    if (email != 'Non renseigné') const Divider(),
                    _buildContactItem(Icons.phone, 'Téléphone', phone),
                    if (address != null && address.isNotEmpty) ...[
                      const Divider(),
                      _buildContactItem(Icons.location_on, 'Adresse', address),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Notes
            if (notes != null && notes.isNotEmpty) ...[
              _buildSectionTitle('Notes'),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    notes,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Boutons d'action
            _buildSectionTitle('Actions'),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Implémenter la modification du client
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Modification du client - Fonctionnalité à venir')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Modifier',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (clientId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScheduleVisitScreen(),
                            
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ID client non disponible')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Nouvelle Visite',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
}