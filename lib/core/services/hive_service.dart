import 'package:hive/hive.dart';

class HiveBoxService {
  Box<dynamic> getBox(String boxName) {
    return Hive.box(name: boxName);
  }

  void insertBox<T>(
      {required Box<dynamic> box, required String key, required T values}) {
    box.put(key, values);
  }

  T getValues<T>({required Box<dynamic> box, required String key}) {
    return box.get(key);
  }

  void deleteValue({required Box<dynamic> box, required String key}) {
    box.delete(key);
  }
}
