import 'dart:io';
import 'package:canteen_frontend/utils/app_config.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:mime/mime.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: AppConfig.storageUrl);

  // TODO: create a thumbnail from the image
  Future<StorageUploadTask> upload(File file, String userId) async {
    // Reject file sizes > 10MB
    if ((await file.length()) > firebaseStorageMaxUploadSize) {
      print('File size must be < 10MB.');
      return null;
    }

    var fileType = lookupMimeType(file.path);

    if (fileType != null && fileType.split('/')[0] != 'image') {
      print('File type is not Image. Aborting upload.');
      return null;
    }
    var seconds =
        (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).round();

    String filePath =
        'profile_image/$userId/$seconds.${fileType.split('/')[1]}';

    return _storage.ref().child(filePath).putFile(
          file,
          StorageMetadata(contentType: fileType),
        );
  }
}
