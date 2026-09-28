import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/chat_service.dart';

class ChatDetailScreen
    extends StatefulWidget {
  final Map<String, dynamic>
      receiverUser;

  const ChatDetailScreen({
    super.key,
    required this.receiverUser,
  });

  @override
  State<ChatDetailScreen>
      createState() =>
          _ChatDetailScreenState();
}

class _ChatDetailScreenState
    extends State<ChatDetailScreen> {
  final ChatService _chatService =
      ChatService();

  final FirebaseAuth _firebaseAuth =
      FirebaseAuth.instance;

  final TextEditingController
      _messageController =
      TextEditingController();

  bool _isSending = false;
  String? _pendingMessage;

  String get _receiverId =>
      widget.receiverUser['uid']
          ?.toString() ??
      '';

  String get _receiverName {
    final firstName =
        widget.receiverUser['firstName']
                ?.toString()
                .trim() ??
            '';

    final lastName =
        widget.receiverUser['lastName']
                ?.toString()
                .trim() ??
            '';

    final fullName =
        '$firstName $lastName'.trim();

    if (fullName.isNotEmpty) {
      return fullName;
    }

    final username =
        widget.receiverUser['username']
                ?.toString()
                .trim() ??
            '';

    if (username.isNotEmpty) {
      return username;
    }

    return 'Chat';
  }

  String get _receiverEmail =>
      widget.receiverUser['email']
          ?.toString() ??
      '';

  String get _receiverInitial {
    final name =
        _receiverName.trim();

    if (name.isEmpty) {
      return '?';
    }

    return name[0].toUpperCase();
  }

  // Lab Activity 6 - Enhancement 3: Sends the message while temporarily displaying a local Sending state.
  Future<void> _sendMessage() async {
    final text =
        _messageController.text.trim();

    if (text.isEmpty ||
        _isSending ||
        _receiverId.isEmpty) {
      return;
    }

    setState(() {
      _isSending = true;
      _pendingMessage = text;
    });

    _messageController.clear();

    try {
      await _chatService.sendMessage(
        _receiverId,
        text,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _messageController.text =
          text;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Unable to send message: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
          _pendingMessage = null;
        });
      }
    }
  }

  String _formatTime(
    Timestamp? timestamp,
  ) {
    if (timestamp == null) {
      return '';
    }

    final date =
        timestamp.toDate();

    final hour =
        date.hour > 12
            ? date.hour - 12
            : date.hour == 0
                ? 12
                : date.hour;

    final minute =
        date.minute
            .toString()
            .padLeft(
              2,
              '0',
            );

    final period =
        date.hour >= 12
            ? 'PM'
            : 'AM';

    return '$hour:$minute $period';
  }

  Widget _buildStatusIndicator(
    String status,
  ) {
    if (status == 'seen') {
      return Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            Icons.done_all,
            size: 14.sp,
            color: const Color(
              0xFFF0CB46,
            ),
          ),
          SizedBox(
            width: 3.w,
          ),
          Text(
            "Seen",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 8.sp,
              color: const Color(
                0xFFF0CB46,
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        Icon(
          Icons.done,
          size: 14.sp,
          color: Colors.white70,
        ),
        SizedBox(
          width: 3.w,
        ),
        Text(
          "Delivered",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 8.sp,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble({
    required String message,
    required bool isMe,
    required String time,
    required String status,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: 0,
        end: 1,
      ),
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.easeOut,
      builder: (
        context,
        animationValue,
        child,
      ) {
        return Opacity(
          opacity: animationValue,
          child: Transform.translate(
            offset: Offset(
              isMe
                  ? 25 *
                      (1 -
                          animationValue)
                  : -25 *
                      (1 -
                          animationValue),
              8 *
                  (1 -
                      animationValue),
            ),
            child: child,
          ),
        );
      },
      child: Align(
        alignment: isMe
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          constraints:
              BoxConstraints(
            maxWidth:
                MediaQuery.sizeOf(
                      context,
                    ).width *
                    0.76,
          ),
          margin:
              EdgeInsets.only(
            bottom: 9.h,
          ),
          padding:
              EdgeInsets.fromLTRB(
            14.w,
            10.h,
            14.w,
            7.h,
          ),
          decoration:
              BoxDecoration(
            color: isMe
                ? const Color(
                    0xFF003566,
                  )
                : Theme.of(context)
                    .cardColor,
            borderRadius:
                BorderRadius.only(
              topLeft:
                  Radius.circular(
                18.r,
              ),
              topRight:
                  Radius.circular(
                18.r,
              ),
              bottomLeft:
                  Radius.circular(
                isMe ? 18.r : 4.r,
              ),
              bottomRight:
                  Radius.circular(
                isMe ? 4.r : 18.r,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(
                  alpha: 0.06,
                ),
                blurRadius: 6,
                offset: const Offset(
                  0,
                  2,
                ),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                isMe
                    ? CrossAxisAlignment
                        .end
                    : CrossAxisAlignment
                        .start,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontFamily:
                      "Poppins",
                  fontSize: 13.sp,
                  color: isMe
                      ? Colors.white
                      : Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontFamily:
                          "Poppins",
                      fontSize: 8.sp,
                      color: isMe
                          ? Colors.white60
                          : Colors
                              .grey.shade600,
                    ),
                  ),
                  if (isMe) ...[
                    SizedBox(
                      width: 6.w,
                    ),
                    _buildStatusIndicator(
                      status,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingBubble() {
    final message =
        _pendingMessage;

    if (message == null) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment:
          Alignment.centerRight,
      child: AnimatedOpacity(
        opacity: _isSending
            ? 1
            : 0,
        duration:
            const Duration(
          milliseconds: 200,
        ),
        child: Container(
          constraints:
              BoxConstraints(
            maxWidth:
                MediaQuery.sizeOf(
                      context,
                    ).width *
                    0.76,
          ),
          margin:
              EdgeInsets.only(
            bottom: 9.h,
          ),
          padding:
              EdgeInsets.fromLTRB(
            14.w,
            10.h,
            14.w,
            7.h,
          ),
          decoration:
              BoxDecoration(
            color:
                const Color(
              0xFF003566,
            ).withValues(
              alpha: 0.75,
            ),
            borderRadius:
                BorderRadius.only(
              topLeft:
                  Radius.circular(
                18.r,
              ),
              topRight:
                  Radius.circular(
                18.r,
              ),
              bottomLeft:
                  Radius.circular(
                18.r,
              ),
              bottomRight:
                  Radius.circular(
                4.r,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontFamily:
                      "Poppins",
                  fontSize: 13.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 10.w,
                    height: 10.w,
                    child:
                        const CircularProgressIndicator(
                      strokeWidth: 1.4,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    "Sending...",
                    style: TextStyle(
                      fontFamily:
                          "Poppins",
                      fontSize: 8.sp,
                      color:
                          Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final currentUser =
        _firebaseAuth.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Chat",
          ),
        ),
        body: const Center(
          child: Text(
            "Firebase login is required.",
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      appBar: AppBar(
        titleSpacing: 5.w,
        title: Row(
          children: [
            CircleAvatar(
              radius: 19.r,
              backgroundColor:
                  const Color(
                0xFFF0CB46,
              ),
              child: Text(
                _receiverInitial,
                style:
                    const TextStyle(
                  color: Color(
                    0xFF001D3D,
                  ),
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    _receiverName,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style: TextStyle(
                      fontFamily:
                          "Poppins",
                      fontSize: 15.sp,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                  if (_receiverEmail
                      .isNotEmpty)
                    Text(
                      _receiverEmail,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style: TextStyle(
                        fontFamily:
                            "Poppins",
                        fontSize: 9.sp,
                        fontWeight:
                            FontWeight.normal,
                        color:
                            Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<
                QuerySnapshot<
                    Map<String,
                        dynamic>>>(
              stream:
                  _chatService
                      .getMessages(
                currentUser.uid,
                _receiverId,
              ),

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
                        "Error loading messages:\n${snapshot.error}",
                        textAlign:
                            TextAlign.center,
                      ),
                    ),
                  );
                }

                final documents =
                    snapshot.data?.docs ??
                        [];

                // Lab Activity 6 - Enhancement 3: Incoming delivered messages are marked as seen while this conversation is open.
                WidgetsBinding.instance
                    .addPostFrameCallback(
                  (_) {
                    _chatService
                        .markMessagesAsSeen(
                      _receiverId,
                    );
                  },
                );

                if (documents.isEmpty &&
                    _pendingMessage ==
                        null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        Container(
                          width: 78.w,
                          height: 78.w,
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFFF0CB46,
                            ).withValues(
                              alpha: 0.2,
                            ),
                            shape:
                                BoxShape
                                    .circle,
                          ),
                          child:
                              Icon(
                            Icons
                                .chat_bubble_outline,
                            size:
                                37.sp,
                            color:
                                const Color(
                              0xFF003566,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          "Start a conversation",
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
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          "Send your first message to $_receiverName.",
                          textAlign:
                              TextAlign
                                  .center,
                          style:
                              TextStyle(
                            fontFamily:
                                "Poppins",
                            fontSize:
                                11.sp,
                            color: Colors
                                .grey
                                .shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding:
                      EdgeInsets.fromLTRB(
                    14.w,
                    15.h,
                    14.w,
                    8.h,
                  ),
                  itemCount:
                      documents.length +
                          (_pendingMessage !=
                                  null
                              ? 1
                              : 0),

                  itemBuilder:
                      (
                    context,
                    index,
                  ) {
                    if (_pendingMessage !=
                            null &&
                        index == 0) {
                      return _buildPendingBubble();
                    }

                    final documentIndex =
                        _pendingMessage != null
                            ? index - 1
                            : index;

                    final message =
                        documents[
                                documentIndex]
                            .data();

                    final senderId =
                        message['senderId']
                                ?.toString() ??
                            '';

                    final text =
                        message['message']
                                ?.toString() ??
                            '';

                    final status =
                        message['status']
                                ?.toString() ??
                            'delivered';

                    final timestamp =
                        message['timestamp']
                                is Timestamp
                            ? message[
                                    'timestamp']
                                as Timestamp
                            : null;

                    final isMe =
                        senderId ==
                            currentUser.uid;

                    return _buildMessageBubble(
                      message: text,
                      isMe: isMe,
                      time: _formatTime(
                        timestamp,
                      ),
                      status: status,
                    );
                  },
                );
              },
            ),
          ),

          SafeArea(
            top: false,
            child: Container(
              padding:
                  EdgeInsets.fromLTRB(
                12.w,
                9.h,
                12.w,
                9.h,
              ),
              decoration:
                  BoxDecoration(
                color:
                    Theme.of(context)
                        .cardColor,
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black
                            .withValues(
                      alpha: 0.06,
                    ),
                    blurRadius: 10,
                    offset:
                        const Offset(
                      0,
                      -3,
                    ),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller:
                          _messageController,
                      textInputAction:
                          TextInputAction.send,
                      minLines: 1,
                      maxLines: 4,
                      onSubmitted: (_) {
                        _sendMessage();
                      },
                      decoration:
                          InputDecoration(
                        hintText:
                            "Type a message...",
                        prefixIcon:
                            const Icon(
                          Icons
                              .chat_bubble_outline,
                          color:
                              Color(
                            0xFF003566,
                          ),
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context)
                                .scaffoldBackgroundColor,
                        contentPadding:
                            EdgeInsets.symmetric(
                          horizontal:
                              15.w,
                          vertical:
                              11.h,
                        ),
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            25.r,
                          ),
                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 8.w,
                  ),

                  SizedBox(
                    width: 46.w,
                    height: 46.w,
                    child:
                        FloatingActionButton(
                      heroTag:
                          "sendMessageButton",
                      elevation: 0,
                      backgroundColor:
                          const Color(
                        0xFFF0CB46,
                      ),
                      foregroundColor:
                          const Color(
                        0xFF001D3D,
                      ),
                      onPressed:
                          _isSending
                              ? null
                              : _sendMessage,
                      child: _isSending
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child:
                                  const CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    Color(
                                  0xFF001D3D,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.send_rounded,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}