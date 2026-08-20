import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/user.dart';
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

  Future<User>? user;

  @override
  void initState() {
    super.initState();

    // Lab Activity 4 - Enhancement 3: Loads the saved authenticated User model and renders its data on the Profile screen.
    user = _userService.getUser();
  }

  Widget informationRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding:
          EdgeInsets.symmetric(
        vertical: 10.h,
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
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily:
                        "Poppins",
                    fontSize: 11.sp,
                    color: Colors
                        .grey
                        .shade600,
                  ),
                ),

                SizedBox(
                  height: 2.h,
                ),

                Text(
                  value.isEmpty
                      ? "Not available"
                      : value,

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

  Widget sectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width:
          double.infinity,

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
            Theme.of(context)
                .cardColor,

        borderRadius:
            BorderRadius.circular(
          18.r,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withValues(
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
            CrossAxisAlignment
                .start,

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

  Future<void> logout() async {
    await _userService.logout();

    if (!mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/signin',
      (route) => false,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color(
          0xFF001D3D,
        ),

        title: const Text(
          "Profile",
        ),

        actions: [
          IconButton(
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

      body: FutureBuilder<User>(
        future: user,

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
                "Unable to load profile",
                style: TextStyle(
                  fontFamily:
                      "Poppins",
                  fontSize: 15.sp,
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

          final User currentUser =
              snapshot.data!;

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
                        Colors.grey
                            .shade200,

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
                        currentUser
                                .image
                                .isEmpty
                            ? Icon(
                                Icons.person,
                                size: 60.sp,
                                color:
                                    Colors.grey,
                              )
                            : Image.network(
                                currentUser
                                    .image,
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
                              ),
                  ),
                ),

                SizedBox(
                  height: 16.h,
                ),

                Text(
                  currentUser.fullName,

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
                  "@${currentUser.username}",

                  style: TextStyle(
                    fontFamily:
                        "Poppins",
                    fontSize: 13.sp,
                    color: Colors
                        .grey
                        .shade600,
                  ),
                ),

                SizedBox(
                  height: 25.h,
                ),

                sectionCard(
                  title:
                      "Personal Information",

                  children: [
                    informationRow(
                      Icons.email_outlined,
                      "Email",
                      currentUser.email,
                    ),

                    informationRow(
                      Icons.person_outline,
                      "Gender",
                      currentUser.gender,
                    ),

                    informationRow(
                      Icons.badge_outlined,
                      "Full Name",
                      currentUser.fullName,
                    ),
                  ],
                ),

                sectionCard(
                  title:
                      "Account Information",

                  children: [
                    informationRow(
                      Icons.alternate_email,
                      "Username",
                      currentUser.username,
                    ),

                    informationRow(
                      Icons.numbers,
                      "User ID",
                      currentUser.id
                          .toString(),
                    ),
                  ],
                ),

                SizedBox(
                  height: 5.h,
                ),

                SizedBox(
                  width:
                      double.infinity,

                  child:
                      OutlinedButton.icon(
                    style:
                        OutlinedButton
                            .styleFrom(
                      foregroundColor:
                          Colors.red
                              .shade700,

                      side:
                          BorderSide(
                        color:
                            Colors.red
                                .shade300,
                      ),

                      padding:
                          EdgeInsets
                              .symmetric(
                        vertical:
                            14.h,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          13.r,
                        ),
                      ),
                    ),

                    onPressed: logout,

                    icon:
                        const Icon(
                      Icons.logout,
                    ),

                    label:
                        const Text(
                      "Log Out",
                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

      // Lab Activity 3 - Enhancement 2: The Chat FloatingActionButton remains visible on Profile because the requirement only hides it on CartScreen.
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

        elevation: 5,

        tooltip: "Chat",

        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            const SnackBar(
              content: Text(
                "Chat selected",
              ),
            ),
          );
        },

        child: const Icon(
          Icons.chat,
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation
              .endFloat,

      // Lab Activity 4 - Enhancement 3: Profile is the selected bottom-navigation destination.
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