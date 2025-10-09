import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/home/presentation/components/my_drawer.dart';
import 'package:isd_app/features/post/presentation/components/post_tile.dart';
import 'package:isd_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:isd_app/features/post/presentation/cubits/post_states.dart';
import 'package:isd_app/features/post/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //post cubit
  late final postCubit = context.read<PostCubit>();

  //on startup, fetch posts
  @override
  void initState() {
    super.initState();
    //fetch posts
    fetchAllPosts();
  }

  void fetchAllPosts() async {
    //fetch posts
    context.read<PostCubit>().fetchAllPosts();
  }

  void deletePost(String postId) {
    //delete post
    context.read<PostCubit>().deletePost(postId);
    //fetch posts
    fetchAllPosts();
  }

  //build ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          //upload new post button
          IconButton(
            onPressed: () => Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => UploadPostPage(), // Assuming you have an UploadPostPage
            )),
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      //Drawer
      drawer: MyDrawer(),

      //body
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          //loading
          if(state is PostsLoading  || state is PostUploading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          //loaded
          if (state is PostsLoaded) {
            //get posts
            final allPosts = state.posts;

            if(allPosts.isEmpty){
              return const Center(
                child: Text('No posts yet'),
              );
            }

            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                //get post
                final post = allPosts[index];

                // return PostTile(
                //   post: post,
                //   onDeletePressed: () => deletePost(post.id),
                // );
              },
            );
          }
          

          //error
          else if (state is PostsError) {
            return Center(
              child: Text(
                state.message,
              ),
            );
          }
          else {
            return const SizedBox();
          }
        }
        ),

    );
  }
}