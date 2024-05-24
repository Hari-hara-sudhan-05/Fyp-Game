import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final _formKey = GlobalKey<FormState>();
  var _name = '';

  void changeName() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _formKey.currentState!.save();
        _formKey.currentState!.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: const Text('Second Page'),

      ),


      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                    ),
                    validator: (name) {
                      if (name!.trim().isEmpty || name == null) {
                        return 'Enter a valid name';
                      }
                      return null;
                    },
                    onSaved: (newName) => _name = newName!,
                  ),
                ),
                ElevatedButton(
                  onPressed: changeName,
                  child: const Text('Submit'),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(_name == ''
              ? 'Welcome to the second page'
              : 'Welcome to the second page $_name')
        ],
      ),
    );
  }
}
