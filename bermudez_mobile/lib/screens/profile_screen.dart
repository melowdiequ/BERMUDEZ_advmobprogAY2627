import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/user_service.dart';
import 'cart_screen.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();

  late Future<Map<String, dynamic>> _userData;

  @override
  void initState() {
    super.initState();

    // Lab Activity 5 - Enhancement 3: Fetches the active user data through UserService and renders information depending on LoginType.
    _userData = _userService.getUserData();
  }

  void _reloadProfile() {
    if (!mounted) {
      return;
    }

    setState(() {
      _userData = _userService.getUserData();
    });
  }

  String _value(dynamic value) {
    if (value == null) {
      return 'Not available';
    }

    final text = value.toString().trim();

    if (text.isEmpty || text == '0') {
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
      padding: EdgeInsets.symmetric(
        vertical: 9.h,
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: const Color(
                0xFF003566,
              ).withValues(
                alpha: 0.08,
              ),
              borderRadius: BorderRadius.circular(
                11.r,
              ),
            ),
            child: Icon(
              icon,
              color: const Color(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 11.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
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
      padding: EdgeInsets.all(
        17.w,
      ),
      margin: EdgeInsets.only(
        bottom: 14.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(
          18.r,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 10,
            offset: const Offset(
              0,
              3,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(
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

  // Lab Activity 5 - Enhancement 3: Opens a lifecycle-safe dialog for updating the Firebase username.
  Future<void> _showUpdateUsernameDialog(
    String currentUsername,
  ) async {
    final newUsername = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _UpdateUsernameDialog(
          currentUsername: currentUsername,
        );
      },
    );

    if (newUsername == null ||
        newUsername.trim().isEmpty) {
      return;
    }

    try {
      await _userService.updateUsername(
        username: newUsername.trim(),
      );

      if (!mounted) {
        return;
      }

      _reloadProfile();

      ScaffoldMessenger.of(context).showSnackBar(
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Unable to update username: $e",
          ),
        ),
      );
    }
  }

  // Lab Activity 5 - Enhancement 3: Opens a lifecycle-safe password dialog and reauthenticates the Firebase user before changing the password.
  Future<void> _showChangePasswordDialog(
    String email,
  ) async {
    final passwordData =
        await showDialog<_PasswordChangeData>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return const _ChangePasswordDialog();
      },
    );

    if (passwordData == null) {
      return;
    }

    try {
      await _userService.resetPasswordFromCurrentPassword(
        currentPassword: passwordData.currentPassword,
        newPassword: passwordData.newPassword,
        email: email,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Unable to change password: $e",
          ),
        ),
      );
    }
  }

  // Lab Activity 5 - Enhancement 3: Requests the current password before permanently deleting the Firebase account.
  Future<void> _showDeleteAccountDialog(
    String email,
  ) async {
    final password = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return const _DeleteAccountDialog();
      },
    );

    if (password == null || password.isEmpty) {
      return;
    }

    try {
      await _userService.deleteAccount(
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

      ScaffoldMessenger.of(context).showSnackBar(
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
        title: const Text(
          "Profile",
        ),
        actions: [
          IconButton(
            tooltip: "Settings",
            icon: const Icon(
              Icons.settings,
              color: Color(
                0xFFF0CB46,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
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

      body: FutureBuilder<Map<String, dynamic>>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(
                  0xFFCCA000,
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(
                  20.w,
                ),
                child: Text(
                  "Unable to load profile:\n${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
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

          final userData = snapshot.data!;

          final loginType =
              userData['loginType']
                      ?.toString()
                      .toLowerCase() ??
                  '';

          final isFirebase =
              loginType == 'firebase';

          final firstName = _value(
            userData['firstName'],
          );

          final lastName = _value(
            userData['lastName'],
          );

          String fullName;

          if (firstName != 'Not available' ||
              lastName != 'Not available') {
            final first =
                firstName == 'Not available'
                    ? ''
                    : firstName;

            final last =
                lastName == 'Not available'
                    ? ''
                    : lastName;

            fullName =
                '$first $last'.trim();
          } else {
            fullName = _value(
              userData['username'],
            );
          }

          final username = _value(
            userData['username'],
          );

          final email = _value(
            userData['email'],
          );

          final image =
              userData['image']?.toString() ?? '';

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: const Color(
                        0xFFF0CB46,
                      ),
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: image.isNotEmpty
                        ? Image.network(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return Icon(
                                Icons.person,
                                size: 60.sp,
                                color: Colors.grey,
                              );
                            },
                          )
                        : Icon(
                            Icons.person,
                            size: 60.sp,
                            color: Colors.grey,
                          ),
                  ),
                ),

                SizedBox(
                  height: 16.h,
                ),

                Text(
                  fullName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 3.h,
                ),

                Text(
                  "@$username",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 13.sp,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(
                  height: 8.h,
                ),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFF0CB46,
                    ).withValues(
                      alpha: 0.18,
                    ),
                    borderRadius: BorderRadius.circular(
                      20.r,
                    ),
                  ),
                  child: Text(
                    isFirebase
                        ? "Firebase Account"
                        : "DummyJSON Account",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(
                        0xFF001D3D,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 25.h,
                ),

                _sectionCard(
                  title: "Personal Information",
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
                          userData['contactNo'],
                        ),
                      ),
                    ] else ...[
                      _informationRow(
                        Icons.person_outline,
                        "Gender",
                        _value(
                          userData['gender'],
                        ),
                      ),
                    ],
                  ],
                ),

                _sectionCard(
                  title: "Account Information",
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
                          userData['firebaseUid'],
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
                    title: "Account Management",
                    children: [
                      ListTile(
                        contentPadding:
                            EdgeInsets.zero,
                        leading: const Icon(
                          Icons.edit_outlined,
                          color: Color(
                            0xFF003566,
                          ),
                        ),
                        title: const Text(
                          "Update Username",
                        ),
                        trailing: const Icon(
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
                        leading: const Icon(
                          Icons.lock_reset,
                          color: Color(
                            0xFF003566,
                          ),
                        ),
                        title: const Text(
                          "Change Password",
                        ),
                        trailing: const Icon(
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
                        leading: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        title: const Text(
                          "Delete Account",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.red,
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

      // Lab Activity 6: Redirects the Chat FloatingActionButton to the Firestore Chat List UI.
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
        tooltip: "Chat",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const ChatScreen(),
            ),
          );
        },
        child: const Icon(
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
            ),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: "Profile",
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
                builder: (_) =>
                    const CartScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}

// Owns its TextEditingController for the entire lifetime of the username dialog.
class _UpdateUsernameDialog
    extends StatefulWidget {
  final String currentUsername;

  const _UpdateUsernameDialog({
    required this.currentUsername,
  });

  @override
  State<_UpdateUsernameDialog>
      createState() =>
          _UpdateUsernameDialogState();
}

class _UpdateUsernameDialogState
    extends State<_UpdateUsernameDialog> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  late final TextEditingController
      _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        TextEditingController(
      text: widget.currentUsername,
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      title: const Text(
        "Update Username",
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          decoration:
              const InputDecoration(
            labelText:
                "New Username",
            prefixIcon:
                Icon(
              Icons.person_outline,
            ),
          ),
          validator: (value) {
            final username =
                value?.trim() ?? '';

            if (username.isEmpty) {
              return "Username is required";
            }

            if (username.length < 3) {
              return "Use at least 3 characters";
            }

            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Cancel",
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!
                .validate()) {
              return;
            }

            Navigator.of(context).pop(
              _controller.text.trim(),
            );
          },
          child: const Text(
            "Update",
          ),
        ),
      ],
    );
  }
}

