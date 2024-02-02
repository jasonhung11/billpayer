// import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

var acs = ActionCodeSettings(
    // URL you want to redirect back to. The domain (www.example.com) for this
    // URL must be whitelisted in the Firebase Console.
    url: 'https://www.example.com/finishSignUp?cartId=1234',
    // This must be true
    handleCodeInApp: true,
    iOSBundleId: 'com.example.ios',
    androidPackageName: 'com.example.android',
    // installIfNotAvailable
    androidInstallApp: true,
    // minimumVersion
    androidMinimumVersion: '12');

Future<User?> register(Map<String, String> user) async {
  // var emailAuth = 'someemail@domain.com';
  print(user);
  String email = user["email"]!;
  String username = user["username"]!;
  String password = user["password"]!;
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    print(credential);
    if (credential.user != null) {
      addUser({
        "id": credential.user!.uid,
        "userName": username,
        "email": email,
        "password": "",
        "groupIdList": []
      });
    }
    return credential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
  return null;
}

Future<Map<String, dynamic>> getUser(String id) async {
  var client = HttpClient();
  String baseUrl = dotenv.env["API_URL"]!;
  String userPath = dotenv.env["USER_API_PATH"]!;
  try {
    Response response = await get(Uri.parse('$baseUrl/$userPath/$id'));
    return jsonDecode(response.body) as Map<String, dynamic>;
  } finally {
    client.close();
  }
}

Future<Map<String, dynamic>> addUser(Map<String, dynamic> user) async {
  var client = HttpClient();
  String baseUrl = dotenv.env["API_URL"]!;
  String userPath = dotenv.env["USER_API_PATH"]!;
  print(user.toString() + ': user');

  try {
    Response response = await post(Uri.parse('$baseUrl/$userPath/add'),
        body: jsonEncode(user), headers: {"Content-Type": "application/json"});
    print(response.body.toString() + "reponse");
    return jsonDecode(response.body) as Map<String, dynamic>;
  } finally {
    client.close();
  }
}

Future<User?> loginWithGoogle() async {
  final googleAccount = await GoogleSignIn().signIn();
  final googleAuth = await googleAccount?.authentication;
  final credential = GoogleAuthProvider.credential(
      idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

  final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
  final response = await getUser(userCredential.user!.uid);
  if (response["data"] == null) {
    addUser({
      "id": userCredential.user!.uid,
      "email": userCredential.user!.email!,
      "userName": "",
      "password": ""
    });
  }
  return userCredential.user;
}

Future<User?> loginWithPassword(email, password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    print(credential.user);
    return credential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
  return null;
}
