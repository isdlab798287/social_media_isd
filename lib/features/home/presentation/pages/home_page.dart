import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/home/presentation/components/my_drawer.dart';
import 'package:isd_app/features/post/presentation/components/post_tile.dart';
import 'package:isd_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:isd_app/features/post/presentation/cubits/post_states.dart';
import 'package:isd_app/features/post/presentation/pages/upload_post_page.dart';
import 'package:isd_app/responsive/constrained_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final postCubit = context.read<PostCubit>();

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

  Future<void> fetchAllPosts() async {
    await context.read<PostCubit>().fetchAllPosts();
  }

  void deletePost(String postId) {
    context.read<PostCubit>().deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text('Home'),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UploadPostPage()),
            ).then((_) {
              // Refresh after returning from upload page
              fetchAllPosts();
            }),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          // Loading state
          if (state is PostsLoading || state is PostUploading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Loaded state
          if (state is PostsLoaded) {
            final allPosts = state.posts;

            if (allPosts.isEmpty) {
              return RefreshIndicator(
                onRefresh: fetchAllPosts,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 300),
                    Center(child: Text('No posts yet')),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: fetchAllPosts,
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: allPosts.length,
                itemBuilder: (context, index) {
                  final post = allPosts[index];
                  return PostTile(
                    post: post,
                    onDeletePressed: () => deletePost(post.id),
                  );
                },
              ),
            );
          }

          // Error state
          else if (state is PostsError) {
            return RefreshIndicator(
              onRefresh: fetchAllPosts,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 300),
                  Center(child: Text('Error: ${state.message}')),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