class _PasswordChangeData {
  final String currentPassword;
  final String newPassword;

  const _PasswordChangeData({
    required this.currentPassword,
    required this.newPassword,
  });
}

// Owns all password controllers until the password dialog is completely removed from the widget tree.
class _ChangePasswordDialog
    extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog>
      createState() =>
          _ChangePasswordDialogState();
}

class _ChangePasswordDialogState
    extends State<_ChangePasswordDialog> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController
      _currentPasswordController =
      TextEditingController();

  final TextEditingController
      _newPasswordController =
      TextEditingController();

  final TextEditingController
      _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      title: const Text(
        "Change Password",
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              TextFormField(
                controller:
                    _currentPasswordController,
                obscureText:
                    _obscureCurrent,
                decoration:
                    InputDecoration(
                  labelText:
                      "Current Password",
                  prefixIcon:
                      const Icon(
                    Icons.lock_outline,
                  ),
                  suffixIcon:
                      IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureCurrent =
                            !_obscureCurrent;
                      });
                    },
                    icon: Icon(
                      _obscureCurrent
                          ? Icons
                              .visibility_off_outlined
                          : Icons
                              .visibility_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return "Current password is required";
                  }

                  return null;
                },
              ),

              SizedBox(
                height: 14.h,
              ),

              TextFormField(
                controller:
                    _newPasswordController,
                obscureText:
                    _obscureNew,
                decoration:
                    InputDecoration(
                  labelText:
                      "New Password",
                  prefixIcon:
                      const Icon(
                    Icons.lock_reset,
                  ),
                  suffixIcon:
                      IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureNew =
                            !_obscureNew;
                      });
                    },
                    icon: Icon(
                      _obscureNew
                          ? Icons
                              .visibility_off_outlined
                          : Icons
                              .visibility_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.length < 6) {
                    return "Use at least 6 characters";
                  }

                  return null;
                },
              ),

              SizedBox(
                height: 14.h,
              ),

              TextFormField(
                controller:
                    _confirmPasswordController,
                obscureText:
                    _obscureConfirm,
                decoration:
                    InputDecoration(
                  labelText:
                      "Confirm New Password",
                  prefixIcon:
                      const Icon(
                    Icons.lock_outline,
                  ),
                  suffixIcon:
                      IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirm =
                            !_obscureConfirm;
                      });
                    },
                    icon: Icon(
                      _obscureConfirm
                          ? Icons
                              .visibility_off_outlined
                          : Icons
                              .visibility_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value !=
                      _newPasswordController
                          .text) {
                    return "Passwords do not match";
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Cancel",
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!
                .validate()) {
              return;
            }

            Navigator.of(context).pop(
              _PasswordChangeData(
                currentPassword:
                    _currentPasswordController
                        .text,
                newPassword:
                    _newPasswordController
                        .text,
              ),
            );
          },
          child: const Text(
            "Change",
          ),
        ),
      ],
    );
  }
}

// Owns its password controller until the delete confirmation dialog is fully disposed.
class _DeleteAccountDialog
    extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<_DeleteAccountDialog>
      createState() =>
          _DeleteAccountDialogState();
}

class _DeleteAccountDialogState
    extends State<_DeleteAccountDialog> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController
      _passwordController =
      TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      title: const Text(
        "Delete Account",
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Text(
              "This action permanently deletes your Firebase account. Enter your password to continue.",
            ),

            SizedBox(
              height: 15.h,
            ),

            TextFormField(
              controller:
                  _passwordController,
              obscureText:
                  _obscurePassword,
              decoration:
                  InputDecoration(
                labelText:
                    "Password",
                prefixIcon:
                    const Icon(
                  Icons.lock_outline,
                ),
                suffixIcon:
                    IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword =
                          !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons
                            .visibility_off_outlined
                        : Icons
                            .visibility_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return "Password is required";
                }

                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
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
            if (!_formKey.currentState!
                .validate()) {
              return;
            }

            Navigator.of(context).pop(
              _passwordController.text,
            );
          },
          child: const Text(
            "Delete",
          ),
        ),
      ],
    );
  }
}