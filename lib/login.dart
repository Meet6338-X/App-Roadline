import 'package:demo1/forgot.dart';
import 'package:demo1/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> SignIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.text, password: password.text);
  }

  final border = const BorderSide(width: 1, color: Colors.black);
  bool _isObscured = true;


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
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to Homepage after successful login
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Center(
                    child: Text(
                      'Log In',
                      style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Welcome back you have been missed!',
                      style: TextStyle(color: Color(0xffa4a2af)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                        hintText: 'Enter Email',
                        labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: password,
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
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
                    obscureText: _isObscured, // Controlled by _isObscured
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Forgot()), // Ensure SignIn() is a defined widget
                      );
                    },
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => SignIn(),
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Color(0xFFed6f26),
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),),
                  SizedBox(height: 20),
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
                ]),
          ),
        ),
      ),
    );
  }
}