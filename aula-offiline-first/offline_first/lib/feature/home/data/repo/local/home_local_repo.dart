import 'package:offline_first/core/services/local_db_service/i_local_db_service.dart';
import 'package:offline_first/feature/home/data/model/local/article_local_model.dart';
import 'package:offline_first/feature/home/domain/entity/article.dart';
import 'package:offline_first/feature/home/domain/repo/i_home_local_repo.dart';

class HomeLocalRepo implements IHomeLocalRepo {
  const HomeLocalRepo(this._localDBService);

  final ILocalDBService _localDBService;
  @override
  Future<List<Article>> getLocalData() async {
    try {
      final result = await _localDBService.getData<ArticleLocalModel>();
      return result.map((e) => e.toEntity).toList();
    } catch (_) {
      rethrow;
    }
  }

  @override
  void initWatcher(void Function(List<Article> data) callback) {
    try {
      _localDBService.initWatcher<ArticleLocalModel>(
        (List<ArticleLocalModel> data) {
          final result = data.map((e) => e.toEntity).toList();
          callback.call(result);
        },
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> saveLocalData(List<Article> data) async {
    try {
      await _localDBService.saveData(
        data
            .map(
              (e) => ArticleLocalModel().fromEntity(e),
            )
            .toList(),
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> removeLocalData() async {
    try {
      await _localDBService.removeData<ArticleLocalModel>();
    } catch (_) {
      rethrow;
    }
  }
}
