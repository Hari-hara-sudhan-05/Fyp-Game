// forum.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/components/drawer.dart';
import 'package:fyp/components/forum_post.dart';
import 'package:fyp/components/text_field.dart';
import 'package:fyp/pages/landing_page.dart';
import 'package:fyp/pages/leaderboard.dart';
import 'package:fyp/pages/profile_page.dart';

import '../helper/helper_methods.dart';

class Forum extends StatefulWidget {
  const Forum({super.key});

  @override
  State<Forum> createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final textController = TextEditingController();
  int selectedPage = 1;


  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("user posts").add(
        {
          'UserEmail': currentUser!.email,
          'message': textController.text,
          'TimeStamp': Timestamp.now(),
          'Likes': [],
        },
      );
    }
    textController.text = '';
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
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctc) => const HomePage(),
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

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 215, 0), // Change app bar color
          title: const Text('Discussion Forum'),

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
      backgroundColor: Colors.grey[300],

      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("user posts")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return ForumPost(
                          message: post['message'],
                          user: post['UserEmail'],
                          postID: post.id,
                          time: formatData(post['TimeStamp']),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: +${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Create your post',
                      obscureText: false,
                    ),
                  ),
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
