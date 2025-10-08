import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isd_app/features/auth/domain/entities/app_user.dart';
import 'package:isd_app/features/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  // FirebaseAuth instance
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      //attempt to sign in the user
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      //fetch user data from firestore
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      //create user
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        name: userDoc['name'] ?? '',
        email: email,
      );

      // Save to Firestore (wait here)
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(user.toJson());

      //return user
      return user;
    } on FirebaseAuthException catch (e) {
      // 👇 rethrow specific exception so Cubit can handle it
      throw e;
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Create user in FirebaseAuth
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create AppUser instance
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
      );

      // Save to Firestore (wait here)
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(user.toJson());

      return user;
    }
    //catch any errors
    catch (e) {
      throw Exception('Error registering user: $e');
    }
  }

  @override
  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    // Wait briefly to let Firebase rehydrate user state
    await Future.delayed(const Duration(milliseconds: 500));
    //get current logged in user from firebase
    final firebaseUser = firebaseAuth.currentUser;

    //check if user is null
    if (firebaseUser == null) {
      return null;
    }

    final userDoc = await firebaseFirestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!userDoc.exists) {
      return AppUser(
        uid: firebaseUser.uid,
        name: userDoc['name'] ?? '',
        email: firebaseUser.email!,
      );
    }

    //fetch user data from firestore
    await firebaseFirestore.collection('users').doc(firebaseUser.uid).get();

    //user exists
    return AppUser(
      uid: firebaseUser.uid,
      name: userDoc['name'] ?? '',
      email: firebaseUser.email!,
    );
  }


}
