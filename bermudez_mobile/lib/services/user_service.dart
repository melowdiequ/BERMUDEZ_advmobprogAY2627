import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../models/user.dart';

class UserService {
  Map<String, dynamic> data = {};

  Future<Map<String, dynamic>> loginUser(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse(
        '$host/auth/login',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 60,
      }),
    );

    if (response.statusCode == 200) {
      data = jsonDecode(
        response.body,
      );

      await saveUserData(
        data,
      );

      return data;
    } else {
      throw Exception(
        response.body,
      );
    }
  }

  // Lab Activity 4 - Enhancement 3: Converts the authenticated API response into a User model before saving its values to SharedPreferences.
  Future<void> saveUserData(
    Map<String, dynamic> userData,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final User user =
        User.fromJson(
      userData,
    );

    await prefs.setInt(
      'id',
      user.id,
    );

    await prefs.setString(
      'username',
      user.username,
    );

    await prefs.setString(
      'email',
      user.email,
    );

    await prefs.setString(
      'firstName',
      user.firstName,
    );

    await prefs.setString(
      'lastName',
      user.lastName,
    );

    await prefs.setString(
      'gender',
      user.gender,
    );

    await prefs.setString(
      'image',
      user.image,
    );

    await prefs.setString(
      'accessToken',
      user.accessToken,
    );

    await prefs.setString(
      'refreshToken',
      user.refreshToken,
    );

    await prefs.setString(
      'token',
      user.accessToken,
    );
  }

  // Lab Activity 4 - Enhancement 3: Retrieves the saved user information from SharedPreferences.
  Future<Map<String, dynamic>> getUserData() async {
    final prefs =
        await SharedPreferences.getInstance();

    return {
      'id':
          prefs.getInt('id') ?? 0,
      'username':
          prefs.getString('username') ?? '',
      'email':
          prefs.getString('email') ?? '',
      'firstName':
          prefs.getString('firstName') ?? '',
      'lastName':
          prefs.getString('lastName') ?? '',
      'gender':
          prefs.getString('gender') ?? '',
      'image':
          prefs.getString('image') ?? '',
      'accessToken':
          prefs.getString('accessToken') ?? '',
      'refreshToken':
          prefs.getString('refreshToken') ?? '',
    };
  }

  // Lab Activity 4 - Enhancement 3: Converts the saved SharedPreferences data back into a User model.
  Future<User> getUser() async {
    final userData =
        await getUserData();

    return User.fromJson(
      userData,
    );
  }

  // Lab Activity 4 - Enhancement 1: Checks whether a saved authentication token exists for persistent login.
  Future<bool> isLoggedIn() async {
    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString(
      'accessToken',
    );

    return token != null &&
        token.isNotEmpty;
  }

  // Clears the authenticated user's saved data when logging out.
  Future<void> logout() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      await prefs.clear();
    } catch (e) {
      throw Exception(
        'Failed to log out: $e',
      );
    }
  }
}