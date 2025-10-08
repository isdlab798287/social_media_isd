import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_cubit.dart';

import 'package:isd_app/features/home/presentation/components/my_drawer_tile.dart';
import 'package:isd_app/features/profile/presentation/pages/profile_page.dart';
//import 'package:social_media/features/profile/data/firebase_profile_repo.dart';
//import 'package:social_media/features/profile/presentation/pages/profile_page.dart';
//import 'package:social_media/features/search/presentation/pages/search_page.dart';
//import 'package:social_media/features/settings/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              Divider(color: Theme.of(context).colorScheme.secondary),

              // Home
              MyDrawerTile(
                title: "H O M E",
                icon: Icons.home,
                onTap: () => Navigator.of(context).pop(),
              ),

              // Profile

              MyDrawerTile(
                title: "P R O F I L E",
                icon: Icons.person,
                onTap: () {
                  Navigator.of(context).pop();
                  final user = context.read<AuthCubit>().currentUser;
                  final uid = user?.uid;
                  if (uid != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage(uid: uid)),
                    );
                  }
                },
              ), 

              // Search
              /*
              MyDrawerTile(
                title: "S E A R C H",
                icon: Icons.search,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                ),
              ), */

              // Settings
              /* MyDrawerTile(
                title: "S E T T I N G S",
                icon: Icons.settings,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                ),
              ), */

              const Spacer(),

              // Logout
              MyDrawerTile(
                title: "L O G O U T",
                icon: Icons.logout,
                onTap: () => context.read<AuthCubit>().logOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
