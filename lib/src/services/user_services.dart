import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../src/models/user_model.dart';

class UserServices {
  late FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  UserServices() : firebaseAuth = FirebaseAuth.instance;

  Future<bool> existsInDatabase(String fieldName, String fieldValue) async {
    try {
      return await userCollection
          .where(fieldName, isEqualTo: fieldValue == '' ? '' : fieldValue)
          .get()
          .then((value) {
        return value.docs.length > 0;
      });
    } catch (e) {}
    return false;
  }

  Future<void>? resetPassword(String email) {
    firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential?> signUp(UserModel userModel) async {
    UserCredential userCredential =
        await firebaseAuth.createUserWithEmailAndPassword(
            email: userModel.email, password: userModel.password);
    await userCollection.doc(userModel.email).set(userModel.toMap());
    return userCredential;
  }
}
