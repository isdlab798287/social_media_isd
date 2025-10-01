/*
Aurh repository - outlines the possible auth operations for this app
*/

import 'package:isd_app/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  //log in with email and password
  Future<AppUser?> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  //register with email and password
  Future<AppUser?> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  //log out
  Future<void> logOut();

  //get current user
  Future <AppUser?> getCurrentUser();

}