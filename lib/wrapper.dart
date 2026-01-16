import 'package:demo1/homepage.dart';
import 'package:demo1/location_page.dart';
import 'package:demo1/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for the stream
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle errors in the stream
            return Center(
              child: Text(
                'An error occurred: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.hasData) {
            // User is signed in, navigate to the Homepage
            return const LocationPage();
          } else {
            // User is not signed in, show signup screen
            return const signup();
          }
        },
      ),
    );
  }
}