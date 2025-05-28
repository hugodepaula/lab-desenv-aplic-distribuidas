import 'package:offline_first/core/usecase/i_usecase.dart';
import 'package:offline_first/feature/home/domain/entity/article.dart';
import 'package:offline_first/feature/home/domain/repo/i_home_local_repo.dart';

class WatchNewsFromLocalDBUsecase
    implements Usecase<void, void Function(List<Article>)> {
  const WatchNewsFromLocalDBUsecase(this._homeLocalRepo);
  final IHomeLocalRepo _homeLocalRepo;

  @override
  void call(void Function(List<Article>) callback) {
    return _homeLocalRepo.initWatcher(callback);
  }
}
