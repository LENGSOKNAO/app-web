import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  // api link
  static const String baseUrl = "http://10.0.2.2:8000/api";
  // product
  static const String product = "$baseUrl/banners";
  // get product by
  static Future<List> getProductBy() async {
    final response = await http.get(Uri.parse(product));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }
}
