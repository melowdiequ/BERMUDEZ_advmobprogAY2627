import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../models/user.dart';

class UserService {
  Map<String, dynamic> data = {};

  final fb.FirebaseAuth firebaseAuth =
      fb.FirebaseAuth.instance;

  // Lab Activity 5 - Enhancement 1: Returns the currently authenticated Firebase user.
  fb.User? get currentFirebaseUser =>
      firebaseAuth.currentUser;

  // Lab Activity 5 - Enhancement 1: Listens for Firebase authentication state changes.
  Stream<fb.User?> get authStateChanges =>
      firebaseAuth.authStateChanges();

  // Lab Activity 4: Authenticates a user through the DummyJSON API.
  Future<Map<String, dynamic>> loginUser(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$host/auth/login'),
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
      data = jsonDecode(response.body);

      await saveUserData(data);

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        'loginType',
        'dummyjson',
      );

      return data;
    }

    throw Exception(response.body);
  }

  // Lab Activity 5 - Enhancement 2: Signs in an existing Firebase account and restores its locally saved profile.
  Future<fb.UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final credential =
        await firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final firebaseUser =
        credential.user;

    if (firebaseUser == null) {
      throw Exception(
        'Unable to retrieve Firebase user.',
      );
    }

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'loginType',
      'firebase',
    );

    await prefs.setString(
      'firebaseUid',
      firebaseUser.uid,
    );

    await prefs.setString(
      'email',
      firebaseUser.email ?? '',
    );

    await prefs.setString(
      'username',
      firebaseUser.displayName ?? '',
    );

    return credential;
  }

  // Lab Activity 5 - Enhancement 2: Creates a Firebase account and saves the additional signup information using the Firebase UID.
  Future<fb.UserCredential> createAccount({
    required String firstName,
    required String lastName,
    required int age,
    required String contactNo,
    required String username,
    required String email,
    required String password,
  }) async {
    final credential =
        await firebaseAuth
            .createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final firebaseUser =
        credential.user;

    if (firebaseUser == null) {
      throw Exception(
        'Unable to create Firebase user.',
      );
    }

    await firebaseUser.updateDisplayName(
      username.trim(),
    );

    final prefs =
        await SharedPreferences.getInstance();

    final uid =
        firebaseUser.uid;

    await prefs.setString(
      'firebase_${uid}_firstName',
      firstName.trim(),
    );

    await prefs.setString(
      'firebase_${uid}_lastName',
      lastName.trim(),
    );

    await prefs.setInt(
      'firebase_${uid}_age',
      age,
    );

    await prefs.setString(
      'firebase_${uid}_contactNo',
      contactNo.trim(),
    );

    await prefs.setString(
      'firebase_${uid}_username',
      username.trim(),
    );

    await prefs.setString(
      'firebase_${uid}_email',
      email.trim(),
    );

    await prefs.setString(
      'loginType',
      'firebase',
    );

    await prefs.setString(
      'firebaseUid',
      uid,
    );

    await prefs.setString(
      'firstName',
      firstName.trim(),
    );

    await prefs.setString(
      'lastName',
      lastName.trim(),
    );

    await prefs.setInt(
      'age',
      age,
    );

    await prefs.setString(
      'contactNo',
      contactNo.trim(),
    );

    await prefs.setString(
      'username',
      username.trim(),
    );

    await prefs.setString(
      'email',
      email.trim(),
    );

    return credential;
  }

  // Lab Activity 5 - Enhancement 1: Signs out from Firebase and clears only the active session while preserving locally saved Firebase profile details.
  Future<void> signOut() async {
    await firebaseAuth.signOut();

    await _clearActiveSession();
  }

  // Lab Activity 5 - Enhancement 3: Updates the Firebase display name and locally saved username.
  Future<void> updateUsername({
    required String username,
  }) async {
    final currentUser =
        firebaseAuth.currentUser;

    if (currentUser == null) {
      throw Exception(
        'No Firebase user is currently signed in.',
      );
    }

    final newUsername =
        username.trim();

    if (newUsername.isEmpty) {
      throw Exception(
        'Username cannot be empty.',
      );
    }

    await currentUser.updateDisplayName(
      newUsername,
    );

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'username',
      newUsername,
    );

    await prefs.setString(
      'firebase_${currentUser.uid}_username',
      newUsername,
    );
  }

  // Lab Activity 5 - Enhancement 3: Reauthenticates the Firebase user before permanently deleting the account.
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    final currentUser =
        firebaseAuth.currentUser;

    if (currentUser == null) {
      throw Exception(
        'No Firebase user is currently signed in.',
      );
    }

    final uid =
        currentUser.uid;

    final credential =
        fb.EmailAuthProvider.credential(
      email: email.trim(),
      password: password,
    );

    await currentUser
        .reauthenticateWithCredential(
      credential,
    );

    await currentUser.delete();

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      'firebase_${uid}_firstName',
    );

    await prefs.remove(
      'firebase_${uid}_lastName',
    );

    await prefs.remove(
      'firebase_${uid}_age',
    );

    await prefs.remove(
      'firebase_${uid}_contactNo',
    );

    await prefs.remove(
      'firebase_${uid}_username',
    );

    await prefs.remove(
      'firebase_${uid}_email',
    );

    await _clearActiveSession();
  }

  // Lab Activity 5 - Enhancement 3: Reauthenticates the Firebase user using the current password before setting a new password.
  Future<void>
      resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    final currentUser =
        firebaseAuth.currentUser;

    if (currentUser == null) {
      throw Exception(
        'No Firebase user is currently signed in.',
      );
    }

    final credential =
        fb.EmailAuthProvider.credential(
      email: email.trim(),
      password: currentPassword,
    );

    await currentUser
        .reauthenticateWithCredential(
      credential,
    );

    await currentUser.updatePassword(
      newPassword,
    );
  }

  // Saves the DummyJSON user response locally through SharedPreferences.
  Future<void> saveUserData(
    Map<String, dynamic> userData,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final User user =
        User.fromJson(userData);

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

    await prefs.setInt(
      'age',
      userData['age'] ?? 0,
    );

    await prefs.setString(
      'contactNo',
      userData['phone'] ??
          userData['contactNo'] ??
          '',
    );
  }

  // Lab Activity 5 - Enhancement 3: Returns profile information based on whether the active login type is DummyJSON or Firebase.
  Future<Map<String, dynamic>>
      getUserData() async {
    final prefs =
        await SharedPreferences.getInstance();

    String loginType =
        prefs.getString('loginType') ?? '';

    final firebaseUser =
        firebaseAuth.currentUser;

    if (firebaseUser != null) {
      loginType = 'firebase';

      final uid =
          firebaseUser.uid;

      return {
        'id': 0,
        'firebaseUid': uid,
        'username':
            firebaseUser.displayName ??
                prefs.getString(
                  'firebase_${uid}_username',
                ) ??
                '',
        'email':
            firebaseUser.email ??
                prefs.getString(
                  'firebase_${uid}_email',
                ) ??
                '',
        'firstName':
            prefs.getString(
                  'firebase_${uid}_firstName',
                ) ??
                '',
        'lastName':
            prefs.getString(
                  'firebase_${uid}_lastName',
                ) ??
                '',
        'age':
            prefs.getInt(
                  'firebase_${uid}_age',
                ) ??
                0,
        'contactNo':
            prefs.getString(
                  'firebase_${uid}_contactNo',
                ) ??
                '',
        'gender': '',
        'image':
            firebaseUser.photoURL ?? '',
        'accessToken': '',
        'refreshToken': '',
        'loginType':
            loginType,
      };
    }

    return {
      'id':
          prefs.getInt('id') ?? 0,
      'firebaseUid': '',
      'username':
          prefs.getString('username') ?? '',
      'email':
          prefs.getString('email') ?? '',
      'firstName':
          prefs.getString('firstName') ?? '',
      'lastName':
          prefs.getString('lastName') ?? '',
      'age':
          prefs.getInt('age') ?? 0,
      'contactNo':
          prefs.getString('contactNo') ?? '',
      'gender':
          prefs.getString('gender') ?? '',
      'image':
          prefs.getString('image') ?? '',
      'accessToken':
          prefs.getString('accessToken') ?? '',
      'refreshToken':
          prefs.getString('refreshToken') ?? '',
      'loginType':
          loginType,
    };
  }

  // Converts locally saved DummyJSON information back into the existing User model.
  Future<User> getUser() async {
    final userData =
        await getUserData();

    return User.fromJson(
      userData,
    );
  }

  // Returns whether the active session uses DummyJSON or Firebase.
  Future<String> getLoginType() async {
    if (firebaseAuth.currentUser != null) {
      return 'firebase';
    }

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
          'loginType',
        ) ??
        '';
  }

  // Checks whether either a Firebase session or a saved DummyJSON token exists.
  Future<bool> isLoggedIn() async {
    if (firebaseAuth.currentUser != null) {
      return true;
    }

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString(
      'accessToken',
    );

    return token != null &&
        token.isNotEmpty;
  }

  // Lab Activity 5 - Enhancement 3: Logs out from either authentication type and removes the active session.
  Future<void> logout() async {
    if (firebaseAuth.currentUser != null) {
      await firebaseAuth.signOut();
    }

    await _clearActiveSession();
  }

  Future<void> _clearActiveSession() async {
    final prefs =
        await SharedPreferences.getInstance();

    const activeKeys = [
      'id',
      'firebaseUid',
      'username',
      'email',
      'firstName',
      'lastName',
      'age',
      'contactNo',
      'gender',
      'image',
      'accessToken',
      'refreshToken',
      'token',
      'loginType',
    ];

    for (final key in activeKeys) {
      await prefs.remove(key);
    }
  }
}