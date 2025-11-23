import 'dart:convert';
import 'package:app_nike/model/model_product.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Product.fromJson(data)).toList();
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
