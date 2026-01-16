import 'package:demo1/Profilepage.dart';
import 'package:demo1/homepage.dart';
import 'package:demo1/input%20data/TripDataPage.dart';
import 'package:flutter/material.dart';
import 'package:demo1/Chat/Chatpage.dart';
import 'package:demo1/Chat/chat_service.dart';
import 'package:demo1/Chat/userTile.dart';

class DisplayUserHome extends StatefulWidget {
  const DisplayUserHome({super.key});

  @override
  State<DisplayUserHome> createState() => _DisplayUserHomeState();
}

class _DisplayUserHomeState extends State<DisplayUserHome> {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat App"),
      ),
      body: _buildUserList(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.wallet),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TripDataPage(),
                  ),
                );
              },
            ),
            const SizedBox(width: 5),
            IconButton(
              icon: const Icon(Icons.chat,color: Colors.orange),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => DisplayUserHome(),
                ),);
              },
            ),
            const SizedBox(width: 5),
            IconButton(
              icon: const Icon(
                Icons.home,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homepage(),
                  ),
                );
              },
            ),
            const SizedBox(width: 15),
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profilepage.Profilepage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error loading users."),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No users found."),
          );
        }

        final users = snapshot.data!;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userData = users[index];
            return _buildUserListItem(userData, context);
          },
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    return Usertile(
      text: userData["email"] ?? "Unknown User",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chatpage(
              receiverEmail: userData["email"] ?? "Unknown",
              receiverUid: userData["uid"] ?? "",
            ),
          ),
        );
      },
    );
  }
}