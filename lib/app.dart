import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Auth
import 'package:isd_app/features/auth/data/firebase_auth_repo.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:isd_app/features/auth/presentation/pages/auth_page.dart';

// Home
import 'package:isd_app/features/home/presentation/pages/home_page.dart';

// Profile
import 'package:isd_app/features/profile/data/firebase_profile_repo.dart';
import 'package:isd_app/features/profile/presentation/cubits/profile_cubit.dart';

// Post
import 'package:isd_app/features/post/data/firebase_post_repo.dart';
import 'package:isd_app/features/post/presentation/cubits/post_cubit.dart';

// Storage (Cloudinary)
import 'package:isd_app/features/storage/data/cloudinary_storage_repo.dart';

// Search (optional, if already implemented)
import 'package:isd_app/features/search/data/firebase_search_repo.dart';
import 'package:isd_app/features/search/presentation/cubits/search_cubit.dart';

/*
  Root-level app initialization:
  - Sets up repositories (Firebase + Cloudinary)
  - Provides cubits for Auth, Profile, Post, and Search
  - Handles authentication state to switch between AuthPage and HomePage
*/

class MyApp extends StatelessWidget {
  final firebaseAuthRepo = FirebaseAuthRepo();
  final firebaseProfileRepo = FirebaseProfileRepo();
  final firebaseStorageRepo = CloudinaryStorageRepo();
  final firebasePostRepo = FirebasePostRepo();
  final firebaseSearchRepo = FirebaseSearchRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth Cubit
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: firebaseAuthRepo),
        ),

        // Profile Cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: firebaseProfileRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),

        // Post Cubit
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),

        // Search Cubit
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(searchRepo: firebaseSearchRepo),
        ),
      ],

      // App structure
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print("AuthState: $authState");

            if (authState is Unauthenticated) {
              return const AuthPage();
            }

            if (authState is Authenticated) {
              return const HomePage();
            }

            // Default: show loader
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },

          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ),
    );
  }
}
