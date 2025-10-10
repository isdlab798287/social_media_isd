import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/auth/domain/entities/app_user.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_cubit.dart';

//import 'package:isd_app/features/post/presentation/components/post_tile.dart';
import 'package:isd_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:isd_app/features/post/presentation/cubits/post_states.dart';
import 'package:isd_app/features/profile/presentation/components/bio_box.dart';
import 'package:isd_app/features/profile/presentation/components/follow_button.dart';
import 'package:isd_app/features/profile/presentation/components/profile_stats.dart';
import 'package:isd_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:isd_app/features/profile/presentation/cubits/profile_states.dart';
import 'package:isd_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:isd_app/features/profile/presentation/pages/follower_page.dart';
import 'package:isd_app/responsive/constrained_scaffold.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  //current user
  late AppUser? currentUser = authCubit.currentUser;

  //posts count
  int postsCount = 0;

  //on startup,
  @override
  void initState() {
    super.initState();
    //fetch the user profile
    profileCubit.fetchUserProfile(widget.uid);
  }

  /*
  FOLLOW ? UNFOLLOW BUTTON
   */

  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) return;

    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    //optimistically update ui
    setState(() {
      //unfollow
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      }
      //follow
      else {
        profileUser.followers.add(currentUser!.uid);
      }
    });

    //perform the follow/unfollow action in the cubit
    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      //if error, revert the optimistic update
      setState(() {
        if (isFollowing) {
          profileUser.followers.add(currentUser!.uid);
        } else {
          profileUser.followers.remove(currentUser!.uid);
        }
      });
    });
  }

  //build method
  @override
  Widget build(BuildContext context) {
    //is own post
    final isOwnPost = (currentUser?.uid == widget.uid);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        //loaded
        if (state is ProfileLoaded) {
          //get loaded user
          final user = state.profileUser;

          //scaffold
          return ConstrainedScaffold( 
            //appbar
            appBar: AppBar(
              title: Center(child: Text(user.name)),
              foregroundColor: Theme.of(context).colorScheme.primary,

              //button to edit profile
              actions: [
                if (isOwnPost) //only show if it's own profile
                  IconButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(user: user),
                          ),
                        ),
                    icon: Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),

            //body
            body: ListView(
              children: [
                Center(
                  child: Text(
                    user.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                //profile picture
                Center(
                  child: CachedNetworkImage(
                    imageUrl: user.profileImageUrl,
                    //loading..
                    placeholder:
                        (context, url) =>
                            const Center(child: CircularProgressIndicator()),

                    //error
                    errorWidget:
                        (context, url, error) => const Icon(
                          Icons.person,
                          size: 72.0,
                          color: Colors.grey,
                        ),

                    //loaded
                    imageBuilder:
                        (context, imageProvider) => Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                  ),
                ),

                const SizedBox(height: 25),

                // profile stats
                ProfileStats(
                  postsCount: postsCount, 
                  followersCount: user.followers.length, 
                  followingCount: user.following.length,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowerPage(
                        followers: user.followers,
                        following: user.following,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                //follow button
                if (!isOwnPost) //only show if it's not own profile
                  FollowButton(
                    onPressed: followButtonPressed,
                    isFollowing: user.followers.contains(
                      currentUser!.uid,
                    ), //check if current user is following
                  ),

                const SizedBox(height: 25),

                //bio box
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Bio: ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                BioBox(text: user.bio),

                const SizedBox(height: 25),

                //posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Posts",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                //lists of posts from the user
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    //posts loaded
                    if (state is PostsLoaded) {
                      //filter post by user id
                      final userPosts =
                          state.posts
                              .where((post) => post.userId == widget.uid)
                              .toList();

                      postsCount = userPosts.length;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: postsCount,
                        itemBuilder: (context, index) {
                          //get individual post
                          //final post = userPosts[index];

                          //return as post tile ui
                          // return PostTile(
                          //   post: post,
                          //   onDeletePressed:
                          //       () => context.read<PostCubit>().deletePost(
                          //         post.id,
                          //       ),
                          // );
                        },
                      );
                    }
                    //posts loading
                    else if (state is PostsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    //posts error
                    else {
                      return Center(child: Text("No posts available"));
                    }
                  },
                ),

                const SizedBox(height: 10),
              ],
            ),
          );
        }
        //loading
        else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Center(child: Text('No profile found'));
        }
      },
    );
  }
}