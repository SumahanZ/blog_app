import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxService {
  static Future<Box<dynamic>> openBox(String boxName) async {
    return await Hive.openBox(boxName);
  }

  static Box<dynamic> getBox(String boxName) {
    return Hive.box(boxName);
  }

  static void insertBox<T>(
      {required Box<dynamic> box, required String key, required T values}) {
    box.put(key, values);
  }

  static T getValues<T>({required Box<dynamic> box, required String key}) {
    return box.get(key);
  }

  static void deleteValue({required Box<dynamic> box, required String key}) {
    box.delete(key);
  }
}
