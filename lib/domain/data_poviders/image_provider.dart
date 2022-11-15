import 'dart:io';
import 'package:chat_app/domain/entity/picture.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

class ImagesProvider {
  final _firebaseStorage = FirebaseStorage.instance;
  final picturesDatabase = openDatabase(
    'Pictures_db.db',
    version: 1,
    onOpen: (db) {},
    onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Pictures(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, picture BLOB )');
    },
  );

  // save image in firebase
  Future<String?> saveImageInFirebase({
    required String imageId,
    required XFile? imageFile,
  }) async {
    final ref = _firebaseStorage.ref('images');

    if (imageFile == null) return null;

    // convert image in correct file format and save
    final file = File(imageFile.path);
    await ref.child(imageId).putFile(file);

    return await ref.child(imageId).getDownloadURL();
  }

  // delete image from firebase
  Future<void> deleteImageFromFirebase({
    required String? imageId,
  }) async {
    if (imageId == null || imageId.trim().isEmpty) return;

    final ref = _firebaseStorage.ref('images');
    await ref.child(imageId).delete();
  }

  // load avatar from firebase
  Future<String?> loadAvatarFromFirebase({required String userId}) async {
    if (userId.trim().isEmpty) return null;
    
    return await _firebaseStorage.ref('avatars').child(userId).getDownloadURL();
  }

  // save avatar in firebase
  Future<String?> saveAvatarImageInFirebase({
    required String userId,
    required XFile? imageFile,
  }) async {
    if (userId.trim().isEmpty) return null;

    final ref = _firebaseStorage.ref('avatars');

    if (imageFile == null) return null;

    // conver avatar in correct file format and save
    final file = File(imageFile.path);
    await ref.child(userId).putFile(file);

    return await ref.child(userId).getDownloadURL();
  }

  // delete avatar from firebase
  Future<void> deleteAvatarFromFirebase({
    required String userId,
  }) async {
    if (userId.trim().isEmpty) return;

    final ref = _firebaseStorage.ref('avatars');
    await ref.child(userId).delete();
  }

  // save picure in database in json format
  Future<void> savePictureInDB({required Picture picture}) async {
    final database = await picturesDatabase;

    // check if picture already exists in database and stop if it is true
    if (await getPictureFromDB(title: picture.title) != null) {
      database.update('Pictures', picture.toJson(),
          where: 'title = ?', whereArgs: [picture.title]);
      return;
    }

    await database.insert(
      'Pictures',
      picture.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // load picture from database
  Future<Picture?> getPictureFromDB({required String title}) async {
    final database = await picturesDatabase;

    final result = await database.query(
      'Pictures',
      where: 'title = ?',
      whereArgs: [title],
    );

    return result.isEmpty ? null : Picture.fromJson(json: result[0]);
  }

  // delete picure from database via title
  Future<void> deletePictureFromDB({required String title}) async {
    final database = await picturesDatabase;

    await database.delete(
      'Pictures',
      where: 'title = ?',
      whereArgs: [title],
    );
  }
}
