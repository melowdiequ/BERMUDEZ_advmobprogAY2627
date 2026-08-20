import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../models/cart.dart';

class CartService {
  Future<List<Cart>> getAllCarts() async {
    try {
      final response = await http.get(
        Uri.parse('$host/carts'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body);

        final List cartsJson =
            data['carts'] ?? [];

        return cartsJson
            .map(
              (json) => Cart.fromJson(json),
            )
            .toList();
      } else {
        throw Exception(
          "Failed to load carts",
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Lab Activity 3 - Enhancement 3:
  // Retrieves one cart using its cart ID.
  Future<Cart> getCartById(
    int cartId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$host/carts/$cartId',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body);

        return Cart.fromJson(data);
      } else {
        throw Exception(
          "Failed to load cart",
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Lab Activity 3 - Enhancement 3
  Future<Cart> getCartByUserId(
    int userId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$host/carts/user/$userId',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body);

        final List cartsJson =
            data['carts'] ?? [];

        if (cartsJson.isEmpty) {
          throw Exception(
            "No cart found for user $userId",
          );
        }
        return Cart.fromJson(
          cartsJson.first,
        );
      } else {
        throw Exception(
          "Failed to load cart for user $userId",
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Lab Activity 3 - Enhancement 3
  Future<Cart> addToCart({
    required int userId,
    required int productId,
    required int quantity,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$host/carts/add',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'products': [
            {
              'id': productId,
              'quantity': quantity,
            }
          ],
        }),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        final Map<String, dynamic> data =
            jsonDecode(response.body);

        return Cart.fromJson(data);
      } else {
        throw Exception(
          "Failed to add product to cart",
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}