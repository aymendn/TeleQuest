import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nasa/models/game_user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum SigninMethod {
  google,
  email,
  guest,
}

Future<bool> isEmailAlreadyExist(email) async {
  final url = Uri.parse(
      'https://nasa-petacode-default-rtdb.firebaseio.com/leaderboard.json');

  final response = await http.get(url);

  if (json.decode(response.body) == null) return false;

  final extractedData = Map<String, dynamic>.from(json.decode(response.body));

  final listOfUsers = [
    for (var user in extractedData.values) GameUser.fromMap(user)
  ];

  for (var gameUser in listOfUsers) {
    if (gameUser.email == email) return true;
  }
  return false;
}

// Future<void> updateUserId(email) async {
//   final url = Uri.parse(
//       'https://nasa-petacode-default-rtdb.firebaseio.com/leaderboard.json');

//   final response = await http.get(url);

//   if (json.decode(response.body) == null) return false;

//   final extractedData = Map<String, dynamic>.from(json.decode(response.body));

//   final listOfUsers = [
//     for (var user in extractedData.values) GameUser.fromMap(user)
//   ];

//   for (var gameUser in listOfUsers) {
//     if (gameUser.email == email) return true;
//   }
//   return false;
// }

Future<void> addUserToLeaderboard(GameUser gameUser) async {
  final uniqueId = gameUser.email!.split('@')[0];

  final database = FirebaseDatabase.instance.ref();

  final leaderBoardRef = database.child('leaderboard/$uniqueId');
  await leaderBoardRef.set(gameUser.toMap());

  // final url = Uri.parse(
  //     'https://nasa-petacode-default-rtdb.firebaseio.com/leaderboard.json');

  // final response = await http.post(url, body: gameUser.toJson());
  // return json.decode(response.body)['name'];
}

Future<User?> emailSignin(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      throw Exception('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      throw Exception('Wrong password provided for that user.');
    }
  }
  return null;
}

final authProvider = ChangeNotifierProvider<Auth>((ref) {
  return Auth();
});

final futureAuthProvider = FutureProvider<void>((ref) async {
  final auth = ref.watch(authProvider);
  await auth.getUser();
});

class Auth with ChangeNotifier {
  GameUser user = GameUser();

  bool get isAuth => user.isAuth;

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedData = prefs.getString('user');
    print(loadedData);
    if (loadedData == null) return;
    final loadedUser = GameUser.fromJson(loadedData);
    user = loadedUser;
  }

  Future<void> login(
    SigninMethod signinMethod, {
    String? name,
    String? email,
    String? password,
  }) async {
    switch (signinMethod) {
      case SigninMethod.guest:
        user.name = name!;
        break;
      case SigninMethod.google:
        final loginInfo = await GoogleSignIn().signIn();

        if (loginInfo == null) return;

        user.name = loginInfo.displayName;
        user.email = loginInfo.email;
        user.imageUrl = loginInfo.photoUrl;

        final isEmailExist = await isEmailAlreadyExist(user.email);
        if (!isEmailExist) {
          await addUserToLeaderboard(user);
        }
        break;

      default:
        final loginInfo = await emailSignin(email!, password!);
        if (loginInfo == null) return;
        user.name = loginInfo.displayName;
        user.email = loginInfo.email;
        user.imageUrl = loginInfo.photoURL;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user.toJson());
    notifyListeners();
  }

  void nextOfflineLevel(int stars) {
    if (stars == 0) return;
    user.nextLevel();

    try {
      final database = FirebaseDatabase.instance.ref();
      final userRef = database.child('leaderboard/${user.username}');
      userRef.update({'offlineLevel': user.offlineLevel + 1});
    } catch (e) {
      return;
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final isEmailExist = await isEmailAlreadyExist(email);
    if (isEmailExist) {
      throw Exception('User already exist');
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userInfo = await emailSignin(email, password);
      if (userInfo == null) return;

      await userInfo.updateDisplayName(name);

      user.name = name;
      user.email = userInfo.email;
      user.imageUrl = userInfo.photoURL;

      final gameUser = GameUser(name: name, email: email, password: password);
      await addUserToLeaderboard(gameUser);

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    if (user.isGoogleSignin) await GoogleSignIn().signOut();
    if (user.isEmailSignin) await FirebaseAuth.instance.signOut();

    user.clearUser();

    prefs.remove('user');

    notifyListeners();
  }
}
