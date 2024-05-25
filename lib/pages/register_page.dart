import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/components/text_field.dart';
import 'package:pinput/pinput.dart';
import 'package:email_otp/email_otp.dart';

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
  final otp = TextEditingController();
  final myAuth = EmailOTP();
  var otpSent = false;

  void register() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
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
      displayMessage('Something went wrong. Please try again later');
    }
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: const EdgeInsets.symmetric(vertical: 70, horizontal: 50),
        title: Text(message),
      ),
    );
  }

  void sendOtp() async {
    // Verify Email
    if (emailTextController.text.isEmpty ||
        emailTextController.text.trim().isEmpty) {
      displayMessage('Email address is required');
      return;
    }
    // verify password and confirm password
    else if (passwordTextController.text.isEmpty ||
        passwordTextController.text.trim().isEmpty ||
        confirmPasswordTextController.text.isEmpty ||
        confirmPasswordTextController.text.trim().isEmpty) {
      displayMessage("Password should have atleast 8 characters");
      return;
    }
    // verify confirm password  = password
    else if (passwordTextController.text !=
        confirmPasswordTextController.text) {
      displayMessage("Passwords don't match");
      return;
    }
    myAuth.setConfig(
      appEmail: 'hariharasudhan2210659@ssn.edu.in',
      appName: 'FYP',
      userEmail: emailTextController.text,
      otpLength: 4,
      otpType: OTPType.digitsOnly,
    );
    var template = '''
        <h1 style="text-align:center">Thanks you for choosing {{app_name}}</h1>  
        <br>
        <img src = "https://th.bing.com/th/id/OIP.MtumF6af0uyvmgChvNYLBgHaDc?w=346&h=162&c=7&r=0&o=5&dpr=1.1&pid=1.7">
        <br>
        <h3 style="text-align:center">Your requested OTP is {{otp}}.</h3>
        <footer> © FYP Team </footer>
        ''';

    myAuth.setTemplate(render: template);

    final result = await myAuth.sendOTP();
    if (result == true) {
      setState(() {
        otpSent = true;
      });
      getOtp();
    } else {
      displayMessage('Otp not sent Please verify your email address');
    }
  }

  void getOtp() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Please enter your otp'),
          actions: [
            Pinput(
              length: 4,
              controller: otp,
              validator: (pin) {
                if (pin!.isEmpty || pin.trim().isEmpty) {
                  return 'enter the otp';
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  print(otp.text);
                  Navigator.pop(context);
                  verifyOtp();
                },
                child: const Text('Verify'))
          ],
        ));
  }

  void verifyOtp() async {
    final result = await myAuth.verifyOTP(otp: otp.text);
    if (result == true) {
      register();
    } else {
      displayMessage('You Have Entered a Wrong OTP');
    }
    return;
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
                              // onPressed: register,
                                onPressed: otpSent ? getOtp : sendOtp,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color.fromARGB(255, 255, 215, 0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 90)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}