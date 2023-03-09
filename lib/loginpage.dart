import 'package:path/path.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'otpsc.dart';
class loginpage extends StatefulWidget {
  const loginpage({Key? key}) : super(key: key);

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final TextEditingController _phoneNumberController = TextEditingController(text: '+91');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.network(
              'https://t4.ftcdn.net/jpg/02/55/94/55/360_F_255945532_gXYb4gPaatBY39i9KIte3K38KH3lJYIq.jpg',
              height: 200,
              width: 300,
            ),




            const SizedBox(height: 16),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                hintText: 'Phone number',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                verifyPhoneNumber(_phoneNumberController.text, context);
                // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>VerificationCodeInputScreen()));
              },
              child: const Text('Send verification code'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VerificationCodeInputScreen(verificationId: verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 60),
    );
  }
}
