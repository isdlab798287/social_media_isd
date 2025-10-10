
import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:isd_app/features/storage/domain/storage_repo.dart';

class CloudinaryStorageRepo implements StorageRepo {
  final cloudinary = CloudinaryPublic('di31chwah', 'upload_preset01', cache: false);

  /*
  Profile Pictures upload to storage
  */
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(path, resourceType: CloudinaryResourceType.Image, folder: 'profile_images'),
      );
      return response.secureUrl;
    } catch (e) {
      print('Cloudinary upload error: $e');
      return null;
    }
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) async {

    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          fileBytes,
          identifier: fileName,
          resourceType: CloudinaryResourceType.Image,
          folder: 'profile_images',
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print('Cloudinary upload error: $e');
      return null;
    }
  }
  /*
  Post Pictures
  */

   @override
  Future<String?> uploadPostImageMobile(String path, String fileName) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          path, 
          resourceType: CloudinaryResourceType.Image, 
          folder: 'post_images',),
      );
      return response.secureUrl;
    } catch (e) {
      print('Cloudinary upload error: $e');
      return null;
    }
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          fileBytes,
          identifier: fileName,
          resourceType: CloudinaryResourceType.Image,
          folder: 'post_images',
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print('Cloudinary upload error: $e');
      return null;
    }
  }

}