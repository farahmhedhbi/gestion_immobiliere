import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/property_card.dart';
import 'property_detail_screen.dart';
import 'add_property_screen.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  List<dynamic> _properties = [];
  bool _isLoading = true;
  String _error = '';
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    if (!_isRefreshing) {
      setState(() {
        _isLoading = true;
        _error = '';
      });
    }

    final result = await ApiService.getProperties();
    
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        if (result['success'] == true) {
          _properties = result['properties'] ?? [];
        } else {
          _error = result['message'] ?? 'Erreur lors du chargement';
        }
      });
    }
  }

  Future<void> _refreshProperties() async {
    setState(() {
      _isRefreshing = true;
    });
    await _loadProperties();
  }

  void _navigateToAddProperty() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPropertyScreen()),
    );
    
    if (result == true) {
      _refreshProperties();
    }
  }

  void _navigateToPropertyDetail(dynamic property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailScreen(property: property),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_work_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucun bien immobilier',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Commencez par ajouter votre premier bien',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.red[400],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              _error,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _refreshProperties,
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800 
            ? 4 
            : constraints.maxWidth > 600 
                ? 3 
                : 2;
        
        // RATIO AUGMENTÉ pour correspondre à la hauteur fixe
        final childAspectRatio = crossAxisCount == 4 
            ? 0.7 
            : crossAxisCount == 3 
                ? 0.75 
                : 0.8;

        return RefreshIndicator(
          onRefresh: _refreshProperties,
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: _properties.length,
            itemBuilder: (context, index) {
              final property = _properties[index];
              return PropertyCard(
                property: property,
                onTap: () => _navigateToPropertyDetail(property),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biens Immobiliers'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implémenter la recherche
            },
          ),
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshProperties,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Chargement des biens...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : _error.isNotEmpty
              ? _buildErrorState()
              : _properties.isEmpty
                  ? _buildEmptyState()
                  : _buildGridView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProperty,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }
}