import 'package:demo1/Chat/displayuserhome.dart';
import 'package:demo1/forgot.dart';
import 'package:demo1/homepage.dart';
import 'package:demo1/input%20data/TripDataPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profilepage extends StatelessWidget {
  const Profilepage.Profilepage({super.key});

  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Homepage(),
              ),);
          }
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Picture and Info
          Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  user?.email ?? 'No user email available',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Gold Member",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Action Cards: Check Rates and Pickup Point
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionCard(
                title: 'Choose Truck',
                icon: Icons.local_shipping,
                color: Colors.orange,
              ),
              const SizedBox(width: 20),
              _buildActionCard(
                title: 'Pick up Point',
                icon: Icons.location_on,
                color: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 30),
          // General Settings List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lock_outline,color: Colors.orange,),
                  title: const Text('Change Password'),
                  onTap: () {
                    print('Change Password tapped');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Forgot()), // Ensure SignIn() is a defined widget
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.login_rounded,color: Colors.orange,),
                  title: const Text('Sign Out'),
                  onTap: () {
                    print('Sign Out tapped');
                        () => signout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
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
              icon: const Icon(Icons.chat),
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
              icon: const Icon(Icons.account_circle,color: Colors.orange),
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

  // Widget for action cards (Check Rates, Pick-up Point)
  Widget _buildActionCard(
      {required String title, required IconData icon, required Color color}) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
