import 'package:isd_app/features/post/domain/entities/post.dart';
import 'package:isd_app/features/post/domain/repos/post_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //store the posts in a collection called post
  final CollectionReference postsCollection = FirebaseFirestore.instance
      .collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      //get all post with most recent post first
      final postsSnapshot = await postsCollection
          .orderBy('timestamp', descending: true)
          .get();

      //convert each firestore document from json to post object
      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allPosts;
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {
      //fetch posts snapshot with userId
      final postsSnapshot = await postsCollection
          .where('userId', isEqualTo: userId)
          .get();

      //convert each firestore document from json to post object
      final userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return userPosts;
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }
}
