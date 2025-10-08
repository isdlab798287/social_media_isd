import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/auth/presentation/components/my_text_field.dart';
import 'package:isd_app/features/profile/domain/entities/profile_user.dart';
import 'package:isd_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:isd_app/features/profile/presentation/cubits/profile_states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;

  const EditProfilePage({
    super.key,
    required this.user,
    });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  //mobile image picker
  PlatformFile? imagePickedFile;

  //web image picker
  Uint8List? webImage;


  final bioTextController = TextEditingController();

  //pick image
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

        if(kIsWeb){
          webImage = imagePickedFile?.bytes;
        }
      });
    }
  }

  //update profile button pressed
  void updateProfile() async{
    //profile cubit
    final profileCubit = context.read<ProfileCubit>();

    //prepare images
    final String uid = widget.user.uid;
    final String? newBio = bioTextController.text.isNotEmpty ? bioTextController.text : null;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    //only update if there is something to update
    if(imagePickedFile != null || newBio != null){
      //update the profile
      profileCubit.updateProfile(
        uid: uid,
        newBio: newBio,
        imageMobilePath: imageMobilePath,
        imageWebBytes: imageWebBytes,
      );
    }

    //nothing to update
    else{
      //pop the edit page
      Navigator.pop(context);
    }
  }

  //Build UI
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state){

        //loading state

        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("data loading..."),
                ],
              ),
            ),
          );
        }

        else{
           //edit form
          return buildEditPage();
        }
       
      },

      listener: (context, state){
        if(state is ProfileLoaded){
          //pop the edit page
          Navigator.pop(context);
          
        }
      },
      );
  }

  Widget buildEditPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          //save button
          IconButton(
            onPressed: updateProfile,
            icon: const Icon(Icons.upload),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            //profile picture
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.hardEdge,
                height: 200,
                width: 200,
                padding: const EdgeInsets.all(25.0),
                child: 
                //display selected image for mobile
                (!kIsWeb && imagePickedFile != null) ?
                Image.file(
                  File(imagePickedFile!.path!),
                  fit: BoxFit.cover,
                ):


                //display image for web
                (kIsWeb && webImage != null) ?
                Image.memory(
                  webImage!,
                  fit: BoxFit.cover,
                ):

                //no image selected ->display default image
                CachedNetworkImage(
                  imageUrl: widget.user.profileImageUrl,
                //loading..
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),

                //error
                errorWidget: (context, url, error) => 
                const Icon(
                  Icons.person, 
                  size: 72.0, 
                  color: Colors.grey,
                  ),

                //loaded
                imageBuilder: (context, imageProvider) => 
                Image(image: imageProvider),
                fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            //pick image button
            Center(
              child: MaterialButton(
                onPressed: pickImage,
                color: Colors.blue,
                child: const Text("pick image"),
                ),
            ),

            //bio text field
            const Text('Bio'),

            const SizedBox(height: 10),

            MyTextField(
              controller: bioTextController, 
              hintText: widget.user.bio, 
              obscureText: false),
          ],
        ),
      ),
    );
  }
}