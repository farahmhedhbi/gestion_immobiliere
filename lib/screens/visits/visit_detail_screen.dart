import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';

class VisitDetailScreen extends StatefulWidget {
  final dynamic visit;

  const VisitDetailScreen({super.key, required this.visit});

  @override
  State<VisitDetailScreen> createState() => _VisitDetailScreenState();
}

class _VisitDetailScreenState extends State<VisitDetailScreen> {
  late dynamic _visit;

  @override
  void initState() {
    super.initState();
    _visit = widget.visit;
  }

  void _updateVisitStatus(String newStatus) async {
    final result = await ApiService.updateVisitStatus(_visit['id'].toString(), newStatus);
    
    if (result['success'] == true) {
      setState(() {
        _visit['status'] = newStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Statut mis à jour: ${_getStatusText(newStatus)}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Erreur lors de la mise à jour')),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'planned':
        return AppColors.info;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textLight;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'planned':
        return 'Planifiée';
      case 'completed':
        return 'Terminée';
      case 'cancelled':
        return 'Annulée';
      default:
        return status;
    }
  }

  String _formatScheduledDate() {
    try {
      final scheduledDate = DateTime.parse(_visit['scheduled_date']);
      return Helpers.formatDateTime(scheduledDate);
    } catch (e) {
      return _visit['scheduled_date'] ?? 'Date non définie';
    }
  }

  String _formatCompletionDate() {
    try {
      final scheduledDate = DateTime.parse(_visit['scheduled_date']);
      return Helpers.formatDate(scheduledDate.toString());
    } catch (e) {
      return _visit['scheduled_date'] ?? 'Date non définie';
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyTitle = _visit['property_title'] ?? 'Bien immobilier';
    final clientName = '${_visit['first_name'] ?? ''} ${_visit['last_name'] ?? ''}'.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Visite'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête de la visite
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Visite #${_visit['id']}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(_visit['status']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getStatusText(_visit['status']),
                            style: TextStyle(
                              color: _getStatusColor(_visit['status']),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _formatScheduledDate(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Informations sur le bien
            _buildSectionTitle('Bien Immobilier'),
            Card(
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.home, color: AppColors.primary),
                ),
                title: Text(propertyTitle),
                subtitle: const Text('Voir les détails'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Naviguer vers le détail du bien
                },
              ),
            ),

            const SizedBox(height: 16),

            // Informations sur le client
            _buildSectionTitle('Client'),
            Card(
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: AppColors.secondary),
                ),
                title: Text(clientName.isNotEmpty ? clientName : 'Client'),
                subtitle: const Text('Voir les détails'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Naviguer vers le détail du client
                },
              ),
            ),

            const SizedBox(height: 20),

            // Notes
            if (_visit['notes'] != null && _visit['notes'].toString().isNotEmpty) ...[
              _buildSectionTitle('Notes'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _visit['notes'].toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Actions
            _buildSectionTitle('Actions'),
            if (_visit['status'] == 'planned') ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _updateVisitStatus('cancelled'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateVisitStatus('completed'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Marquer Terminée'),
                    ),
                  ),
                ],
              ),
            ],

            if (_visit['status'] == 'completed') ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visite terminée',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Cette visite a été marquée comme terminée le ${_formatCompletionDate()}.'),
                    ],
                  ),
                ),
              ),
            ],

            if (_visit['status'] == 'cancelled') ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visite annulée',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Cette visite a été annulée.'),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),
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
}