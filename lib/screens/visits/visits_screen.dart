import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/visit_card.dart';
import 'visit_detail_screen.dart';
import 'schedule_visit_screen.dart';

class VisitsScreen extends StatefulWidget {
  const VisitsScreen({super.key});

  @override
  State<VisitsScreen> createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  List<dynamic> _visits = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadVisits();
  }

  void _loadVisits() async {
    final result = await ApiService.getVisits();
    setState(() {
      _isLoading = false;
      if (result['success'] == true) {
        _visits = result['visits'] ?? [];
      } else {
        _error = result['message'] ?? 'Erreur lors du chargement';
      }
    });
  }

  void _navigateToScheduleVisit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScheduleVisitScreen()),
    );
    _loadVisits();
  }

  void _navigateToVisitDetail(dynamic visit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisitDetailScreen(visit: visit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadVisits,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _visits.isEmpty
                  ? const Center(child: Text('Aucune visite planifiée'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _visits.length,
                      itemBuilder: (context, index) {
                        final visit = _visits[index];
                        return VisitCard(
                          visit: visit,
                          onTap: () => _navigateToVisitDetail(visit),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToScheduleVisit,
        child: const Icon(Icons.add),
      ),
    );
  }
}