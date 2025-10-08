import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data';
import 'package:isd_app/features/post/domain/entities/post.dart';
import 'package:isd_app/features/post/domain/repos/post_repo.dart';
import 'package:isd_app/features/post/presentation/cubits/post_states.dart';
import 'package:isd_app/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  //final StorageRepo storageRepo;

  PostCubit({required this.postRepo, })
    : super(PostsInitial());

  //create a new post
  Future<void> createPost(
    Post post, {
    String? imagePath,
    Uint8List? imageBytes,
  }) async {
    String? imageUrl;

    try {
      //handle image upload for mobile platforms (using file path)
      if (imagePath != null) {
        emit(PostUploading());
        //imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }
      //handle image upload for web platforms (using bytes)
      else if (imageBytes != null) {
        emit(PostUploading());
        //imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      //give image url to post
      final newPost = post.copyWith(imageUrl: imageUrl);

      //create post in the backend
      postRepo.createPost(newPost);

      //refetch all posts
      fetchAllPosts();
    } catch (e) {
      emit(PostsError("failed to create post: $e"));
    }
  }

  //fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      print("🟡 Fetching posts...");
      final posts = await postRepo.fetchAllPosts();
      print("✅ Fetched posts: ${posts.length}");
      emit(PostsLoaded(posts));
    } catch (e) {
      print("❌ Error: $e");
      emit(PostsError("failed to fetch posts: $e"));
    }
  }

  //delete post
  Future<void> deletePost(String postId) async {
    try {
      emit(PostsLoading());
      await postRepo.deletePost(postId);
      fetchAllPosts();
    } catch (e) {
      emit(PostsError("failed to delete post: $e"));
    }
  }
}
