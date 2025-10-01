
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/auth/data/firebase_auth_repo.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:isd_app/features/auth/presentation/pages/auth_page.dart';

class MyApp extends StatelessWidget {

  final authRepo = FirebaseAuthRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(authRepo: authRepo),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AuthCubit, AuthState>
        (builder: (context, authState){
          if (authState is Unauthenticated){
            return const AuthPage();
          }

          if(authState is Authenticated){
            return const Scaffold(
              body: Center(
                child: Text('User is authenticated!'),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }, 
        
        listener: (context, state){},
        ),
      ),
    );
  }
}