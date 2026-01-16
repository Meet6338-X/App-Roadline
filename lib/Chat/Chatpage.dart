import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatpage extends StatefulWidget {
  final String receiverEmail;
  final String receiverUid;

  const Chatpage({
    super.key,
    required this.receiverEmail,
    required this.receiverUid,
  });

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isNotEmpty) {
      try {
        // Generate a sorted chat room ID
        List<String> ids = [currentUserId, widget.receiverUid];
        ids.sort();
        String chatRoomId = ids.join('_');

        // Create the message data
        Map<String, dynamic> messageData = {
          'message': message,
          'senderId': currentUserId,
          'receiverId': widget.receiverUid,
          'timestamp': FieldValue.serverTimestamp(),
        };

        // Send the message to Firestore
        await _firestore
            .collection('chat_rooms')
            .doc(chatRoomId)
            .collection('messages')
            .add(messageData);

        _messageController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send message: $e")),
        );
      }
    }
  }

  // Ensure this method is inside the _ChatpageState class
  Widget _buildMessageItem(DocumentSnapshot message) {
    Map<String, dynamic> messageData = message.data() as Map<String, dynamic>;
    String senderId = messageData['senderId'];
    String messageText = messageData['message'];
    Timestamp timestamp = messageData['timestamp'];
    DateTime timestampDate = timestamp.toDate();
    bool isSender = senderId == currentUserId;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isSender ? Colors.blueAccent : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                messageText,
                style: TextStyle(
                  color: isSender ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _formatTimestamp(timestampDate),
              style: TextStyle(
                color: isSender ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Format the timestamp into a readable format
  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute} ${timestamp.day}/${timestamp.month}';
  }

  Widget buildMessageList() {
    String senderID = FirebaseAuth.instance.currentUser!.uid;
    String receiverID = widget.receiverUid;

    // Create the chat room ID in a consistent format
    List<String> ids = [senderID, receiverID];
    ids.sort(); // Sort to avoid issues with chat room creation
    String chatRoomId = ids.join('_');

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('chat_rooms')
          .doc(chatRoomId) // Ensure the chatRoomId format is consistent
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // Error handling
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading messages"));
        }

        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // No messages state
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No messages yet."));
        }

        final messages = snapshot.data!.docs;

        return ListView.builder(
          reverse: true, // Messages appear from the bottom
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(messages[index]);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.receiverEmail}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildMessageList(), // Using the updated method
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}