import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/colors.dart';

class ScheduleVisitScreen extends StatefulWidget {
  const ScheduleVisitScreen({super.key});

  @override
  State<ScheduleVisitScreen> createState() => _ScheduleVisitScreenState();
}

class _ScheduleVisitScreenState extends State<ScheduleVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 0);
  String? _selectedProperty;
  String? _selectedClient;

  List<dynamic> _properties = [];
  List<dynamic> _clients = [];
  bool _isLoading = false;
  bool _isDataLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final propertiesResult = await ApiService.getProperties();
    final clientsResult = await ApiService.getClients();
    
    setState(() {
      _isDataLoading = false;
      if (propertiesResult['success'] == true) {
        _properties = propertiesResult['properties'] ?? [];
      }
      if (clientsResult['success'] == true) {
        _clients = clientsResult['clients'] ?? [];
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedProperty == null || _selectedClient == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner un bien et un client')),
        );
        return;
      }

      setState(() => _isLoading = true);

      final scheduledDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final visitData = {
        'property_id': int.parse(_selectedProperty!),
        'client_id': int.parse(_selectedClient!),
        'agent_id': 1, // ID de l'agent connecté
        'scheduled_date': scheduledDateTime.toIso8601String(),
        'notes': _notesController.text.isEmpty ? null : _notesController.text,
      };

      final result = await ApiService.addVisit(visitData);
      
      setState(() => _isLoading = false);
      
      if (result['success'] == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visite planifiée avec succès')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Erreur lors de la planification')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planifier une Visite'),
      ),
      body: _isDataLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Sélection du bien
                    _buildSectionHeader('Sélection du Bien'),
                    DropdownButtonFormField<String>(
                      value: _selectedProperty,
                      decoration: const InputDecoration(
                        labelText: 'Choisir un bien *',
                        border: OutlineInputBorder(),
                      ),
                      items: _properties.map((property) {
                        return DropdownMenuItem(
                          value: property['id'].toString(),
                          child: Text(property['title']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedProperty = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner un bien';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Sélection du client
                    DropdownButtonFormField<String>(
                      value: _selectedClient,
                      decoration: const InputDecoration(
                        labelText: 'Choisir un client *',
                        border: OutlineInputBorder(),
                      ),
                      items: _clients.map((client) {
                        return DropdownMenuItem(
                          value: client['id'].toString(),
                          child: Text('${client['first_name']} ${client['last_name']}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedClient = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner un client';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Date et heure
                    _buildSectionHeader('Date et Heure'),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Date *',
                                border: OutlineInputBorder(),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                  ),
                                  const Icon(Icons.calendar_today),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectTime(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Heure *',
                                border: OutlineInputBorder(),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_selectedTime.format(context)),
                                  const Icon(Icons.access_time),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Notes
                    _buildSectionHeader('Notes'),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Notes pour la visite',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Bouton de soumission
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Planifier la Visite',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
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
}