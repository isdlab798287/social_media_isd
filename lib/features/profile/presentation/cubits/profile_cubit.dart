import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/profile/domain/entities/profile_user.dart';
import 'package:isd_app/features/profile/domain/repos/profile_repo.dart';
import 'package:isd_app/features/profile/presentation/cubits/profile_states.dart';
import 'package:isd_app/features/storage/domain/storage_repo.dart';


class ProfileCubit extends Cubit<ProfileState>{
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({
    required this.profileRepo,
    required this.storageRepo,
    }) : super(ProfileInitial());

  //fetch the user profile using repo -> useful for loading profile pages
  Future<void> fetchUserProfile(String uid) async {
    
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);
      
      if (user != null) {
        emit(ProfileLoaded(user));
      } 
      else {
        emit(ProfileError('User not found'));
      }

    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  //return user profile given uid -> userful for loading many profiles for posts
 Future<ProfileUser?> getUserProfile(String uid) async {
    
      final user = await profileRepo.fetchUserProfile(uid);
      return user;
  }

  //update the user profile using repo

  Future<void> updateProfile({required String uid, String? newBio, Uint8List? imageWebBytes, String? imageMobilePath,}) async {
    emit(ProfileLoading());
    try {
      //fetch the user profile
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileError('User not found'));
        return;
      }

      //Profile picture update
     String? imageDownloadUrl;

      //check if the image is not null
      if (imageWebBytes != null || imageMobilePath != null) {
        //for mobile
        if (imageMobilePath != null) {
          imageDownloadUrl = await storageRepo.uploadProfileImageMobile(imageMobilePath, uid);
        }

        //for web
        else if (imageWebBytes != null) {
          imageDownloadUrl = await storageRepo.uploadProfileImageWeb(imageWebBytes, uid);
        }

        if(imageDownloadUrl == null){
          emit(ProfileError('Error uploading image'));
          return;
        }
      }

      //update the profile user
      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );
      //update the profile using repo
      await profileRepo.updateProfile(updatedProfile);

      //refetch the updated profile
      await fetchUserProfile(uid);

    } catch (e) {
      emit(ProfileError('Error updating user profile: $e'));
    }
  }

  //toggle follow using repo
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    
    try {
      await profileRepo.toggleFollow(currentUid, targetUid);
      
    } catch (e) {
      emit(ProfileError('Error toggling follow: $e'));
    }
  }
}