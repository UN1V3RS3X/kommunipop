import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  ProfileRepository({FirebaseAuth firebaseAuth, FirebaseFirestore firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<DocumentSnapshot> getData() async {
    final uid = _firebaseAuth.currentUser.uid;
    return await _firestore.collection("Users").doc(uid).get();
  }

  Future<String> getEmail() async {
    return (_firebaseAuth.currentUser).email;
  }
}
