import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/iot_component.dart';

class ApiService {
  static const String baseUrl = 'https://task.itprojects.web.id';
  final storage = const FlutterSecureStorage();

  Future<bool> login(String nim, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'username': nim, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'token', value: data['data']['token']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<IotComponent>> getDrafts() async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) return [];

      final response = await http.get(
        Uri.parse('$baseUrl/api/products'),
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List products = data['products'] ?? [];
        return products.map((json) => IotComponent.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> addDraft(String name, int price, String description) async {
    try {
      String? token = await storage.read(key: 'token');
      final response = await http.post(
        Uri.parse('$baseUrl/api/products'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'name': name, 'price': price, 'description': description}),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> submitTask(String name, int price, String desc, String githubUrl) async {
    try {
      String? token = await storage.read(key: 'token');
      final response = await http.post(
        Uri.parse('$baseUrl/api/products/submit'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'name': name, 'price': price, 'description': desc, 'github_url': githubUrl}),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}