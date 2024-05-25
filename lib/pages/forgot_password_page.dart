import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formState = GlobalKey<FormState>();
  var email = '';

  void _validate() async{
    if (_formState.currentState!.validate()) {
      _formState.currentState!.save();
      displayMessage('You will receive a mail to change password');
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    }
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: const EdgeInsets.symmetric(vertical: 70, horizontal: 50),
        title: Text(message),
        actions: [TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: const Text('okay'))],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Change password', style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w400,
        ),),
        backgroundColor: const Color.fromARGB(255, 255, 215, 0),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 215, 0),
      body: Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //welcome back
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset('assets/images/photopng.png'),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          )),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formState,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      fillColor: Colors.grey.shade200,
                                      filled: true,
                                      hintText: 'Enter your email id',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[500])),
                                  validator: (email) {
                                    if (email!.isEmpty ||
                                        email!.trim().isEmpty) {
                                      return 'Please enter a valid email id';
                                    }
                                    return null;
                                  },
                                  onSaved: (newEmail) {
                                    email = newEmail!;
                                  },
                                ),
                                 const SizedBox(
                                   height: 30,
                                 ),
                                 ElevatedButton(
                                    onPressed: _validate,
                                    child: const Text('change password'),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
