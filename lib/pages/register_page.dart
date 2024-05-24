import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/components/text_field.dart';
import 'package:fyp/components/button.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  void register() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    if (passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context);
      displayMessage("Passwords don't match");
    }
    //try creating user
    try {
      //create user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text,
              password: passwordTextController.text);
      //after creating user create new document
      FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.email!)
          .set({
        'username': emailTextController.text.split("@")[0],
        'bio': 'empty bio...',
      });
      //pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 215, 0),
      body: Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 65,
                ),
                //logo
                //welcome back
                const Text(
                  'Learning made fun',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Image.asset('assets/images/photopng.png'),
                const SizedBox(height: 15),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Text(
                              'Let us create an account',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                        
                            const SizedBox(
                              height: 25,
                            ),
                            //email textfield
                            MyTextField(
                                controller: emailTextController,
                                hintText: 'Email',
                                obscureText: false),
                            const SizedBox(
                              height: 20,
                            ),
                            //password textfield
                            MyTextField(
                                controller: passwordTextController,
                                hintText: 'Password',
                                obscureText: true),
                            //sign in  button
                            const SizedBox(
                              height: 20,
                            ),
                            MyTextField(
                                controller: confirmPasswordTextController,
                                hintText: "Enter Password again",
                                obscureText: true),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 255, 215, 0),
                                  padding: const EdgeInsets.symmetric(horizontal: 90)
                                ),
                                child: const Text('Register')),
                            //register page
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: widget.onTap,
                                  child: const Text(
                                    '  Login now',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                //   child: Text('Let us create an account',
                //     style:TextStyle(
                //       fontSize: 20,
                //       color: Colors.grey[700],
                //     ) ,),
                // ),
                // const SizedBox(height: 25,),
                // //email textfield
                // MyTextField(controller: emailTextController,
                //     hintText: 'Email',
                //     obscureText: false),
                // const SizedBox(height: 20,),
                // //password textfield
                // MyTextField(controller: passwordTextController,
                //     hintText: 'Password',
                //     obscureText: true),
                // //sign in  button
                // const SizedBox(height: 20,),
                // MyTextField(controller: confirmPasswordTextController,
                //     hintText: "Enter Password again",
                //     obscureText: true),
                // const SizedBox(height: 20,),
                // MyButton(onTap:register, text: 'Register'),
                // //register page
                // const SizedBox(height: 25,),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text('Already have an account?',
                //       style:TextStyle(
                //         color: Colors.grey[700],
                //       ) ,),
                //     GestureDetector(
                //       onTap:widget.onTap,
                //       child: const Text('  Login now',
                //         style: TextStyle(
                //           fontWeight: FontWeight.bold,
                //           color: Colors.blue,
                //         ),),
                //     )
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
