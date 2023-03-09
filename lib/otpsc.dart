import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'homepge.dart';
import 'homevideo.dart';
class VerificationCodeInputScreen extends StatefulWidget {
  final String verificationId;

  const VerificationCodeInputScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  _VerificationCodeInputScreenState createState() =>
      _VerificationCodeInputScreenState();
}

class _VerificationCodeInputScreenState
    extends State<VerificationCodeInputScreen> {
  final TextEditingController _verificationCodeController =
  TextEditingController();
  String? _errorMessage;

  Future<void> _signInWithPhoneNumber(String verificationId, String smsCode) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to the next screen after successful authentication
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VideoList()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Enter verification code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://t4.ftcdn.net/jpg/02/55/94/55/360_F_255945532_gXYb4gPaatBY39i9KIte3K38KH3lJYIq.jpg',
              height: 200,
              width: 300,
            ),
            TextField(
              controller: _verificationCodeController,
              decoration: InputDecoration(
                hintText: 'Verification code',
                errorText: _errorMessage,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final String smsCode = _verificationCodeController.text.trim();
                _signInWithPhoneNumber(widget.verificationId, smsCode);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}


