import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/pages/forum.dart';
import 'package:fyp/pages/profile_page.dart';
import '../components/drawer.dart';
import 'landing_page.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserScore> _leaderboard = [];
  int selectedPage = 2;

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .orderBy('tries',
            descending: false) // Fetch with ascending order for lower tries
        .limit(10)
        .get();

    List<UserScore> loadedLeaderboard = [];
    for (var document in snapshot.docs) {
      var data = document.data() as Map<String, dynamic>?;
      if (data != null) {
        loadedLeaderboard.add(UserScore(
          name: data['username'] ?? 'Anonymous',
          tries:
              data['tries'] as int? ?? 0, // Use 'tries' instead of 'bestScore'
        ));
      }
    }

    setState(() {
      _leaderboard = loadedLeaderboard;
    });
  }

  void goToHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void goToProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
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
            builder: (ctc) => const Forum(),
          ),
        );
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctc) => const HomePage(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 215, 0), // Change app bar color
        title: const Text('Leader Board'),
      ),
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
      body: _leaderboard.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _leaderboard.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: index == 0
                              ? Colors.amber
                              : index == 1
                                  ? Colors.grey
                                  : index == 2
                                      ? Colors.brown
                                      : Colors.white,
                          width: 3.0,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      _leaderboard[index].name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'Tries: ${_leaderboard[index].tries}'), // Display tries instead of best score
                  ),
                );
              },
            ),
    );
  }
}

class UserScore {
  final String name;
  final int tries; // Change from 'score' to 'tries'

  UserScore(
      {required this.name,
      required this.tries}); // Change from 'score' to 'tries'
}
