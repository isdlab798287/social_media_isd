import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isd_app/features/chat/presentation/components/chat_bubble.dart';
import 'package:isd_app/services/chat_service.dart';

class ChatRoomPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID; // This should be set based on the receiver's ID

  ChatRoomPage({super.key, required this.receiverEmail, required this.receiverID});

  // text controller for message input
  final TextEditingController _messageController = TextEditingController();

  // chat and auth services
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // send message function
  Future<void> _sendMessage() async {
    final String message = _messageController.text;
    if (message.isNotEmpty) {
      // send the message using the chat service
      await _chatService.sendMessage(receiverID, message);

      // clear the message input field
      _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receiverEmail)),
      body: Column(
        children: [
          // Display messages here
          Expanded(
            child: _buildMessageList(),
            ),

          // Input field for sending messages
          _buildUserInput(),

        ],),
      );
  }

  // Build the message list
  Widget _buildMessageList() {
    String senderID = _auth.currentUser!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // loading..
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        // return list view
        return ListView(
          reverse: true, // to show the latest message at the bottom
            padding: const EdgeInsets.all(8.0),
          children: 
            snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
            );
      },
    );
  }

  // Build individual message item
  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data['senderID'] == _auth.currentUser!.uid;

    // align message to the right if sender is the current user, otherwise align to the left
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data['message'], isCurrentUser: isCurrentUser),
        ],
      ),
    );
  }

  // Build the message input field
  Widget _buildUserInput(){
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, bottom: 24.0),
      child: Row(
        children: [
          //text field should take up most of the space
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(),

              ),
              obscureText: false,
            ),
          ),
      
          // send button
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 38, 178, 42),
              borderRadius: BorderRadius.circular(30.0),
            ),
            margin: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: Icon(Icons.arrow_upward),
              onPressed: _sendMessage,
            ),
          ),
        ],),
    );
  }
}
