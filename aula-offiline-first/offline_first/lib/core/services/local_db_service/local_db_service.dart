import 'package:isar/isar.dart';

import 'package:offline_first/core/services/local_db_service/i_local_db_service.dart';

class LocalDBService implements ILocalDBService {
  const LocalDBService(this._isar);
  final Isar _isar;
  @override
  Future<List<E>> getData<E>() async {
    try {
      final collection = _isar.collection<E>();
      final data = await collection.where().findAll();
      return data;
    } catch (_) {
      rethrow;
    }
  }

  @override
  void initWatcher<E>(void Function(List<E>) callback) {
    try {
      final collection = _isar.collection<E>();
      collection.watchLazy().listen((event) async {
        final data = await collection.where().findAll();
        callback.call(data);
      });
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> saveData<E>(List<E> list) async {
    try {
      await _isar.writeTxn(() async {
        final collection = _isar.collection<E>();
        for (final item in list) {
          await collection.put(item);
        }
      });
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> removeData<E>() async {
    try {
      await _isar.writeTxn(() async {
        final collection = _isar.collection<E>();
        await collection.clear();
      });
    } catch (_) {
      rethrow;
    }
  }
}
