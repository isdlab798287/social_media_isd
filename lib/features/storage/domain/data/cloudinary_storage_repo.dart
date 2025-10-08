import 'dart:typed_data';
import 'package:isd_app/features/storage/domain/storage_repo.dart';

class CloudinaryStorageRepo implements StorageRepo {
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) async {
    // TODO: Implement later
    return null;
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) async {
    // TODO: Implement later
    return null;
  }

  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) async {
    // TODO: Implement later
    return null;
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) async {
    // TODO: Implement later
    return null;
  }
}
