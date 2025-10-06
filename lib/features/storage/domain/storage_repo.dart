import 'dart:typed_data';

abstract class StorageRepo {
  //upload profile images on mobile platform
  Future<String?> uploadProfileImageMobile(String path, String fileName);

  //upload profile images on web platform
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName);

  //upload post images on mobile platform
  Future<String?> uploadPostImageMobile(String path, String fileName);
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName);
}
