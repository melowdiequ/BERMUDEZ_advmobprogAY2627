import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../models/product.dart';

class ProductService {
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$host/products'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body);

        final List productsJson =
            data['products'] ?? [];

        return productsJson
            .map(
              (json) => Product.fromJson(json),
            )
            .toList();
      } else {
        throw Exception(
          "Failed to load products",
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Lab Activity 3 - Enhancement 1:
  // Gets the complete product using the product ID
  Future<Product> getProductById(int productId) async {
    try {
      final response = await http.get(
        Uri.parse('$host/products/$productId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body);

        return Product.fromJson(data);
      } else {
        throw Exception(
          "Failed to load product",
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}