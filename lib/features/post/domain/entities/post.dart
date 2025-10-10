import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isd_app/features/post/domain/entities/comment.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> likes; //store uids
  final List<Comment> comments; //store comment ids

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  Post copyWith({String? imageUrl}) {
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      text: text,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp,
      likes: likes, // Ensure likes is a copy
      comments: comments, // Ensure comments is a copy
    );
  }

  // Convert a Post object to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
      'comments': comments
          .map((comment) => comment.toJson())
          .toList(), // Store comments as a list of comment IDs
    };
  }

  // Convert a json object to a Post object
  factory Post.fromJson(Map<String, dynamic> json) {
    //prepare comments
    final List<Comment> comments =
        (json['comments'] as List<dynamic>?)
            ?.map(
              (commentJson) =>
                  Comment.fromJson(commentJson as Map<String, dynamic>),
            )
            .toList() ??
        [];

    return Post(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(json['likes'] ?? []), // Ensure likes is a list
      comments: comments,
    );
  }
}
