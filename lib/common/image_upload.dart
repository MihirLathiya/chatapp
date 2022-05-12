import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<String?> uploaddImage(File? file, String fileName) async {
  try {
    final imageData = await firebase_storage.FirebaseStorage.instance
        .ref('user_image$fileName')
        .putFile(file!);
    return imageData.storage.ref('user_image$fileName').getDownloadURL();
  } on firebase_storage.FirebaseException catch (e) {
    print(e);
  }
}
//
// Future<String?> up(File file, String fileName) async {
//   try {
//     final response = await firebase_storage.FirebaseStorage.instance
//         .ref('image/$fileName')
//         .putFile(file);
//     return response.storage.ref(fileName).getDownloadURL();
//   } on firebase_storage.FirebaseException catch (e) {
//     print(e);
//   }
// }
