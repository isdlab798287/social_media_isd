import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart'; // Correct Cloudinary package
import 'package:isd_app/features/storage/domain/storage_repo.dart';

class CloudinaryStorageRepo implements StorageRepo {
  // Use CloudinaryPublic instead of Cloudinary
  final cloudinary = CloudinaryPublic(
    ' dbrlugywi', // Cloud Name
    'upload_preset01', // Unsigned Upload Preset
    cache: false,
  );

  // Upload Profile Image on Mobile Platform (File path)
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          path,
          folder: 'profile_images',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  // Upload Profile Image on Web Platform (Byte data)
  @override
  Future<String?> uploadProfileImageWeb(
    Uint8List fileBytes,
    String fileName,
  ) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          fileBytes,
          identifier: fileName,
          folder: 'profile_images',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  // Upload Post Image on Mobile Platform (File path)
  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          path,
          folder: 'post_images',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  // Upload Post Image on Web Platform (Byte data)
  @override
  Future<String?> uploadPostImageWeb(
    Uint8List fileBytes,
    String fileName,
  ) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          fileBytes,
          identifier: fileName,
          folder: 'post_images',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }
}
