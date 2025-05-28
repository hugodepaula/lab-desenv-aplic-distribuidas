import 'package:offline_first/feature/home/domain/entity/article.dart';

abstract class IHomeLocalRepo {
  Future<List<Article>> getLocalData();
  Future<void> saveLocalData(List<Article> data);
  Future<void> removeLocalData();
  void initWatcher(void Function(List<Article>) callback);
}
