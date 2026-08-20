import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {
  final UserService _userService =
      UserService();

  @override
  void initState() {
    super.initState();

    _checkAuthentication();
  }

  // Lab Activity 4 - Enhancement 1: Checks persistent authentication and redirects the user based on the saved login state.
  Future<void> _checkAuthentication() async {
    await Future.delayed(
      const Duration(
        milliseconds: 1500,
      ),
    );

    final loggedIn =
        await _userService.isLoggedIn();

    if (!mounted) {
      return;
    }

    if (loggedIn) {
      final userData =
          await _userService.getUserData();

      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: userData,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/signin',
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF9F7FF),

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              Container(
                width: 125.w,
                height: 125.w,

                padding:
                    EdgeInsets.all(
                  18.w,
                ),

                decoration:
                    BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    28.r,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(
                        alpha: 0.08,
                      ),

                      blurRadius: 20,

                      offset:
                          const Offset(
                        0,
                        6,
                      ),
                    ),
                  ],
                ),

                child: Image.asset(
                  "assets/images/nubdexchange_logo.png",

                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(
                height: 28.h,
              ),

              Text(
                "NUBD Exchange",

                style: TextStyle(
                  fontFamily: "Poppins",

                  fontSize: 24.sp,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      const Color(
                    0xFF001D3D,
                  ),
                ),
              ),

              SizedBox(
                height: 8.h,
              ),

              Text(
                "Your marketplace, made simple.",

                style: TextStyle(
                  fontFamily: "Poppins",

                  fontSize: 13.sp,

                  color:
                      Colors.grey.shade600,
                ),
              ),

              SizedBox(
                height: 35.h,
              ),

              SizedBox(
                width: 30.w,
                height: 30.w,

                child:
                    const CircularProgressIndicator(
                  strokeWidth: 3,

                  color:
                      Color(
                    0xFFF0CB46,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}