import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/client_card.dart';
import 'client_detail_screen.dart';
import 'add_client_screen.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  List<dynamic> _clients = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  void _loadClients() async {
    final result = await ApiService.getClients();
    setState(() {
      _isLoading = false;
      if (result['success'] == true) {
        _clients = result['clients'] ?? [];
      } else {
        _error = result['message'] ?? 'Erreur lors du chargement';
      }
    });
  }

  void _navigateToAddClient() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddClientScreen()),
    );
    _loadClients();
  }

  void _navigateToClientDetail(dynamic client) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientDetailScreen(client: client),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadClients,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _clients.isEmpty
                  ? const Center(child: Text('Aucun client trouvé'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _clients.length,
                      itemBuilder: (context, index) {
                        final client = _clients[index];
                        return ClientCard(
                          client: client,
                          onTap: () => _navigateToClientDetail(client),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddClient,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}