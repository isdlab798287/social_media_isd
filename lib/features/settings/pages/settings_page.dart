/*
SETTINGS PAGE
dark mode, blocked users, account settings
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/responsive/constrained_scaffold.dart';
import 'package:isd_app/themes/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Build UI for SettingsPage
  @override
  Widget build(BuildContext context) {
    // theme cubit
    final themeCubit = context.watch<ThemeCubit>();

    //is dark mode
    bool isDarkMode = themeCubit.isDarkMode;

    // Scaffold
    return ConstrainedScaffold( 
      appBar: AppBar(
        title: const Text("Settings"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // Dark Mode Switch
          ListTile(
            title: const Text("Dark Mode"),
            trailing: CupertinoSwitch(
              value: isDarkMode, 
              onChanged: (value){
                themeCubit.toggleTheme();
              }),
          ),
          // // Account Settings
          // ListTile(
          //   title: const Text("Account Settings"),
          //   onTap: () {
          //     // Navigate to account settings page
          //     Navigator.pushNamed(context, '/account_settings');
          //   },
          // ),
          // // Blocked Users
          // ListTile(
          //   title: const Text("Blocked Users"),
          //   onTap: () {
          //     // Navigate to blocked users page
          //     Navigator.pushNamed(context, '/blocked_users');
          //   },
          // ),
        ],
      ),
    );
  }
}