import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/Games/gamesmain.dart';
import 'package:fyp/pages/forum.dart';
import 'package:fyp/pages/profile_page.dart';
import 'package:fyp/pages/quotes.dart';
import '../components/drawer.dart';
import 'leaderboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User? currentUser;
  int selectedPage = 0;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  void signOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void goToHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void goToProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  void _selectPage(int index) {
    setState(() {
      selectedPage = index;
    });
    _navigateToPage(index);
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const Forum(),
          ),
        );
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctc) => const LeaderboardPage(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = currentUser?.email ?? '';
    final name = email.split('@').first;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 215, 0), // Change app bar color
          title: const Text('Home Page'),
          actions: [
            IconButton(
              onPressed: () => signOut(context),
              icon: const Icon(Icons.logout),
            ),
          ]),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onHomeTap: goToHomePage,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: selectedPage,
        selectedItemColor: const Color.fromARGB(255, 255, 215, 0),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home page',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Discussion forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('No user data found'),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          if (userData.isEmpty) {
            return const Center(
              child: Text('No user data found'),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome ${userData['username']}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 255, 215, 0),
                  radius: 60.0,
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                _buildButton(
                  context,
                  'Play Games',
                  GamesListPage(),
                ),
                const SizedBox(height: 20.0),
                _buildButton(
                  context,
                  'Quote for the day',
                  QuotePage(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Customized Button Widget
  Widget _buildButton(BuildContext context, String text, Widget route) {
    return GestureDetector(
      onTap: () {
        try {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        } catch (e) {
          print('Error navigating to $text page: $e');
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color.fromARGB(255, 255, 215, 0),Color.fromARGB(255, 255, 215, 0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 255, 215, 0).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
