import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImagesProvider {
  final _firebaseStorage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  // load image from firebase
  Future<String?> loadImageFromFirebase({required String userId}) async {
    if (userId.trim().isEmpty) return null;

    return await _firebaseStorage.ref('images').child(userId).getDownloadURL();
  }

  // set image in firebase
  Future<String?> setImageInFirebaseFromGallery({
    required String messageId,
  }) async {
    if (messageId.trim().isEmpty) return null;

    final ref = _firebaseStorage.ref('images');
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    final file = File(image.path);

    await ref.child(messageId).putFile(file);

    return await ref.child(messageId).getDownloadURL();
  }

  // delete image from firebase
  Future<void> deleteImageInFirebaseFromGallery({
    required String messageId,
  }) async {
    if (messageId.trim().isEmpty) return;

    final ref = _firebaseStorage.ref('images');
    await ref.child(messageId).delete();
  }

  // set image in firebase
  Future<String?> setAvatarImageInFirebaseFromGallery({
    required String userId,
  }) async {
    if (userId.trim().isEmpty) return null;

    final ref = _firebaseStorage.ref('avatars');
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    final file = File(image.path);

    await ref.child(userId).putFile(file);

    return await ref.child(userId).getDownloadURL();
  }

  // delete image from firebase
  Future<void> deleteAvatarImageInFirebaseFromGallery({
    required String userId,
  }) async {
    if (userId.trim().isEmpty) return;

    final ref = _firebaseStorage.ref('avatars');
    await ref.child(userId).delete();
  }
}
