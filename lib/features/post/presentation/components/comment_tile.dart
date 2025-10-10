import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/auth/domain/entities/app_user.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:isd_app/features/post/domain/entities/comment.dart';
import 'package:isd_app/features/post/presentation/cubits/post_cubit.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  //current user id
  AppUser? currentUser;
  bool isOwnPost = false;

  @override
  void initState() {
    super.initState();
    //get current user
    getCurrentUser();
  }

  //get current user
  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();

    // For demonstration, let's assume we have a mock user
    currentUser = authCubit.currentUser;

    // Check if the comment belongs to the current user
    isOwnPost = widget.comment.userId == currentUser!.uid;
  }

  //show options for deletion
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment?'),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),

          //delete button
          TextButton(
            onPressed: () {
              context.read<PostCubit>().deleteComment(
                widget.comment.postId,
                widget.comment.id,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          //comment user name
          Text(
            widget.comment.userName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 10),

          //comment text
          Expanded(
            child: Text(
              widget.comment.text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          const Spacer(),

          //delete button
          if (isOwnPost)
            GestureDetector(
              onTap: showOptions,
              child: Icon(
                Icons.more_horiz,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}
