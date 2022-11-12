import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class LanguageProvider {
  // final languagesDatabase = openDatabase(
  //   'Languages_db.db',
  //   version: 1,
  //   onOpen: (db) {},
  //   onCreate: (Database db, int version) async {
  //     await db.execute(
  //         'CREATE TABLE Languages(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, language_code TEXT, is_selected BOOLEAN)');
  //   },
  // );

  // Future<Map<String, Object?>> getLanguage({required int index}) async {
  //   final database = await languagesDatabase;

  //   final result = await database.query(
  //     'Languages',
  //     where: 'id = ?',
  //     whereArgs: [index],
  //   );

  //   return result[0];
  // }

  // Future<void> getAllLanguages() async {}

  // Future<int> getCurrentLanguageIndex() async {
  //   final database = await languagesDatabase;

  //   final result = await database.query(
  //     'Languages',
  //     where: 'is_selected = ?',
  //     whereArgs: [true],
  //   );

  //   return result[0]['id'] as int;
  // }

  // Future<String> getCurrentLanguageCode() async {
  //   final database = await languagesDatabase;

  //   final result = await database.query(
  //     'Languages',
  //     where: 'is_selected = ?',
  //     whereArgs: [true],
  //   );

  //   return result[0]['language_code'] as String;
  // }

  // Future<void> setLanguage({required int index}) async {
  //   final database = await languagesDatabase;
  //   Map<String, Object?> language;

  //   // delete old language
  //   int oldLanguageIndex = await getCurrentLanguageIndex();
  //   language = await getLanguage(index: oldLanguageIndex);
  //   language['is_selected'] = false;
  //   database.update('Languages', language,
  //       where: 'id = ?', whereArgs: [oldLanguageIndex]);

  //   // set new language
  //   language = await getLanguage(index: index);
  //   language['is_selected'] = true;
  //   database.update('Languages', language,
  //       where: 'id = ?', whereArgs: [index]);
  // }

  final languageConst = 'language';

  Future<void> changeLanguage({required String languageCode}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageConst, languageCode);
  }

  Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(languageConst);
  }
}
