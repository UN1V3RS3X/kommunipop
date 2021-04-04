import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseAuth firebaseAuth, FirebaseFirestore firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  //SignInWithCredentials
  Future<void> signInWithCredentials(String email, String password) async {
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return user.user.displayName;
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  //SignUp
  Future<void> signUp(String email, String password) async {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return user;
  }

  //SignOut
  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  //Esta Logueado?
  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  //Obtener Usuario
  Future<String> getUser() async {
    return (_firebaseAuth.currentUser).uid;
  }

  Future<String> getEmail() async {
    return (_firebaseAuth.currentUser).email;
  }

  Future<String> getName() async {
    return (_firebaseAuth.currentUser).displayName;
  }

  Future<String> getUserName(String userId) async {
    String name;
    final datos =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    name = datos.data()["nombre"];
    return name;
  }

  Future<bool> isFirstTime(String userId) async {
    bool exist;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .get()
        .then((user) {
      exist = user.exists;
    });

    return exist;
  }
}
