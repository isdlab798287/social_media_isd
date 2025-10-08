import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/auth/data/firebase_auth_repo.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:isd_app/features/auth/presentation/pages/auth_page.dart';
import 'package:isd_app/features/post/presentation/pages/upload_post_page.dart';
import 'package:isd_app/features/profile/data/firebase_profile_repo.dart';
import 'package:isd_app/features/profile/domain/repos/profile_repo.dart';

class MyApp extends StatelessWidget {
  final authRepo = FirebaseAuthRepo();
  final profileRepo = FirebaseProfileRepo();

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
   return MultiBlocProvider(
    providers: [
BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
        ),
       //profile cubit
        BlocProvider<ProfileCubit>(
          create:
              (context) => ProfileCubit(
                profileRepo: ProfileRepo,
                
              ),
        ), 
    ],
    child: MaterialApp( 
      debugShowCheckedModeBanner: false,
      theme: lightMode,
                    /*providers: [
        //auth cubit
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: firebaseAuthRepo),
        ),

        //profile cubit
        BlocProvider<ProfileCubit>(
          create:
              (context) => ProfileCubit(
                profileRepo: firebaseProfileRepo,
                storageRepo: firebaseStorageRepo,
              ),
        ),

        //post cubit
        BlocProvider<PostCubit>(
          create:
              (context) => PostCubit(
                postRepo: firebasePostRepo,
                storageRepo: firebaseStorageRepo,
              ),
        ),

        //search cubit
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(searchRepo: firebaseSearchRepo),
        ),

        //theme cubit
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
      ],

      
      // bloc builder: themes
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) => 
         MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: currentTheme,
*/
        // bloc builder: check current auth state
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);

            if (authState is Unauthenticated) {
              return const AuthPage();
            }

            if (authState is Authenticated) {
              return const HomePage();
            }

            // fallback for loading/error/initial
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },

          //listen for errors
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    ),
      );
  }
}


