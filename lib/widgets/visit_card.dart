import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';

class VisitCard extends StatelessWidget {
  final dynamic visit;
  final VoidCallback onTap;

  const VisitCard({
    super.key,
    required this.visit,
    required this.onTap,
  });

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

  @override
  Widget build(BuildContext context) {
    final scheduledDate = DateTime.parse(visit['scheduled_date']);
    final propertyTitle = visit['property_title'] ?? 'Bien immobilier';

    return Card(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getStatusColor(visit['status']).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.calendar_today, color: _getStatusColor(visit['status'])),
        ),
        title: Text(
          propertyTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Helpers.formatDateTime(scheduledDate)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(visit['status']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getStatusText(visit['status']),
                style: TextStyle(
                  color: _getStatusColor(visit['status']),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}