import 'package:isd_app/features/post/domain/entities/comment.dart';
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

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      //get the post doc from Firestore
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        //get the post data
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        //check if the userId is already in the likes list
        final hasLiked = post.likes.contains(userId);

        //update the likes list
        if (hasLiked) {
          //remove the userId from the likes list
          post.likes.remove(userId);
        } else {
          //add the userId to the likes list
          post.likes.add(userId);
        }

        //update the post in Firestore
        await postsCollection.doc(postId).update({'likes': post.likes});
      } else {
        throw Exception('Post does not exist');
      }
    } catch (e) {
      throw Exception('Failed to toggle like post: $e');
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      //get the post doc from Firestore
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        //get the post data
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        //add the comment to the post's comments list
        post.comments.add(comment);

        //update the post in Firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList(),
        });
      } else {
        throw Exception('Post does not exist');
      }
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      //get the post doc from Firestore
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        //get the post data
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        //add the comment to the post's comments list
        post.comments.removeWhere((comment) => comment.id == commentId);

        //update the post in Firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList(),
        });
      } else {
        throw Exception('Post does not exist');
      }
    } catch (e) {
      throw Exception('Failed deleting comment: $e');
    }
  }
}
