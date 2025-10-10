import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/auth/domain/entities/app_user.dart';
import 'package:isd_app/features/auth/presentation/components/my_text_field.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:isd_app/features/post/domain/entities/comment.dart';
import 'package:isd_app/features/post/domain/entities/post.dart';
import 'package:isd_app/features/post/presentation/components/comment_tile.dart';
import 'package:isd_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:isd_app/features/post/presentation/cubits/post_states.dart';
import 'package:isd_app/features/profile/domain/entities/profile_user.dart';
import 'package:isd_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:isd_app/features/profile/presentation/pages/profile_page.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  //cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  //current user
  AppUser? currentUser;

  //post user
  ProfileUser? postUser;

  //on startup, fetch the post user
  @override
  void initState() {
    super.initState();
    //fetch the post user
    getCurrentUser();
    fetchPostUser();
  }

  //get current user
  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null && mounted) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  /*
  LIKES
  */

  // user tapped like button
  void toggleLikePost() {
    //curr like status
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    //optimistically like and update the UI
    setState(() {
      if (isLiked) {
        //if already liked, remove the userId from likes
        widget.post.likes.remove(currentUser!.uid);
      } else {
        //if not liked, add the userId to likes
        widget.post.likes.add(currentUser!.uid);
      }
    });

    //update like
    postCubit.toggleLikePost(widget.post.id, currentUser!.uid).catchError((
      error,
    ) {
      //if there's an error, revert the optimistic update
      setState(() {
        if (isLiked) {
          //if already liked, remove the userId from likes
          widget.post.likes.add(currentUser!.uid);
        } else {
          //if not liked, add the userId to likes
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  /*
  COMMENTS
  */

  //comment text controller
  final commentTextController = TextEditingController();

  //open comment box -> this is a placeholder for future implementation
  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: MyTextField(
          controller: commentTextController,
          hintText: "Type a comment",
          obscureText: false,
        ),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),

          //save button
          TextButton(
            onPressed: () {
              addComment();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  //add comment to post
  void addComment() {
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );

    // add comment using cubit
    if (commentTextController.text.isNotEmpty) {
      postCubit
          .addComment(widget.post.id, newComment)
          .then((_) {
            //clear the text field after adding comment
            commentTextController.clear();
          })
          .catchError((error) {
            //handle error if needed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add comment: $error')),
            );
          });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Comment cannot be empty')));
    }
  }

  @override
  void dispose() {
    //dispose text controller
    commentTextController.dispose();
    super.dispose();
  }

  //show options for deletion
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post?'),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),

          //delete button
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  //build ui
  @override
  Widget build(BuildContext context) {
    final bool isOwnPost = currentUser?.uid == widget.post.userId;

    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          //Top section: profile pic, name, delete button
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(uid: widget.post.userId),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //profile pic
                  postUser?.profileImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: postUser!.profileImageUrl,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person),

                          imageBuilder: (context, ImageProvider) => Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : const Icon(Icons.person),

                  const SizedBox(width: 10),

                  //name
                  Text(
                    widget.post.userName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  //delete button
                  if (isOwnPost)
                    //show delete button
                    GestureDetector(
                      onTap: showOptions,
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),

          //image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height: 430),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          //buttons to like comment, timestamp
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      //like button
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(
                          widget.post.likes.contains(currentUser!.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.post.likes.contains(currentUser!.uid)
                              ? Colors.red
                              : Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),

                      const SizedBox(width: 5),

                      //like count
                      Text(
                        widget.post.likes.length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                //comment button
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(
                    Icons.comment,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    size: 14,
                  ),
                ),

                const SizedBox(width: 5),
                //comment count
                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 14,
                  ),
                ),

                const Spacer(),

                //timestamp
                Text(
                  widget.post.timestamp.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),

          //CAPTION
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 20.0,
            ),
            child: Row(
              children: [
                //username
                Text(
                  widget.post.userName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 10),

                //caption text
                Expanded(
                  child: Text(
                    widget.post.text,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          //COMMENT SECTION
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              //LOADED
              if (state is PostsLoaded) {
                //final individull post
                final post = state.posts.firstWhere(
                  (post) => post.id == widget.post.id,
                  orElse: () => widget.post,
                );

                if (post.comments.isNotEmpty) {
                  //how many comments to show
                  final int showCommentCount = post.comments.length > 2
                      ? 2
                      : post.comments.length;

                  //comment section
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: showCommentCount,
                    itemBuilder: (context, index) {
                      //get individual comment
                      final comment = post.comments[index];

                      //comment title UI
                      return CommentTile(comment: comment);
                    },
                  );
                }
              }

              //LOADING
              if (state is PostsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              //ERROR
              else if (state is PostsError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
