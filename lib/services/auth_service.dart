import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';

  // Version simple sans SharedPreferences (pour tests)
  static User? _currentUser;
  static String? _token;
  static bool _isLoggedIn = false;

  // Sauvegarder l'utilisateur
  static Future<void> saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toMap()));
      await prefs.setBool(_isLoggedInKey, true);
      _currentUser = user;
      _isLoggedIn = true;
    } catch (e) {
      // Fallback: sauvegarde en mémoire
      print('Erreur SharedPreferences, utilisation mémoire: $e');
      _currentUser = user;
      _isLoggedIn = true;
    }
  }

  // Sauvegarder le token
  static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      _token = token;
    } catch (e) {
      print('Erreur sauvegarde token: $e');
      _token = token;
    }
  }

  // Récupérer l'utilisateur
  static Future<User?> getUser() async {
    if (_currentUser != null) return _currentUser;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(_userKey);
      
      if (userString != null) {
        final userMap = jsonDecode(userString) as Map<String, dynamic>;
        return User.fromMap(userMap);
      }
      return null;
    } catch (e) {
      print('Erreur récupération utilisateur: $e');
      return _currentUser;
    }
  }

  // Récupérer le token
  static Future<String?> getToken() async {
    if (_token != null) return _token;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Erreur récupération token: $e');
      return _token;
    }
  }

  // Vérifier si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    if (_isLoggedIn) return true;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('Erreur vérification connexion: $e');
      return _isLoggedIn;
    }
  }

  // Déconnexion - Supprimer toutes les données
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);
      await prefs.remove(_isLoggedInKey);
    } catch (e) {
      print('Erreur déconnexion SharedPreferences: $e');
    } finally {
      // Toujours nettoyer la mémoire
      _currentUser = null;
      _token = null;
      _isLoggedIn = false;
    }
  }

  // Mettre à jour les informations de l'utilisateur
  static Future<void> updateUser(User user) async {
    await saveUser(user);
  }
}