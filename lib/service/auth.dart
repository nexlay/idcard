import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idcard/database/database.dart';
import 'package:idcard/models/user.dart';

class AuthUser {
  //Firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Store device token
  String idToken;

  //Create User obj
  User _fromFirebase(FirebaseUser user) {
    return user != null ? User(id: user.uid) : null;
  }

  //Get the User if user sing in or null if sing out
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(
      (FirebaseUser user) => _fromFirebase(user),
    );
  }

  //Sing in with email and password
  Future singIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      if (user.isEmailVerified) {
        //Get user token for fcm
        user.getIdToken().then(
          (value) {
            if (user != null) {
              idToken = value.token;
            }
          },
        );

        //Take a document of specific user based on user ID and check if exist or not
        final snapShot = await Firestore.instance
            .collection('idcard_users')
            .document(user.uid)
            .get();
        if (!snapShot.exists) {
          //Create a document for the user in collection
          await DatabaseService(id: user.uid).setUserData(false, 4278228616,
              idToken, '', '', '', '', '', '', '', '', '', '', '', '');
          return _fromFirebase(user);
        } else if (snapShot.exists) {
          await DatabaseService(id: user.uid).updateUserToken(idToken);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print(
        e.toString(),
      );
      return null;
    }
  }

  //Register with email
  Future register(String email, String password) async {
    try {
      //Take a result of authenticate firebase service
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //Return a regular User instead of Firebase User
      FirebaseUser user = result.user;

      try {
        user.sendEmailVerification();
      } catch (e) {
        print("An error occured while trying to send email verification");
        print(e.message);
      }

      return await _auth.signOut();
    } catch (e) {
      print(
        e.toString(),
      );
      return null;
    }
  }

  //Sing out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(
        e.toString(),
      );
      return null;
    }
  }
}
