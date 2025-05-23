import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartApiService {
  final String baseUrl = "http://localhost:3000/";

  Future<List<dynamic>> addToCart(String productId, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.post(
        Uri.parse('${baseUrl}cart'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          'productId': productId,
          'qty': quantity,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load cart: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error fetching cart: $e");
    }
  }

  Future<List<dynamic>> fetchCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}cart'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );
      print("Response Body: ${response.body}");
      print("Response : $response");
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load cart");
      }
    } catch (e) {
      throw Exception("Error fetching cart: $e");
    }
  }

  Future<void> updateCartQuantity(String productId, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.put(
        Uri.parse('${baseUrl}cart'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          'productId': productId,
          'qty': quantity,
        }),
      );

      print("Update Cart Status Code: ${response.statusCode}");
      print("Update Cart Response: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("Failed to update cart: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error updating cart: $e");
    }
  }

  Future<void> deleteCartItem(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}cart'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          'productId': productId,
        }),
      );
      print("Remove Cart Status Code: ${response.statusCode}");
      print("Remove Cart Response: ${response.body}");
      if (response.statusCode != 200) {
        throw Exception("Failed to remove item from cart");
      }
    } catch (e) {
      throw Exception("Error removing item from cart: $e");
    }
  }
}
