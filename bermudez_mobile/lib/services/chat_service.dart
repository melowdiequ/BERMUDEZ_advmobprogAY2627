import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth =
      FirebaseAuth.instance;

  // Lab Activity 6 - Original Source: Retrieves registered users from the Firestore Users collection.
  Stream<List<Map<String, dynamic>>>
      getUsersStream() {
    return _firestore
        .collection('Users')
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            final data = doc.data();

            return {
              ...data,
              'uid': data['uid'] ?? doc.id,
            };
          },
        ).toList();
      },
    );
  }

  // Lab Activity 6 - Enhancement 3: Sends a message and stores its initial Firestore state as delivered.
  Future<void> sendMessage(
    String receiverId,
    String message,
  ) async {
    final currentUser =
        _firebaseAuth.currentUser;

    if (currentUser == null) {
      throw Exception(
        'No Firebase user is currently signed in.',
      );
    }

    final String currentUserId =
        currentUser.uid;

    final String currentUserEmail =
        currentUser.email ?? '';

    final Timestamp timestamp =
        Timestamp.now();

    final newMessage =
        MessageModel(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
      status: 'delivered',
    );

    final List<String> ids = [
      currentUserId,
      receiverId,
    ];

    ids.sort();

    final String chatRoomId =
        ids.join('_');

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(
          newMessage.toMap(),
        );
  }

  // Lab Activity 6 - Original Source: Returns the shared conversation between two users as a real-time Firestore stream.
  Stream<QuerySnapshot<Map<String, dynamic>>>
      getMessages(
    String userId,
    String otherUserId,
  ) {
    final List<String> ids = [
      userId,
      otherUserId,
    ];

    ids.sort();

    final String chatRoomId =
        ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy(
          'timestamp',
          descending: true,
        )
        .snapshots();
  }

  // Lab Activity 6 - Enhancement 3: Marks messages received by the current Firebase user as seen when the conversation is opened.
  Future<void> markMessagesAsSeen(
    String otherUserId,
  ) async {
    final currentUser =
        _firebaseAuth.currentUser;

    if (currentUser == null) {
      return;
    }

    final List<String> ids = [
      currentUser.uid,
      otherUserId,
    ];

    ids.sort();

    final String chatRoomId =
        ids.join('_');

    final querySnapshot =
        await _firestore
            .collection('chat_rooms')
            .doc(chatRoomId)
            .collection('messages')
            .where(
              'receiverId',
              isEqualTo: currentUser.uid,
            )
            .get();

    final WriteBatch batch =
        _firestore.batch();

    bool hasUpdates = false;

    for (final document
        in querySnapshot.docs) {
      final data =
          document.data();

      final status =
          data['status']?.toString() ??
              'delivered';

      if (status != 'seen') {
        batch.update(
          document.reference,
          {
            'status': 'seen',
          },
        );

        hasUpdates = true;
      }
    }

    if (hasUpdates) {
      await batch.commit();
    }
  }

  // Lab Activity 6 - Original Source: Finds a Firestore user UID using an email address.
  Future<String?> getUidByEmail(
    String email,
  ) async {
    final query =
        await _firestore
            .collection('Users')
            .where(
              'email',
              isEqualTo: email,
            )
            .limit(1)
            .get();

    if (query.docs.isEmpty) {
      return null;
    }

    final data =
        query.docs.first.data();

    return (
          data['uid'] ??
          query.docs.first.id
        )
        .toString();
  }
}