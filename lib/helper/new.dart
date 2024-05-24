import 'package:flutter/material.dart';
import 'package:fyp/helper/new2.dart';

class New extends StatefulWidget {
  const New({super.key});

  @override
  State<New> createState() => _State();
}

class _State extends State<New> {
  var toggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Line 1'),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Line 2'),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("line 3"),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Icon(Icons.plus_one),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Icon(Icons.cabin),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Icon(Icons.add_a_photo),
              )
            ],
          ),
          TextButton(
            onPressed: () {
              setState(() {
                toggle = !toggle;
              });
            },
            child: Text(toggle ? 'Press' : 'Pressed'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    height: 100,
                    child: Card(
                      color: Colors.deepPurpleAccent,
                      child: Center(child: Text('Index No: ${index + 1}')),
                    ),
                  ),
                );
              },
            ),
          ),
          OutlinedButton(
            onPressed: () {
              // Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const SecondScreen(),
                ),
              );
            },
            child: const Text(
              'Second page',
              style: TextStyle(color: Colors.deepPurpleAccent),
            ),
          )
        ],
      ),
    );
  }
}
