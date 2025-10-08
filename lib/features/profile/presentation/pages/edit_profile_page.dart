import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/auth/presentation/components/my_text_field.dart';
import 'package:isd_app/features/profile/domain/entities/profile_user.dart';
import 'package:isd_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:isd_app/features/profile/presentation/cubits/profile_states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;

  const EditProfilePage({super.key, required this.user});
  
   @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}
class _EditProfilePageState extends State<EditProfilePage> {

final bioTextController = TextEditingController();


//update profile button
void updateProfile() async{
    //profile cubit
    final profileCubit = context.read<ProfileCubit>();

    //prepare images
    //final String uid = widget.user.uid;
    //final String? newBio = bioTextController.text.isNotEmpty ? bioTextController.text : null;
    //final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    //final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    //only update if there is something to update
    if(bioTextController.text.isNotEmpty){
      //update the profile
      profileCubit.updateProfile(
        uid: widget.user.uid,
        newBio: bioTextController.text,
       // imageMobilePath: imageMobilePath,
       // imageWebBytes: imageWebBytes,
      );
    }

   
  }




//BUILD UI
 @override
  Widget build (BuildContext context)
  {
    //SCAFFOLD
    return BlocConsumer<ProfileCubit,ProfileState>(
      builder: (context, state)
      {
// profile loading
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
return buildEditPage() 
}
//profile error


 },
      listener: (context, state){
if(state is ProfileLoaded)
{
  Navigator.pop(context);
  }



     }
      );
  }
  Widget buildEditPage(double uploadProgress = 0.0)
  {
return Scaffold(
  appBar: AppBar(
    title:const Text("Edit Profile"),
    foregroundColor: Theme.of(context).colorScheme.primary,

    actions: [
      //save button 
      IconButton(onPressed: updateProfile, 
      icon: const Icon(Icons.upload),
      )   
       ],
    ),

body: Column(

  children: [
//profile picture 


//bio
const Text("Bio"),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 25.0),
child: MyTextField(
  controller: bioTextController, 
hintText: widget.user.bio,
obscureText: false,
),
),
  ],
),
);

  }
}