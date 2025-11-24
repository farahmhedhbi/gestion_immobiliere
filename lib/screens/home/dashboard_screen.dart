import 'package:flutter/material.dart';
import 'package:gestion_immobiliere/screens/clients/clients_screen.dart';
import 'package:gestion_immobiliere/screens/properties/properties_screen.dart';
import 'package:gestion_immobiliere/screens/visits/visits_screen.dart';
import '../../services/api_service.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';
import '../../widgets/stats_card.dart';

class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const DashboardScreen({super.key, required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() async {
    final result = await ApiService.getStats();
    setState(() {
      _isLoading = false;
      if (result['success'] == true) {
        _stats = result['stats'] ?? {};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête de bienvenue
            _buildWelcomeHeader(),
            
            const SizedBox(height: 24),
            
            // Statistiques
            _buildStatsSection(),
            
            const SizedBox(height: 24),
            
            // Actions rapides
            _buildQuickActions(),
            
            const SizedBox(height: 24),
            
            // Prochaines visites
            _buildNextVisits(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primary,
              child: Text(
                widget.user['name']?[0] ?? 'U',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour, ${widget.user['name']?.split(' ').first ?? 'Utilisateur'}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bienvenue sur votre tableau de bord',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aperçu du Mois',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            StatsCard(
              title: 'Biens',
              value: _stats['properties']?.toString() ?? '0',
              icon: Icons.home,
              color: AppColors.primary,
            ),
            StatsCard(
              title: 'Clients',
              value: _stats['clients']?.toString() ?? '0',
              icon: Icons.people,
              color: AppColors.secondary,
            ),
            StatsCard(
              title: 'Visites',
              value: _stats['visits']?.toString() ?? '0',
              icon: Icons.calendar_today,
              color: AppColors.accent,
            ),
            StatsCard(
              title: 'Visites Planifiées',
              value: _stats['planned_visits']?.toString() ?? '0',
              icon: Icons.event_available,
              color: AppColors.success,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions Rapides',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildQuickActionCard(
              'Voir les Biens',
              Icons.home,
              AppColors.primary,
              () {
              // Naviguer vers les biens
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PropertiesScreen(),
                ),
              );
            },
            ),
            _buildQuickActionCard(
              'Voir les Clients',
              Icons.people,
              AppColors.secondary,
              () {
              // Naviguer vers les clients
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClientsScreen(),
                ),
              );
            },
            ),
            _buildQuickActionCard(
              'Planifier Visite',
              Icons.calendar_today,
              AppColors.accent,
              ()  {
              // Naviguer vers les clients
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClientsScreen(),
                ),
              );
            },
            ),
            _buildQuickActionCard(
              'Ajouter un Bien',
              Icons.add_home,
              AppColors.success,
              () {
              // Naviguer vers les visites
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VisitsScreen(),
                ),
              );
            },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextVisits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prochaines Visites',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildVisitItem('Appartement Moderne', 'Demain 14:00', 'Jean Martin'),
                const Divider(),
                _buildVisitItem('Maison avec Jardin', '05/12 10:00', 'Sophie Bernard'),
                const Divider(),
                _buildVisitItem('Studio Centre-ville', '07/12 16:30', 'Pierre Moreau'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisitItem(String property, String time, String client) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
      ),
      title: Text(
        property,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        client,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textLight,
        ),
      ),
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textLight,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}