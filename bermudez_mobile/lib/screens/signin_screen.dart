import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/user_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
  });

  @override
  State<SignInScreen> createState() =>
      _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController _usernameController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final UserService _userService =
      UserService();

  bool _isLoading = false;

  bool _obscurePassword = true;

  // Lab Activity 4 - Enhancement 2: Authenticates the user through UserService, saves the returned user data, and redirects to Home after a successful login.
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          await _userService.loginUser(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      // The supplied activity logic saves the authenticated user data to SharedPreferences.
      await _userService.saveUserData(
        response,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: response,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login failed: ${e.toString()}',
          ),
          backgroundColor:
              Colors.red.shade700,
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(
        0xFFF9F7FF,
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                EdgeInsets.symmetric(
              horizontal: 26.w,
              vertical: 30.h,
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,

                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/nubdexchange_logo.png",
                      height: 75.h,
                    ),
                  ),

                  SizedBox(
                    height: 25.h,
                  ),

                  Text(
                    "Welcome",

                    textAlign:
                        TextAlign.center,

                    style:
                        TextStyle(
                      fontFamily:
                          "Poppins",

                      fontSize:
                          27.sp,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          const Color(
                        0xFF001D3D,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 7.h,
                  ),

                  Text(
                    "Sign in to continue to NUBD Exchange",

                    textAlign:
                        TextAlign.center,

                    style:
                        TextStyle(
                      fontFamily:
                          "Poppins",

                      fontSize:
                          13.sp,

                      color:
                          Colors.grey.shade600,
                    ),
                  ),

                  SizedBox(
                    height: 35.h,
                  ),

                  Text(
                    "Username",

                    style:
                        TextStyle(
                      fontFamily:
                          "Poppins",

                      fontSize:
                          13.sp,

                      fontWeight:
                          FontWeight.w600,

                      color:
                          const Color(
                        0xFF001D3D,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 7.h,
                  ),

                  TextFormField(
                    controller:
                        _usernameController,

                    textInputAction:
                        TextInputAction.next,

                    decoration:
                        InputDecoration(
                      hintText:
                          "Enter username",

                      prefixIcon:
                          const Icon(
                        Icons.person_outline,
                        color:
                            Color(
                          0xFF003566,
                        ),
                      ),

                      filled: true,

                      fillColor:
                          Colors.white,

                      contentPadding:
                          EdgeInsets.symmetric(
                        horizontal:
                            16.w,
                        vertical:
                            15.h,
                      ),

                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14.r,
                        ),

                        borderSide:
                            BorderSide(
                          color: Colors
                              .grey
                              .shade300,
                        ),
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14.r,
                        ),

                        borderSide:
                            const BorderSide(
                          color:
                              Color(
                            0xFF003566,
                          ),
                          width: 1.5,
                        ),
                      ),

                      errorBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14.r,
                        ),

                        borderSide:
                            const BorderSide(
                          color:
                              Colors.red,
                        ),
                      ),

                      focusedErrorBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14.r,
                        ),

                        borderSide:
                            const BorderSide(
                          color:
                              Colors.red,
                          width: 1.5,
                        ),
                      ),
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Username is required";
                      }

                      return null;
                    },
                  ),

                  SizedBox(
                    height: 20.h,
                  ),

                  Text(
                    "Password",

                    style:
                        TextStyle(
                      fontFamily:
                          "Poppins",

                      fontSize:
                          13.sp,

                      fontWeight:
                          FontWeight.w600,

                      color:
                          const Color(
                        0xFF001D3D,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 7.h,
                  ),

                  TextFormField(
                    controller:
                        _passwordController,

                    obscureText:
                        _obscurePassword,

                    textInputAction:
                        TextInputAction.done,

                    onFieldSubmitted:
                        (_) {
                      if (!_isLoading) {
                        _login();
                      }
                    },

                    decoration:
                        InputDecoration(
                      hintText:
                          "Enter password",

                      prefixIcon:
                          const Icon(
                        Icons.lock_outline,
                        color:
                            Color(
                          0xFF003566,
                        ),
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
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,

                          color:
                              Colors.grey.shade600,
                        ),
                      ),

                      filled: true,

                      fillColor:
                          Colors.white,

                      contentPadding:
                          EdgeInsets.symmetric(
                        horizontal:
                            16.w,
                        vertical:
                            15.h,
                      ),

                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14.r,
                        ),

                        borderSide:
                            BorderSide(
                          color: Colors
                              .grey
                              .shade300,
                        ),
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14.r,
                        ),

                        borderSide:
                            const BorderSide(
                          color:
                              Color(
                            0xFF003566,
                          ),
                          width: 1.5,
                        ),
                      ),

                      errorBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14.r,
                        ),

                        borderSide:
                            const BorderSide(
                          color:
                              Colors.red,
                        ),
                      ),

                      focusedErrorBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14.r,
                        ),

                        borderSide:
                            const BorderSide(
                          color:
                              Colors.red,
                          width: 1.5,
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

                  SizedBox(
                    height: 28.h,
                  ),

                  SizedBox(
                    height: 52.h,

                    child:
                        ElevatedButton(
                      onPressed:
                          _isLoading
                              ? null
                              : _login,

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                          0xFF003566,
                        ),

                        foregroundColor:
                            Colors.white,

                        disabledBackgroundColor:
                            const Color(
                          0xFF003566,
                        ).withValues(
                          alpha: 0.6,
                        ),

                        elevation: 0,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            14.r,
                          ),
                        ),
                      ),

                      child:
                          _isLoading
                              ? SizedBox(
                                  width:
                                      23.w,
                                  height:
                                      23.w,

                                  child:
                                      const CircularProgressIndicator(
                                    strokeWidth:
                                        2.5,

                                    color:
                                        Colors.white,
                                  ),
                                )
                              : Text(
                                  "Log In",

                                  style:
                                      TextStyle(
                                    fontFamily:
                                        "Poppins",

                                    fontSize:
                                        15.sp,

                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                    ),
                  ),

                  SizedBox(
                    height: 18.h,
                  ),

                  Text(
                    "Use your NUBD Exchange account to continue.",

                    textAlign:
                        TextAlign.center,

                    style:
                        TextStyle(
                      fontFamily:
                          "Poppins",

                      fontSize:
                          11.sp,

                      color:
                          Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}