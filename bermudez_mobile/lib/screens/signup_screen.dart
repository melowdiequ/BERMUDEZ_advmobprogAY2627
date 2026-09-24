import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/user_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController _firstNameController =
      TextEditingController();

  final TextEditingController _lastNameController =
      TextEditingController();

  final TextEditingController _ageController =
      TextEditingController();

  final TextEditingController _contactController =
      TextEditingController();

  final TextEditingController _usernameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final UserService _userService =
      UserService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  // Lab Activity 5 - Enhancement 2: Validates the signup form and creates a Firebase Authentication account.
  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _userService.createAccount(
        firstName:
            _firstNameController.text.trim(),
        lastName:
            _lastNameController.text.trim(),
        age:
            int.parse(
          _ageController.text.trim(),
        ),
        contactNo:
            _contactController.text.trim(),
        username:
            _usernameController.text.trim(),
        email:
            _emailController.text.trim(),
        password:
            _passwordController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Firebase account created successfully.",
          ),
        ),
      );

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
          "Unable to create account.";

      if (e.code ==
          'email-already-in-use') {
        message =
            "This email address is already registered.";
      } else if (e.code ==
          'invalid-email') {
        message =
            "Please enter a valid email address.";
      } else if (e.code ==
          'weak-password') {
        message =
            "The password is too weak.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
        ),
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
            "Account creation failed: $e",
          ),
        ),
      );
    }
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

  Widget _fieldLabel(
    String text,
  ) {
    return Padding(
      padding:
          EdgeInsets.only(
        bottom: 7.h,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 13.sp,
          fontWeight:
              FontWeight.w600,
          color: const Color(
            0xFF001D3D,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _contactController.dispose();
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
      appBar: AppBar(
        title: const Text(
          "Create Account",
        ),
      ),
      body: SafeArea(
        child:
            SingleChildScrollView(
          padding:
              EdgeInsets.fromLTRB(
            25.w,
            25.h,
            25.w,
            35.h,
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
                    height: 70.h,
                  ),
                ),

                SizedBox(
                  height: 18.h,
                ),

                Text(
                  "Create your account",
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontFamily:
                        "Poppins",
                    fontSize: 23.sp,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        const Color(
                      0xFF001D3D,
                    ),
                  ),
                ),

                SizedBox(
                  height: 5.h,
                ),

                Text(
                  "Register using Firebase Authentication",
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
                  height: 28.h,
                ),

                _fieldLabel(
                  "First Name",
                ),

                TextFormField(
                  controller:
                      _firstNameController,
                  textInputAction:
                      TextInputAction.next,
                  decoration:
                      _inputDecoration(
                    hint:
                        "Enter first name",
                    icon:
                        Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "First name is required";
                    }

                    return null;
                  },
                ),

                SizedBox(
                  height: 17.h,
                ),

                _fieldLabel(
                  "Last Name",
                ),

                TextFormField(
                  controller:
                      _lastNameController,
                  textInputAction:
                      TextInputAction.next,
                  decoration:
                      _inputDecoration(
                    hint:
                        "Enter last name",
                    icon:
                        Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Last name is required";
                    }

                    return null;
                  },
                ),

                SizedBox(
                  height: 17.h,
                ),

                _fieldLabel(
                  "Age",
                ),

                TextFormField(
                  controller:
                      _ageController,
                  keyboardType:
                      TextInputType.number,
                  textInputAction:
                      TextInputAction.next,
                  decoration:
                      _inputDecoration(
                    hint: "Enter age",
                    icon:
                        Icons.cake_outlined,
                  ),
                  validator: (value) {
                    final age =
                        int.tryParse(
                      value?.trim() ?? '',
                    );

                    if (age == null ||
                        age <= 0) {
                      return "Enter a valid age";
                    }

                    return null;
                  },
                ),

                SizedBox(
                  height: 17.h,
                ),

                _fieldLabel(
                  "Contact Number",
                ),

                TextFormField(
                  controller:
                      _contactController,
                  keyboardType:
                      TextInputType.phone,
                  textInputAction:
                      TextInputAction.next,
                  decoration:
                      _inputDecoration(
                    hint:
                        "Enter contact number",
                    icon:
                        Icons.phone_outlined,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Contact number is required";
                    }

                    return null;
                  },
                ),

                SizedBox(
                  height: 17.h,
                ),

                _fieldLabel(
                  "Username",
                ),

                TextFormField(
                  controller:
                      _usernameController,
                  textInputAction:
                      TextInputAction.next,
                  decoration:
                      _inputDecoration(
                    hint:
                        "Enter username",
                    icon:
                        Icons.alternate_email,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Username is required";
                    }

                    if (value.trim().length <
                        3) {
                      return "Username must contain at least 3 characters";
                    }

                    return null;
                  },
                ),

                SizedBox(
                  height: 17.h,
                ),

                _fieldLabel(
                  "Email Address",
                ),

                TextFormField(
                  controller:
                      _emailController,
                  keyboardType:
                      TextInputType
                          .emailAddress,
                  textInputAction:
                      TextInputAction.next,
                  decoration:
                      _inputDecoration(
                    hint:
                        "Enter email address",
                    icon:
                        Icons.email_outlined,
                  ),
                  validator: (value) {
                    final email =
                        value?.trim() ?? '';

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
                ),

                SizedBox(
                  height: 17.h,
                ),

                _fieldLabel(
                  "Password",
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
                      _createAccount();
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
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return "Password is required";
                    }

                    if (value.length < 6) {
                      return "Password must contain at least 6 characters";
                    }

                    return null;
                  },
                ),

                SizedBox(
                  height: 27.h,
                ),

                SizedBox(
                  height: 52.h,
                  child:
                      ElevatedButton(
                    onPressed:
                        _isLoading
                            ? null
                            : _createAccount,
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
                                width: 23.w,
                                height: 23.w,
                                child:
                                    const CircularProgressIndicator(
                                  strokeWidth:
                                      2.5,
                                  color:
                                      Colors.white,
                                ),
                              )
                            : Text(
                                "Create Account",
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
                  height: 12.h,
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text(
                    "Already have an account? Sign In",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}