import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../services/user_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  final UserService _userService =
      UserService();

  bool _isLoggingOut = false;

  // Lab Activity 5 - Enhancement 3: Logs out from either Firebase or DummyJSON, clears the active session, and redirects to Sign In.
  Future<void> _logout() async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title:
              const Text(
            "Log Out",
          ),
          content:
              const Text(
            "Are you sure you want to log out?",
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
                "Log Out",
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await _userService.logout();

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

      setState(() {
        _isLoggingOut = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Unable to log out: $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final themeProvider =
        context.watch<ThemeProvider>();

    return Scaffold(
      appBar:
          AppBar(
        title:
            const Text(
          "Settings",
        ),
      ),
      body:
          ListView(
        padding:
            EdgeInsets.all(
          16.w,
        ),
        children: [
          Text(
            "Appearance",
            style:
                TextStyle(
              fontFamily:
                  "Poppins",
              fontSize:
                  16.sp,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Card(
            child:
                SwitchListTile(
              secondary:
                  Icon(
                themeProvider
                        .isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              title:
                  const Text(
                "Dark Mode",
              ),
              subtitle:
                  Text(
                themeProvider
                        .isDarkMode
                    ? "Dark theme is enabled"
                    : "Light theme is enabled",
              ),
              value:
                  themeProvider
                      .isDarkMode,
              onChanged:
                  (value) {
                themeProvider
                    .setDarkMode(
                  value,
                );
              },
            ),
          ),
          SizedBox(
            height: 25.h,
          ),
          Text(
            "Account",
            style:
                TextStyle(
              fontFamily:
                  "Poppins",
              fontSize:
                  16.sp,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Card(
            child:
                ListTile(
              leading:
                  const Icon(
                Icons.logout,
                color:
                    Colors.red,
              ),
              title:
                  const Text(
                "Log Out",
                style:
                    TextStyle(
                  color:
                      Colors.red,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
              subtitle:
                  const Text(
                "End the current authentication session",
              ),
              trailing:
                  _isLoggingOut
                      ? SizedBox(
                          width:
                              20.w,
                          height:
                              20.w,
                          child:
                              const CircularProgressIndicator(
                            strokeWidth:
                                2,
                          ),
                        )
                      : const Icon(
                          Icons.chevron_right,
                        ),
              onTap:
                  _isLoggingOut
                      ? null
                      : _logout,
            ),
          ),
        ],
      ),
    );
  }
}