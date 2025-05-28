import 'package:logger/logger.dart';

import 'package:offline_first/core/dependency_injection/di.dart';
import 'package:offline_first/core/usecase/i_usecase.dart';
import 'package:offline_first/feature/home/domain/entity/article.dart';
import 'package:offline_first/feature/home/domain/repo/i_home_remote_repo.dart';

class GetNewsFromNetworkUsecase implements Usecase<List<Article>, NoParams?> {
  const GetNewsFromNetworkUsecase(this._repo);
  final IHomeRemoteRepo _repo;

  @override
  Future<List<Article>> call(_) async {
    sl<Logger>().i('Getting values from NETWORK...');
    return _repo.getNews();
  }
}
