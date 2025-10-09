//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/auth/domain/entities/app_user.dart';
import 'package:isd_app/features/post/domain/entities/post.dart';

class PostTile extends StatelessWidget {
  final Post post;
  final AppUser postUser;

  const PostTile({
    super.key,
    required this.post,
    required this.postUser,
  });

 @override
Widget build(BuildContext context) {
  return const Text("Post Tile Placeholder");
}
}