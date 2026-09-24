import 'package:firebase_auth/firebase_auth.dart';
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

class _SignInScreenState
    extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController
      _usernameController =
      TextEditingController();

  final TextEditingController
      _emailController =
      TextEditingController();

  final TextEditingController
      _passwordController =
      TextEditingController();

  final UserService _userService =
      UserService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _useFirebase = false;

  // Lab Activity 5 - Enhancement 2: Signs in using either DummyJSON or Firebase Authentication depending on the selected login type.
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_useFirebase) {
        await _userService.signIn(
          email:
              _emailController.text.trim(),
          password:
              _passwordController.text,
        );
      } else {
        await _userService.loginUser(
          _usernameController.text.trim(),
          _passwordController.text,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      String message =
          'Firebase login failed.';

      if (e.code ==
              'invalid-credential' ||
          e.code ==
              'wrong-password' ||
          e.code ==
              'user-not-found') {
        message =
            'Incorrect email or password.';
      } else if (e.code ==
          'invalid-email') {
        message =
            'Please enter a valid email address.';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              Colors.red.shade700,
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
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

  Widget _loginTypeButton({
    required String title,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: SizedBox(
        height: 44.h,
        child: selected
            ? ElevatedButton(
                onPressed: onPressed,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF003566,
                  ),
                  foregroundColor:
                      Colors.white,
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      11.r,
                    ),
                  ),
                ),
                child: Text(title),
              )
            : OutlinedButton(
                onPressed: onPressed,
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      const Color(
                    0xFF003566,
                  ),
                  side:
                      const BorderSide(
                    color: Color(
                      0xFF003566,
                    ),
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      11.r,
                    ),
                  ),
                ),
                child: Text(title),
              ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: const Color(
          0xFF003566,
        ),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 15.h,
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          14.r,
        ),
        borderSide:
            BorderSide(
          color: Colors.grey.shade300,
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
          color: Color(
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
          color: Colors.red,
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
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
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
          child:
              SingleChildScrollView(
            padding:
                EdgeInsets.symmetric(
              horizontal: 26.w,
              vertical: 30.h,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/nubdexchange_logo.png",
                      height: 75.h,
                    ),
                  ),

                  SizedBox(
                    height: 20.h,
                  ),

                  Text(
                    "Welcome",
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      fontFamily:
                          "Poppins",
                      fontSize: 27.sp,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          const Color(
                        0xFF001D3D,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 6.h,
                  ),

                  Text(
                    "Choose how you want to sign in",
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      fontFamily:
                          "Poppins",
                      fontSize: 12.sp,
                      color:
                          Colors.grey.shade600,
                    ),
                  ),

                  SizedBox(
                    height: 25.h,
                  ),

                  Row(
                    children: [
                      _loginTypeButton(
                        title:
                            "DummyJSON",
                        selected:
                            !_useFirebase,
                        onPressed: () {
                          setState(() {
                            _useFirebase =
                                false;
                          });
                        },
                      ),

                      SizedBox(
                        width: 10.w,
                      ),

                      _loginTypeButton(
                        title:
                            "Firebase",
                        selected:
                            _useFirebase,
                        onPressed: () {
                          setState(() {
                            _useFirebase =
                                true;
                          });
                        },
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 25.h,
                  ),

                  Text(
                    _useFirebase
                        ? "Email Address"
                        : "Username",
                    style: TextStyle(
                      fontFamily:
                          "Poppins",
                      fontSize: 13.sp,
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

                  if (_useFirebase)
                    TextFormField(
                      controller:
                          _emailController,
                      keyboardType:
                          TextInputType
                              .emailAddress,
                      textInputAction:
                          TextInputAction
                              .next,
                      decoration:
                          _inputDecoration(
                        hint:
                            "Enter email address",
                        icon:
                            Icons.email_outlined,
                      ),
                      validator: (value) {
                        final email =
                            value?.trim() ??
                                '';

                        if (email.isEmpty) {
                          return "Email address is required";
                        }

                        if (!email.contains(
                          '@',
                        )) {
                          return "Enter a valid email address";
                        }

                        return null;
                      },
                    )
                  else
                    TextFormField(
                      controller:
                          _usernameController,
                      textInputAction:
                          TextInputAction
                              .next,
                      decoration:
                          _inputDecoration(
                        hint:
                            "Enter username",
                        icon:
                            Icons.person_outline,
                      ),
                      validator: (value) {
                        if (value == null ||
                            value
                                .trim()
                                .isEmpty) {
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
                    style: TextStyle(
                      fontFamily:
                          "Poppins",
                      fontSize: 13.sp,
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
                    onFieldSubmitted: (_) {
                      if (!_isLoading) {
                        _login();
                      }
                    },
                    decoration:
                        _inputDecoration(
                      hint:
                          "Enter password",
                      icon:
                          Icons.lock_outline,
                    ).copyWith(
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
                                  _useFirebase
                                      ? "Sign In with Firebase"
                                      : "Sign In with DummyJSON",
                                  style:
                                      TextStyle(
                                    fontFamily:
                                        "Poppins",
                                    fontSize:
                                        14.sp,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                    ),
                  ),

                  SizedBox(
                    height: 16.h,
                  ),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontFamily:
                              "Poppins",
                          fontSize:
                              12.sp,
                          color: Colors
                              .grey
                              .shade700,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/signup',
                          );
                        },
                        child: const Text(
                          "Create Account",
                        ),
                      ),
                    ],
                  ),

                  Text(
                    "Account registration uses Firebase Authentication.",
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      fontFamily:
                          "Poppins",
                      fontSize: 10.sp,
                      color:
                          Colors.grey.shade500,
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