  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo1/Chat/displayuserhome.dart';
import 'package:demo1/homepage.dart';
import 'package:demo1/login.dart';
import 'package:demo1/wrapper.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
  class signup extends StatefulWidget {
    const signup({super.key});

    @override
    State<signup> createState() => _signupState();
  }

  class _signupState extends State<signup> {

    bool _isObscured = true;
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    Future<void> Signup() async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );

        // Add user info to Firestore
        await FirebaseFirestore.instance.collection('Users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email.text,
        });

        Get.offAll(() => const Homepage());
      } catch (e) {
        // Handle errors if needed
        print('Error during signup: $e');
      }
    }

    Future<void> login() async {
      try {
        // Initiate Google Sign-In
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        if (googleUser == null) {
          // User canceled the login
          print('Google Sign-In canceled by user.');
          return;
        }

        // Obtain Google authentication details
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a credential for Firebase authentication
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in with Firebase using the credential
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        // Check if user exists in Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(userCredential.user!.uid).get();

        // If the user does not exist in Firestore, create a new user document
        if (!userDoc.exists) {
          await FirebaseFirestore.instance.collection('Users').doc(userCredential.user!.uid).set({
            'uid': userCredential.user!.uid,
            'email': userCredential.user!.email,
          });
        }

        // Navigate to Homepage after successful login
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Wrapper()),
          );
        }
      } catch (e) {
        // Handle errors (e.g., print the error)
        print('Error during Google Sign-In: $e');
      }
    }

    @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Create Account',
                      style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Welcome to Shine Roadlines \n    Sign up to Create account',
                      style: TextStyle(color: Color(0xffa4a2af)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderSide:
                        const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderSide:
                        const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                        icon: Icon(
                          _isObscured ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    obscureText: _isObscured, // Toggles password visibility
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, // Makes the button full width
                    child: ElevatedButton(onPressed: () => Signup(),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(
                              0xFFed6f26), // Set the background color here
                        ),
                      ),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                          20, // Optional: Set text color for better contrast
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xffa4a2af),
                            ),
                          ),
                          TextSpan(
                            text: 'Log in',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFFed6f26),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => login(), // Calls the login method
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Set the button color to match Google's style
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        side: const BorderSide(color: Colors.black), // Optional border
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 12.0),
                            const Text(
                              'Login with Google',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black, // Match Google's text color
                              ),
                            ),
                          ],
                        ),
                      ),
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
