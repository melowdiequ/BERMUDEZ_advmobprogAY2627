import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/user_service.dart';
import 'cart_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  final UserService _userService =
      UserService();

  late Future<Map<String, dynamic>>
      _userData;

  @override
  void initState() {
    super.initState();

    // Lab Activity 5 - Enhancement 3: Fetches the active user data through UserService and renders information depending on LoginType.
    _userData =
        _userService.getUserData();
  }

  void _reloadProfile() {
    setState(() {
      _userData =
          _userService.getUserData();
    });
  }

  String _value(
    dynamic value,
  ) {
    if (value == null) {
      return 'Not available';
    }

    final text =
        value.toString().trim();

    if (text.isEmpty ||
        text == '0') {
      return 'Not available';
    }

    return text;
  }

  Widget _informationRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding:
          EdgeInsets.symmetric(
        vertical: 9.h,
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFF003566,
              ).withValues(
                alpha: 0.08,
              ),
              borderRadius:
                  BorderRadius.circular(
                11.r,
              ),
            ),
            child: Icon(
              icon,
              color:
                  const Color(
                0xFF003566,
              ),
              size: 21.sp,
            ),
          ),
          SizedBox(
            width: 13.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily:
                        "Poppins",
                    fontSize: 11.sp,
                    color:
                        Colors.grey.shade600,
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily:
                        "Poppins",
                    fontSize: 14.sp,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.all(
        17.w,
      ),
      margin:
          EdgeInsets.only(
        bottom: 14.h,
      ),
      decoration:
          BoxDecoration(
        color:
            Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(
          18.r,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 10,
            offset:
                const Offset(
              0,
              3,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily:
                  "Poppins",
              fontSize: 16.sp,
              fontWeight:
                  FontWeight.bold,
              color:
                  const Color(
                0xFF003566,
              ),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          ...children,
        ],
      ),
    );
  }

  Future<void> _showUpdateUsernameDialog(
    String currentUsername,
  ) async {
    final controller =
        TextEditingController(
      text: currentUsername,
    );

    final result =
        await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Update Username",
          ),
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(
              labelText:
                  "New Username",
              prefixIcon:
                  Icon(
                Icons.person_outline,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text(
                "Cancel",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  controller.text.trim(),
                );
              },
              child:
                  const Text(
                "Update",
              ),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result == null ||
        result.isEmpty) {
      return;
    }

    try {
      await _userService
          .updateUsername(
        username: result,
      );

      if (!mounted) {
        return;
      }

      _reloadProfile();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Username updated successfully.",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Unable to update username: $e",
          ),
        ),
      );
    }
  }

  Future<void> _showChangePasswordDialog(
    String email,
  ) async {
    final currentPasswordController =
        TextEditingController();

    final newPasswordController =
        TextEditingController();

    final result =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title:
              const Text(
            "Change Password",
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              TextField(
                controller:
                    currentPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Current Password",
                  prefixIcon:
                      Icon(
                    Icons.lock_outline,
                  ),
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              TextField(
                controller:
                    newPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(
                  labelText:
                      "New Password",
                  prefixIcon:
                      Icon(
                    Icons.lock_reset,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child:
                  const Text(
                "Cancel",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child:
                  const Text(
                "Change",
              ),
            ),
          ],
        );
      },
    );

    if (result != true) {
      currentPasswordController
          .dispose();
      newPasswordController.dispose();
      return;
    }

    final currentPassword =
        currentPasswordController.text;

    final newPassword =
        newPasswordController.text;

    currentPasswordController.dispose();
    newPasswordController.dispose();

    if (currentPassword.isEmpty ||
        newPassword.length < 6) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Enter your current password and a new password with at least 6 characters.",
          ),
        ),
      );

      return;
    }

    try {
      await _userService
          .resetPasswordFromCurrentPassword(
        currentPassword:
            currentPassword,
        newPassword:
            newPassword,
        email:
            email,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Password changed successfully.",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Unable to change password: $e",
          ),
        ),
      );
    }
  }

  Future<void> _showDeleteAccountDialog(
    String email,
  ) async {
    final passwordController =
        TextEditingController();

    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title:
              const Text(
            "Delete Account",
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              const Text(
                "This action permanently deletes your Firebase account. Enter your password to continue.",
              ),
              SizedBox(
                height: 15.h,
              ),
              TextField(
                controller:
                    passwordController,
                obscureText: true,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Password",
                  prefixIcon:
                      Icon(
                    Icons.lock_outline,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child:
                  const Text(
                "Cancel",
              ),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
                foregroundColor:
                    Colors.white,
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child:
                  const Text(
                "Delete",
              ),
            ),
          ],
        );
      },
    );

    final password =
        passwordController.text;

    passwordController.dispose();

    if (confirmed != true ||
        password.isEmpty) {
      return;
    }

    try {
      await _userService
          .deleteAccount(
        email: email,
        password: password,
      );

      if (!mounted) {
        return;
      }

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/signin',
        (route) => false,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Unable to delete account: $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
          "Profile",
        ),
        actions: [
          IconButton(
            tooltip:
                "Settings",
            icon:
                const Icon(
              Icons.settings,
              color:
                  Color(
                0xFFF0CB46,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) =>
                          const SettingsScreen(),
                ),
              );
            },
          ),
          SizedBox(
            width: 5.w,
          ),
        ],
      ),
      body:
          FutureBuilder<Map<String, dynamic>>(
        future:
            _userData,
        builder:
            (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(
                color:
                    Color(
                  0xFFCCA000,
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Unable to load profile: ${snapshot.error}",
                textAlign:
                    TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No user data available",
              ),
            );
          }

          final userData =
              snapshot.data!;

          final loginType =
              userData['loginType']
                  ?.toString()
                  .toLowerCase() ??
              '';

          final isFirebase =
              loginType ==
                  'firebase';

          final firstName =
              _value(
            userData['firstName'],
          );

          final lastName =
              _value(
            userData['lastName'],
          );

          final fullName =
              firstName !=
                          'Not available' ||
                      lastName !=
                          'Not available'
                  ? '${firstName == 'Not available' ? '' : firstName} ${lastName == 'Not available' ? '' : lastName}'
                      .trim()
                  : _value(
                      userData[
                          'username'],
                    );

          final username =
              _value(
            userData['username'],
          );

          final email =
              _value(
            userData['email'],
          );

          final image =
              userData['image']
                      ?.toString() ??
                  '';

          return SingleChildScrollView(
            padding:
                EdgeInsets.fromLTRB(
              18.w,
              25.h,
              18.w,
              90.h,
            ),
            child: Column(
              children: [
                Container(
                  width: 115.w,
                  height: 115.w,
                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,
                    color:
                        Colors.grey.shade200,
                    border:
                        Border.all(
                      color:
                          const Color(
                        0xFFF0CB46,
                      ),
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child:
                        image.isNotEmpty
                            ? Image.network(
                                image,
                                fit:
                                    BoxFit.cover,
                                errorBuilder:
                                    (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return Icon(
                                    Icons.person,
                                    size:
                                        60.sp,
                                    color:
                                        Colors.grey,
                                  );
                                },
                              )
                            : Icon(
                                Icons.person,
                                size:
                                    60.sp,
                                color:
                                    Colors.grey,
                              ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  fullName,
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontFamily:
                        "Poppins",
                    fontSize: 22.sp,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "@$username",
                  style: TextStyle(
                    fontFamily:
                        "Poppins",
                    fontSize: 13.sp,
                    color:
                        Colors.grey.shade600,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(
                    horizontal:
                        12.w,
                    vertical:
                        6.h,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFFF0CB46,
                    ).withValues(
                      alpha: 0.18,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      20.r,
                    ),
                  ),
                  child: Text(
                    isFirebase
                        ? "Firebase Account"
                        : "DummyJSON Account",
                    style: TextStyle(
                      fontFamily:
                          "Poppins",
                      fontSize:
                          11.sp,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          const Color(
                        0xFF001D3D,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),

                _sectionCard(
                  title:
                      "Personal Information",
                  children: [
                    _informationRow(
                      Icons.email_outlined,
                      "Email",
                      email,
                    ),
                    if (isFirebase) ...[
                      _informationRow(
                        Icons.cake_outlined,
                        "Age",
                        _value(
                          userData['age'],
                        ),
                      ),
                      _informationRow(
                        Icons.phone_outlined,
                        "Contact Number",
                        _value(
                          userData[
                              'contactNo'],
                        ),
                      ),
                    ] else ...[
                      _informationRow(
                        Icons.person_outline,
                        "Gender",
                        _value(
                          userData[
                              'gender'],
                        ),
                      ),
                    ],
                  ],
                ),

                _sectionCard(
                  title:
                      "Account Information",
                  children: [
                    _informationRow(
                      Icons.alternate_email,
                      "Username",
                      username,
                    ),
                    if (isFirebase)
                      _informationRow(
                        Icons.fingerprint,
                        "Firebase UID",
                        _value(
                          userData[
                              'firebaseUid'],
                        ),
                      )
                    else
                      _informationRow(
                        Icons.numbers,
                        "User ID",
                        _value(
                          userData['id'],
                        ),
                      ),
                    _informationRow(
                      Icons.login,
                      "Login Type",
                      isFirebase
                          ? "Firebase"
                          : "DummyJSON",
                    ),
                  ],
                ),

                if (isFirebase)
                  _sectionCard(
                    title:
                        "Account Management",
                    children: [
                      ListTile(
                        contentPadding:
                            EdgeInsets.zero,
                        leading:
                            const Icon(
                          Icons.edit_outlined,
                          color:
                              Color(
                            0xFF003566,
                          ),
                        ),
                        title:
                            const Text(
                          "Update Username",
                        ),
                        trailing:
                            const Icon(
                          Icons.chevron_right,
                        ),
                        onTap: () {
                          _showUpdateUsernameDialog(
                            username ==
                                    'Not available'
                                ? ''
                                : username,
                          );
                        },
                      ),
                      ListTile(
                        contentPadding:
                            EdgeInsets.zero,
                        leading:
                            const Icon(
                          Icons.lock_reset,
                          color:
                              Color(
                            0xFF003566,
                          ),
                        ),
                        title:
                            const Text(
                          "Change Password",
                        ),
                        trailing:
                            const Icon(
                          Icons.chevron_right,
                        ),
                        onTap: () {
                          _showChangePasswordDialog(
                            email,
                          );
                        },
                      ),
                      ListTile(
                        contentPadding:
                            EdgeInsets.zero,
                        leading:
                            const Icon(
                          Icons.delete_outline,
                          color:
                              Colors.red,
                        ),
                        title:
                            const Text(
                          "Delete Account",
                          style:
                              TextStyle(
                            color:
                                Colors.red,
                          ),
                        ),
                        trailing:
                            const Icon(
                          Icons.chevron_right,
                          color:
                              Colors.red,
                        ),
                        onTap: () {
                          _showDeleteAccountDialog(
                            email,
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),

      // Lab Activity 3 - Enhancement 2: Chat remains visible on Profile and hidden only on Cart.
      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            const Color(
          0xFFF0CB46,
        ),
        foregroundColor:
            const Color(
          0xFF001D3D,
        ),
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            const SnackBar(
              content:
                  Text(
                "Chat selected",
              ),
            ),
          );
        },
        child:
            const Icon(
          Icons.chat,
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: 2,
        type:
            BottomNavigationBarType.fixed,
        selectedItemColor:
            const Color(
          0xFFCCA000,
        ),
        unselectedItemColor:
            Colors.grey,
        items:
            const [
          BottomNavigationBarItem(
            icon:
                Icon(
              Icons.home,
            ),
            label:
                "Home",
          ),
          BottomNavigationBarItem(
            icon:
                Icon(
              Icons.shopping_cart,
            ),
            label:
                "Cart",
          ),
          BottomNavigationBarItem(
            icon:
                Icon(
              Icons.person,
            ),
            label:
                "Profile",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(
              context,
              '/home',
            );
          }

          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (_) =>
                        const CartScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}