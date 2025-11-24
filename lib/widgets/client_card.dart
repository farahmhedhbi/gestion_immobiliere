import 'package:flutter/material.dart';
import '../utils/colors.dart';

class ClientCard extends StatelessWidget {
  final dynamic client;
  final VoidCallback onTap;

  const ClientCard({
    super.key,
    required this.client,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fullName = '${client['first_name']} ${client['last_name']}';

    return Card(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person, color: AppColors.primary),
        ),
        title: Text(
          fullName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(client['email'] ?? ''),
            Text(client['phone'] ?? ''),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}