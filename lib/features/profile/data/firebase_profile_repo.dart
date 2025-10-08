import 'package:isd_app/features/profile/domain/entities/profile_user.dart';
import 'package:isd_app/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  get firebaseFirestore => null;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
final userDoc = await firebaseFirestore.collection('users').doc(uid).get();

      if(userDoc.exists){
        final userData = userDoc.data();
       
        if(userData != null){
          //fetch followers and following lists
          //final followers = List<String>.from(userData['followers'] ?? []);
          //final following = List<String>.from(userData['following'] ?? []);

          //create and return ProfileUser object
          return ProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
            //followers: followers,
            //following: following,
          );
        }
    }
    }

    catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updateProfile) async {
   try{
 //convert the profile user to json to store in firestore
      await firebaseFirestore
      .collection('users')
      .doc(updateProfile.uid)
      .update({
        'bio': updateProfile.bio,
        'profileImageUrl': updateProfile.profileImageUrl,
      });
   }

   catch (e) {
    throw Exception(e);
   }
  }
}