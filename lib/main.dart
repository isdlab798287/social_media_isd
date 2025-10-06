import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:isd_app/app.dart';
import 'package:isd_app/config/firebase_options.dart';

void main() async{

  // Firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseAuth.instance.signOut();
  // Run the app
  print("🔥 Firebase currentUser at startup: ${FirebaseAuth.instance.currentUser?.email}");

  runApp(MyApp());
}
