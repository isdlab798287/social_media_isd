import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isd_app/features/chat/presentation/components/message.dart';

class ChatService {
  //get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream
  /*

  List<Map<String, dynamic>> =
  [
  {
  'email' : test@gmail.com,
  'name' : test,
  },
  {
  'email' : test@gmail.com,
  'name' : test,
  },
  ]
   */

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go through each individual user
        final user = doc.data();

        //return the user data
        return user;
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, message) async {
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> userIDs = [currentUserID, receiverID];
    userIDs.sort(); // sort to ensure the same ID for both users
    String chatRoomID = userIDs.join('_');

    // add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // get messages stream
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> IDs = [userID, otherUserID];
    IDs.sort(); // sort to ensure the same ID for both users
    String chatRoomID = IDs.join('_');

    // return messages stream
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}