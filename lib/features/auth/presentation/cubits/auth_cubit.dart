/*
Auth Cubit- State Management
*/

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/auth/domain/entities/app_user.dart';
import 'package:isd_app/features/auth/domain/repos/auth_repo.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;
  StreamSubscription? _authSubscription;

  AuthCubit({required this.authRepo}) : super(AuthInitial()) {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((
      firebaseUser,
    ) async {
      print("🔄 authStateChanges emitted: $firebaseUser");
      if (firebaseUser != null) {
        // 🔁 Fetch full user profile from Firestore

        final userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(firebaseUser.uid)
                .get();

        if (userDoc.exists) {
        final user = AppUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: userDoc.data()?['name'] ?? 'Anonymous',
        );
    
        _currentUser = user;
        emit(Authenticated(user));
        print("✅ Authenticated as ${user.email}");
      }} else {
        _currentUser = null;
        emit(Unauthenticated());
        print("❌ No user found");
      }
    });
  }

  AppUser? get currentUser => _currentUser;

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      await authRepo.logInWithEmailAndPassword(email: email, password: password);
      // ✅ No need to emit Authenticated — stream listener will handle it
    } catch (e) {
      print("❌ Login error: $e");
      if (FirebaseAuth.instance.currentUser == null) {
      emit(AuthError(message: e.toString()));
      }
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      emit(AuthLoading());
      await FirebaseAuth.instance.signOut();

      //register user
      await authRepo.registerWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );

      // ✅ Set display name in Firebase
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload(); // Refresh user info
      }
    } catch (e) {
      // ❗️Check if user is already authenticated
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Already signed in, no need to emit error
        print("✅ Already signed in, skipping error state.");
      } else {
        emit(AuthError(message: e.toString()));
        print("❌ Registration error: $e");
      }
    }
  }

  Future<void> logOut() async {
    await authRepo.logOut();
    // ✅ authStateChanges will emit Unauthenticated
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  void fetchUserProfile(String uid) {}
}