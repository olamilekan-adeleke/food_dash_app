import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_dash_app/cores/constants/error_text.dart';
import 'package:food_dash_app/cores/utils/logger.dart';
import 'package:food_dash_app/features/auth/model/login_user_model.dart';

class AuthenticationRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference userCollectionRef =
      FirebaseFirestore.instance.collection('users');

  LoginUserModel? userFromFirestore(User? user) {
    infoLog('User: ${user?.uid}');
    return user != null ? LoginUserModel(user.uid) : null;
  }

  String? getUserUid() {
    return _firebaseAuth.currentUser?.uid;
  }

  Future<void> loginUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      infoLog('userCredential: ${user?.uid}', title: 'user log in');

      // TODO: get user data
      // TODO: save user data on device offline
      // TODO: subscribe user to notifictaions

      

    } on SocketException {
      throw Exception(noInternetConnectionText);
    }  catch (e) {
      errorLog(e.toString(), 'Error loging in user', title: 'login', );
      throw Exception(e.toString());
    }
  }


}
