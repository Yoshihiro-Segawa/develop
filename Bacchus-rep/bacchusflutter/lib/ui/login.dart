import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class loginScreen extends StatefulWidget {
  @override
  loginScreenState createState() => loginScreenState();
}

class loginScreenState extends State<loginScreen> {
  late UserCredential _user;
  final _googleSignIn = new GoogleSignIn();
  final _auth = FirebaseAuth.instance;
  String infoText = '';
  late var isUserLogin;

  @override
  Widget build(BuildContext context) {
    print('loginScreen');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              // メッセージ表示
              child: Text(infoText),
            ),
            SignInButton(
              Buttons.Google,
              onPressed: () async {
                try {
                  await signInWithGoogle();
                  setState(() {
                    isUserLogin = _auth.currentUser?.uid;
                  });
                  if (_auth.currentUser?.uid != null) {
                    Navigator.pushNamed(context, '/personal');
                  }

                  // await Navigator.pushReplacementNamed(context, '/personal');
                } catch (e) {
                  setState(() {
                    infoText = "ログイン失敗:${e.toString()}";
                  });
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            if (Platform.isIOS)
              SignInButton(
                Buttons.AppleDark,
                onPressed: () async {
                  try {
                    await signInWithApple();
                    setState(() {
                      isUserLogin = _auth.currentUser?.uid;
                    });
                    if (_auth.currentUser?.uid != null) {
                      Navigator.pushNamed(context, '/personal');
                    }
                  } catch (e) {
                    setState(() {
                      infoText = "ログイン失敗:${e.toString()}";
                    });
                  }
                },
              ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: InkWell(
                child: Text(
                  '利用規約',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () => Navigator.pushNamed(context, '/kiyaku'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: InkWell(
                child: Text(
                  'プライバシーポリシー',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () => Navigator.pushNamed(context, '/policy'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }
}
