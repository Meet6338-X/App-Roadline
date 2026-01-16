import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo1/Chat/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /*
   * This method streams a list of users from the "users" collection.
   * Each user is represented as a Map<String, dynamic> containing details like 'email' and 'uid'.
   */
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      // Log the number of documents fetched
      print("Number of users found: ${snapshot.docs.length}");

      if (snapshot.docs.isEmpty) {
        print("No users found in the 'users' collection.");
        return [];
      }

      // Log the first document for debugging
      print("First user document: ${snapshot.docs.first.data()}");

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Safely extract fields with default fallback values
        final email = data['email'] ?? "Unknown";
        final uid = data['uid'] ?? "";

        // Log data for debugging
        print("Fetched user data: email: $email, uid: $uid");

        return {
          'email': email,
          'uid': uid,
        };
      }).toList();
    });
  }

  /*
   * Sends a message from the current user to the specified receiverID.
   */
  Future<void> sendMessage(String receiverID, String message) async {
    try {
      // Get current user's ID and email
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("User is not logged in.");
      }

      final String currentUserID = currentUser.uid;
      final String currentUserEmail = currentUser.email!;

      // Timestamp for the message
      final Timestamp timestamp = Timestamp.now();

      // Create a new message object
      Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp,
      );

      // Generate a consistent chat room ID
      List<String> ids = [currentUserID, receiverID];
      ids.sort();
      String chatRoomID = ids.join('_');

      // Save the message to the Firestore database
      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .add(newMessage.toMap());

      print("Message sent successfully!");
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  /*
   * Streams messages between the current user and another user.
   */
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}