import 'dart:io';
import 'package:file_picker/file_picker.dart'
    show FilePicker, FileType, PlatformFile;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/auth/domain/entities/app_user.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:isd_app/features/post/domain/entities/post.dart';
import 'package:isd_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:isd_app/features/post/presentation/cubits/post_states.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  //mobile image pick
  PlatformFile? imagePickedFile;

  //web image pick
  Uint8List? webImage;

  //text field controllers -> caption
  final textController = TextEditingController();

  //current user
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    //get current user
    getCurrentUser();
  }

  //get current user
  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    setState(() {
      currentUser = authCubit.currentUser;
    });
  }

  //select image
  Future<void> pickImage() async {
    //pick image
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    //check if the image is not null
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        if (kIsWeb) {
          webImage = imagePickedFile?.bytes;
        }
      });
    }
  }

  //create and upload post
  void uploadPost() {
    //check if both image and caption are not null
    if (imagePickedFile == null && textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both image and caption are required')),
      );
      return;
    }

    print("🧠 Uploading post as ${currentUser?.name}");

    //create a new post object
    final newPost = Post(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: '',
      timestamp: DateTime.now(),
    );

    //post cubit
    final postCubit = context.read<PostCubit>();

    //web image upload
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    }
    //mobile image upload
    else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  //dispose text field controller
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  //build ui
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        //loading or uploading state
        if (state is PostUploading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        //build upload page
        return buildUploadPage();
      },

      //go to prev page
      listener: (context, state) {
        if (state is PostsLoaded) {
          //show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post uploaded successfully')),
          );

          //pop the upload page
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          //upload post button
          IconButton(onPressed: uploadPost, icon: const Icon(Icons.upload)),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            //image preview for web
            if (kIsWeb && webImage != null) Image.memory(webImage!),

            //image preview for mobile
            if (!kIsWeb && imagePickedFile != null)
              Image.file(File(imagePickedFile!.path!), height: 200, width: 200),

            //pick image button
            MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text('Pick Image'),
            ),

            //text field for caption
            TextField(
              controller: textController,
              obscureText: false,
              decoration: const InputDecoration(
                hintText: 'Enter caption',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
