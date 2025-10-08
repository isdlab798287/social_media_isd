/*
this page will display a tab bar to show
list of followers or following users
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/profile/presentation/components/user_tile.dart';
import 'package:isd_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:isd_app/features/profile/presentation/pages/profile_page.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowerPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    //TAB CONTROLLER
    return DefaultTabController(
      length: 2,

      //Scaffold
      child: Scaffold(
        //APP BAR
        appBar: AppBar(
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            tabs: [Tab(text: 'Followers'), Tab(text: 'Following')],
          ),
        ),

        //Tab Bar view
        body: TabBarView(
          children: [
            _buildUserList(followers, "No followers", context),
            _buildUserList(following, "Not following anyone", context),
          ],
        ),
      ),
    );
  }

  // Build user list, given a list of profile uidss
  Widget _buildUserList(
    List<String> uids,
    String emptyMessage,
    BuildContext context,
  ) {
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
          itemCount: uids.length,
          itemBuilder: (context, index) {
            //get each uid
            final uid = uids[index];

            return FutureBuilder(
              future: context.read<ProfileCubit>().getUserProfile(uid),
              builder: (context, snapshot) {
                // USER LOADED
                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  return UserTile(
                    user: user,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(uid: user.uid),
                          ),
                        ),
                  );
                }
                // LOADING
                else if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(title: Text("Loading..."));
                }
                // NOT FOUND
                else {
                  return ListTile(title: Text("User not found"));
                }
              },
              // You can add more details or actions here
            );
          },
        );
  }
}