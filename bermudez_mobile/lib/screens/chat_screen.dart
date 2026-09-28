import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/chat_service.dart';
import 'chat_detailscreen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends State<ChatScreen> {
  final ChatService _chatService =
      ChatService();

  final FirebaseAuth _firebaseAuth =
      FirebaseAuth.instance;

  final TextEditingController
      _searchController =
      TextEditingController();

  String _searchQuery = '';

  // Lab Activity 6 - Enhancement 1: Opens a conversation with the selected registered Firestore user.
  void _openChat(
    Map<String, dynamic> user,
  ) {
    final currentUser =
        _firebaseAuth.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Firebase login is required to use chat.",
          ),
        ),
      );

      return;
    }

    final receiverId =
        user['uid']?.toString() ?? '';

    if (receiverId.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to open this user.",
          ),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ChatDetailScreen(
          receiverUser: user,
        ),
      ),
    );
  }

  String _displayName(
    Map<String, dynamic> user,
  ) {
    final firstName =
        user['firstName']
                ?.toString()
                .trim() ??
            '';

    final lastName =
        user['lastName']
                ?.toString()
                .trim() ??
            '';

    final fullName =
        '$firstName $lastName'.trim();

    if (fullName.isNotEmpty) {
      return fullName;
    }

    final username =
        user['username']
                ?.toString()
                .trim() ??
            '';

    if (username.isNotEmpty) {
      return username;
    }

    return 'Unknown User';
  }

  // Lab Activity 6 - Enhancement 2: Filters registered users by name or email based on the current search text.
  bool _matchesSearch(
    Map<String, dynamic> user,
  ) {
    if (_searchQuery.isEmpty) {
      return true;
    }

    final name =
        _displayName(user)
            .toLowerCase();

    final email =
        user['email']
                ?.toString()
                .toLowerCase()
                .trim() ??
            '';

    final query =
        _searchQuery.toLowerCase();

    return name.contains(query) ||
        email.contains(query);
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final currentUser =
        _firebaseAuth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chats",
        ),
      ),

      body: currentUser == null
          ? Center(
              child: Padding(
                padding:
                    EdgeInsets.all(
                  24.w,
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                  children: [
                    Icon(
                      Icons
                          .chat_bubble_outline,
                      size: 60.sp,
                      color:
                          Colors.grey,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      "Firebase login is required to use the chat feature.",
                      textAlign:
                          TextAlign.center,
                      style:
                          TextStyle(
                        fontFamily:
                            "Poppins",
                        fontSize:
                            15.sp,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // Lab Activity 6 - Enhancement 2: Search bar for locating other users by name or email.
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(
                    15.w,
                    15.h,
                    15.w,
                    8.h,
                  ),
                  child: TextField(
                    controller:
                        _searchController,
                    textInputAction:
                        TextInputAction.search,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery =
                            value.trim();
                      });
                    },
                    decoration:
                        InputDecoration(
                      hintText:
                          "Search by name or email",
                      prefixIcon:
                          const Icon(
                        Icons.search,
                        color: Color(
                          0xFF003566,
                        ),
                      ),
                      suffixIcon:
                          _searchQuery
                                  .isNotEmpty
                              ? IconButton(
                                  tooltip:
                                      "Clear",
                                  onPressed:
                                      () {
                                    _searchController
                                        .clear();

                                    setState(() {
                                      _searchQuery =
                                          '';
                                    });
                                  },
                                  icon:
                                      const Icon(
                                    Icons.close,
                                  ),
                                )
                              : null,
                      filled: true,
                      fillColor:
                          Theme.of(context)
                              .cardColor,
                      contentPadding:
                          EdgeInsets
                              .symmetric(
                        horizontal:
                            15.w,
                        vertical:
                            12.h,
                      ),
                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          15.r,
                        ),
                        borderSide:
                            BorderSide(
                          color:
                              Colors.grey
                                  .shade300,
                        ),
                      ),
                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          15.r,
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
                    ),
                  ),
                ),

                Expanded(
                  child: StreamBuilder<
                      List<
                          Map<String,
                              dynamic>>>(
                    stream:
                        _chatService
                            .getUsersStream(),
                    builder:
                        (context, snapshot) {
                      if (snapshot
                              .connectionState ==
                          ConnectionState
                              .waiting) {
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
                          child: Padding(
                            padding:
                                EdgeInsets.all(
                              20.w,
                            ),
                            child: Text(
                              "Error loading users:\n${snapshot.error}",
                              textAlign:
                                  TextAlign
                                      .center,
                            ),
                          ),
                        );
                      }

                      final allUsers =
                          snapshot.data ??
                              [];

                      // Lab Activity 6 - Enhancement 1: Excludes the currently logged-in Firebase user.
                      final otherUsers =
                          allUsers.where(
                        (user) {
                          final userId =
                              user['uid']
                                      ?.toString() ??
                                  '';

                          return userId !=
                              currentUser.uid;
                        },
                      ).toList();

                      // Lab Activity 6 - Enhancement 2: Applies the search filter after the current user has been excluded.
                      final filteredUsers =
                          otherUsers
                              .where(
                                _matchesSearch,
                              )
                              .toList();

                      if (otherUsers.isEmpty) {
                        return Center(
                          child: Padding(
                            padding:
                                EdgeInsets.all(
                              24.w,
                            ),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                              children: [
                                Icon(
                                  Icons
                                      .people_outline,
                                  size:
                                      55.sp,
                                  color:
                                      Colors.grey,
                                ),
                                SizedBox(
                                  height:
                                      12.h,
                                ),
                                Text(
                                  "No other registered users found.",
                                  textAlign:
                                      TextAlign
                                          .center,
                                  style:
                                      TextStyle(
                                    fontFamily:
                                        "Poppins",
                                    fontSize:
                                        15.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (filteredUsers
                          .isEmpty) {
                        return Center(
                          child: Padding(
                            padding:
                                EdgeInsets.all(
                              24.w,
                            ),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                              children: [
                                Icon(
                                  Icons
                                      .search_off,
                                  size:
                                      55.sp,
                                  color:
                                      Colors.grey,
                                ),
                                SizedBox(
                                  height:
                                      12.h,
                                ),
                                Text(
                                  "No users found for \"$_searchQuery\".",
                                  textAlign:
                                      TextAlign
                                          .center,
                                  style:
                                      TextStyle(
                                    fontFamily:
                                        "Poppins",
                                    fontSize:
                                        15.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView
                          .separated(
                        padding:
                            EdgeInsets
                                .fromLTRB(
                          15.w,
                          6.h,
                          15.w,
                          15.h,
                        ),
                        itemCount:
                            filteredUsers
                                .length,
                        separatorBuilder:
                            (
                          context,
                          index,
                        ) {
                          return SizedBox(
                            height:
                                7.h,
                          );
                        },
                        itemBuilder:
                            (
                          context,
                          index,
                        ) {
                          final user =
                              filteredUsers[
                                  index];

                          final name =
                              _displayName(
                            user,
                          );

                          final email =
                              user['email']
                                      ?.toString() ??
                                  '';

                          final username =
                              user['username']
                                      ?.toString()
                                      .trim() ??
                                  '';

                          return Card(
                            margin:
                                EdgeInsets
                                    .zero,
                            elevation: 1,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14.r,
                              ),
                            ),
                            child:
                                ListTile(
                              contentPadding:
                                  EdgeInsets
                                      .symmetric(
                                horizontal:
                                    13.w,
                                vertical:
                                    6.h,
                              ),
                              leading:
                                  CircleAvatar(
                                radius:
                                    23.r,
                                backgroundColor:
                                    const Color(
                                  0xFF003566,
                                ),
                                child:
                                    Text(
                                  name.isNotEmpty
                                      ? name[0]
                                          .toUpperCase()
                                      : '?',
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                name,
                                style:
                                    TextStyle(
                                  fontFamily:
                                      "Poppins",
                                  fontSize:
                                      14.sp,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                              subtitle:
                                  Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  if (username
                                      .isNotEmpty)
                                    Text(
                                      "@$username",
                                      style:
                                          TextStyle(
                                        fontFamily:
                                            "Poppins",
                                        fontSize:
                                            11.sp,
                                        color: Colors
                                            .grey
                                            .shade700,
                                      ),
                                    ),
                                  if (email
                                      .isNotEmpty)
                                    Text(
                                      email,
                                      style:
                                          TextStyle(
                                        fontFamily:
                                            "Poppins",
                                        fontSize:
                                            10.sp,
                                        color: Colors
                                            .grey
                                            .shade600,
                                      ),
                                    ),
                                ],
                              ),
                              trailing:
                                  Container(
                                width:
                                    35.w,
                                height:
                                    35.w,
                                decoration:
                                    BoxDecoration(
                                  color:
                                      const Color(
                                    0xFFF0CB46,
                                  ).withValues(
                                    alpha:
                                        0.25,
                                  ),
                                  shape:
                                      BoxShape
                                          .circle,
                                ),
                                child:
                                    const Icon(
                                  Icons
                                      .chat_outlined,
                                  color:
                                      Color(
                                    0xFF001D3D,
                                  ),
                                  size:
                                      19,
                                ),
                              ),
                              onTap: () {
                                _openChat(
                                  user,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}