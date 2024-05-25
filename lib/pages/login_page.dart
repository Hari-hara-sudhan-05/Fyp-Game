import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp/components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  void login() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);

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
                //welcome back
                const Text(
                  'Learning made fun',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Image.asset('assets/images/photopng.png'),
                const SizedBox(
                  height: 15,
                ),
                //email textfield
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
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),
                            const Text(
                              'Welcome Back!',
                              style: TextStyle(
                                fontSize: 35,
                              ),
                            ),
                            const SizedBox(height: 30),
                            MyTextField(
                              controller: emailTextController,
                              hintText: 'Email',
                              obscureText: false,
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                            //password textfield
                            MyTextField(
                                controller: passwordTextController,
                                hintText: 'Password',
                                obscureText: true),
                            //sign in  button
                            const SizedBox(
                              height: 25,
                            ),
                            // MyButton(onTap: login, text: 'Login'),
                            ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 90),
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 215, 0)),
                              child: const Text('Login'),
                            ),
                            //register page
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Not registered yet?',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: widget.onTap,
                                  child: const Text(
                                    '  Register now',
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
                ),
                // MyTextField(controller: emailTextController,
                //     hintText: 'Email',
                //     obscureText: false),
                // const SizedBox(height: 25,),
                // //password textfield
                // MyTextField(controller: passwordTextController,
                //     hintText: 'Password',
                //     obscureText: true),
                // //sign in  button
                // const SizedBox(height: 25,),
                // MyButton(onTap: login, text: 'Login'),
                // //register page
                // const SizedBox(height: 25,),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text('Not registered yet?',
                //       style: TextStyle(
                //         color: Colors.grey[700],
                //       ),),
                //     GestureDetector(
                //       onTap: widget.onTap,
                //       child: const Text('  Register now',
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
