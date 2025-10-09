import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isd_app/features/chat/presentation/pages/chat_room_page.dart';
import 'package:isd_app/features/profile/presentation/components/user_tile.dart';
import 'package:isd_app/services/chat_service.dart';
import 'package:isd_app/features/profile/domain/entities/profile_user.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchController.addListener(_filterUsers);
  }

  Future<void> _loadUsers() async {
    _chatService.getUsersStream().listen((snapshot) {
      final data = snapshot.map((doc) => doc as Map<String, dynamic>).toList();
      setState(() {
        _allUsers = data;
        _filteredUsers = data;
      });
    });
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _allUsers.where((userData) {
        final name = userData['name']?.toLowerCase() ?? '';
        final email = userData['email']?.toLowerCase() ?? '';
        return name.contains(query) || email.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = _auth.currentUser?.email;

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          // 🔍 Search Field
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          // 👥 User List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final userData = _filteredUsers[index];

                if (userData['email'] == currentUserEmail) return Container();

                final profileUser = ProfileUser(
                  uid: userData['uid'] ?? '',
                  name: userData['name'] ?? '',
                  email: userData['email'] ?? '',
                  bio: '',
                  profileImageUrl: userData['profileImageUrl'] ?? '',
                  followers: const [],
                  following: const [],
                );

                return UserTile(
                  user: profileUser,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoomPage(
                          receiverEmail: profileUser.email,
                          receiverID: profileUser.uid,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}