import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2/gestion_immobiliere/data";
  
  // Debug method
  static void _logRequest(String method, String endpoint, {Map<String, dynamic>? data, Map<String, String>? params}) {
    print('=== API REQUEST ===');
    print('Method: $method');
    print('URL: $baseUrl/$endpoint');
    if (params != null && params.isNotEmpty) {
      print('Params: $params');
    }
    if (data != null && data.isNotEmpty) {
      print('Data: $data');
    }
  }
  
  static void _logResponse(int statusCode, String body) {
    print('=== API RESPONSE ===');
    print('Status: $statusCode');
    print('Body: $body');
  }
  
  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
  
  static Future<Map<String, dynamic>> _request(
    String method,
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? params,
  }) async {
    try {
      // Construire l'URL avec les paramètres
      var url = '$baseUrl/$endpoint';
      if (params != null && params.isNotEmpty) {
        final paramsString = params.entries.map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}').join('&');
        url += '?$paramsString';
      }
      
      final uri = Uri.parse(url);
      final headers = await _getHeaders();
      
      _logRequest(method, endpoint, data: data, params: params);
      
      http.Response response;
      
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: jsonEncode(data),
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: jsonEncode(data),
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw Exception('Méthode HTTP non supportée: $method');
      }
      
      _logResponse(response.statusCode, response.body);
      
      final responseBody = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      
      if (response.statusCode == 200) {
        return responseBody;
      } else if (response.statusCode == 401) {
        await AuthService.logout();
        return {
          'success': false,
          'message': 'Session expirée. Veuillez vous reconnecter.',
          'unauthorized': true,
        };
      } else {
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Erreur HTTP ${response.statusCode}',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print('=== API ERROR ===');
      print('Error: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }
  
  // Authentification
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await _request('POST', 'auth.php', params: {
      'action': 'login'
    }, data: {
      'email': email,
      'password': password,
    });
    
    if (result['success'] == true && result['user'] != null) {
      try {
        // Créer l'objet User à partir des données de l'API
        final user = User.fromJson(result['user']);
        await AuthService.saveUser(user);
        
        if (result['token'] != null) {
          await AuthService.saveToken(result['token']);
        }
        
        // Remplacer les données user dans la réponse par l'objet User
        result['user'] = user.toMap();
      } catch (e) {
        print('Erreur lors de la création de l\'utilisateur: $e');
        return {
          'success': false,
          'message': 'Erreur lors du traitement des données utilisateur: $e',
        };
      }
    }
    
    return result;
  }
  
  // Déconnexion
  static Future<Map<String, dynamic>> logout() async {
    final result = await _request('POST', 'auth.php', params: {
      'action': 'logout'
    });
    
    await AuthService.logout();
    return result;
  }
  
  // Biens immobiliers
  static Future<Map<String, dynamic>> getProperties() async {
    return await _request('GET', 'properties.php');
  }
  
  static Future<Map<String, dynamic>> getProperty(String id) async {
    return await _request('GET', 'properties.php', params: {'id': id});
  }
  
  static Future<Map<String, dynamic>> addProperty(Map<String, dynamic> property) async {
    return await _request('POST', 'properties.php', data: property);
  }
  
  static Future<Map<String, dynamic>> updateProperty(String id, Map<String, dynamic> property) async {
    return await _request('PUT', 'properties.php', params: {'id': id}, data: property);
  }
  
  static Future<Map<String, dynamic>> deleteProperty(String id) async {
    return await _request('DELETE', 'properties.php', params: {'id': id});
  }
  
  // NOUVEAU: Recherche de propriétés
  static Future<Map<String, dynamic>> searchProperties(String query) async {
    return await _request('GET', 'properties.php', params: {
      'search': query,
    });
  }
  
  // Clients
  static Future<Map<String, dynamic>> getClients() async {
    return await _request('GET', 'clients.php');
  }
  
  static Future<Map<String, dynamic>> getClient(String id) async {
    return await _request('GET', 'clients.php', params: {'id': id});
  }
  
  static Future<Map<String, dynamic>> addClient(Map<String, dynamic> client) async {
    return await _request('POST', 'clients.php', data: client);
  }
  
  static Future<Map<String, dynamic>> updateClient(String id, Map<String, dynamic> client) async {
    return await _request('PUT', 'clients.php', params: {'id': id}, data: client);
  }
  
  static Future<Map<String, dynamic>> deleteClient(String id) async {
    return await _request('DELETE', 'clients.php', params: {'id': id});
  }
  
  // Visites
  static Future<Map<String, dynamic>> getVisits() async {
    return await _request('GET', 'visits.php');
  }
  
  static Future<Map<String, dynamic>> getVisit(String id) async {
    return await _request('GET', 'visits.php', params: {'id': id});
  }
  
  static Future<Map<String, dynamic>> addVisit(Map<String, dynamic> visit) async {
    return await _request('POST', 'visits.php', data: visit);
  }
  
  static Future<Map<String, dynamic>> updateVisitStatus(String id, String status) async {
    return await _request('PUT', 'visits.php', params: {'id': id}, data: {'status': status});
  }
  
  static Future<Map<String, dynamic>> updateVisit(String id, Map<String, dynamic> visit) async {
    return await _request('PUT', 'visits.php', params: {'id': id}, data: visit);
  }
  
  static Future<Map<String, dynamic>> deleteVisit(String id) async {
    return await _request('DELETE', 'visits.php', params: {'id': id});
  }
  
  // Statistiques
  static Future<Map<String, dynamic>> getStats() async {
    return await _request('GET', 'stats.php');
  }
}